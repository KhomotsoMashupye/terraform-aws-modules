variable "aws_region" {
  default = "af-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  default = "af-south-1a"
}

# EC2
variable "instance_count" {
  default = 2
}

variable "instance_type" {
  default = "t3.micro"
}


# Spot
variable "create_spot" {
  default = true
}

# ASG
variable "create_asg" {
  default = true
}

variable "asg_min" {
  default = 1
}

variable "asg_max" {
  default = 2
}

variable "asg_desired" {
  default = 1
}