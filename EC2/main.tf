terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# VPC + SUBNET (for testing)

resource "aws_vpc" "placeholder_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "placeholder-vpc"
  }
}

resource "aws_subnet" "placeholder_subnet" {
  vpc_id                  = aws_vpc.placeholder_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "placeholder-subnet"
  }
}

resource "aws_internet_gateway" "placeholder_igw" {
  vpc_id = aws_vpc.placeholder_vpc.id
}

resource "aws_route_table" "placeholder_rt" {
  vpc_id = aws_vpc.placeholder_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.placeholder_igw.id
  }
}

resource "aws_route_table_association" "placeholder_assoc" {
  subnet_id      = aws_subnet.placeholder_subnet.id
  route_table_id = aws_route_table.placeholder_rt.id
}


# SECURITY GROUP

resource "aws_security_group" "placeholder_sg" {
  name   = "placeholder-sg"
  vpc_id = aws_vpc.placeholder_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# ON-DEMAND EC2 INSTANCES

resource "aws_instance" "on_demand" {
  count         = var.instance_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.placeholder_subnet.id

  vpc_security_group_ids = [aws_security_group.placeholder_sg.id]

  tags = {
    Name = "placeholder-ondemand-${count.index + 1}"
  }
}


# SPOT INSTANCE

resource "aws_instance" "spot" {
  count         = var.create_spot ? 1 : 0
  ami           =  data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.placeholder_subnet.id

  instance_market_options {
    market_type = "spot"
  }

  vpc_security_group_ids = [aws_security_group.placeholder_sg.id]

  tags = {
    Name = "placeholder-spot"
  }
}


# LAUNCH TEMPLATE

resource "aws_launch_template" "placeholder_lt" {
  count       = var.create_asg ? 1 : 0
  name_prefix = "placeholder-lt"

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  network_interfaces {
    security_groups = [aws_security_group.placeholder_sg.id]
  }
}


# AUTO SCALING GROUP

resource "aws_autoscaling_group" "placeholder_asg" {
  count               = var.create_asg ? 1 : 0
  desired_capacity    = var.asg_desired
  max_size            = var.asg_max
  min_size            = var.asg_min
  vpc_zone_identifier = [aws_subnet.placeholder_subnet.id]

  launch_template {
    id      = aws_launch_template.placeholder_lt[0].id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "placeholder-asg"
    propagate_at_launch = true
  }
}

# STANDALONE EC2

resource "aws_instance" "standalone_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.placeholder_subnet.id

  vpc_security_group_ids = [aws_security_group.placeholder_sg.id]

  tags = {
    Name = "placeholder-standalone-ec2"
  }
}
 # USER DATA(used to avoid manually sshing into an instance)

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>EC2 Instance $(hostname)</h1>" > /var/www/html/index.html
              EOF


