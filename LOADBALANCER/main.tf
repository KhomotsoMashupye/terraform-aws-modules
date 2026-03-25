# LOADBALANCER SECURITY GROUP

resource "aws_security_group" "alb_sg" {
  name   = "placeholder-alb-sg"
  vpc_id = aws_vpc.placeholder_vpc.id

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
# APPLICATION LOADBALANCER

resource "aws_lb" "placeholder_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.placeholder_subnet.id]

  tags = {
    Name = "placeholder-alb"
  }
}

# TARGET GROUP

resource "aws_lb_target_group" "placeholder_tg" {
  name     =  var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.placeholder_vpc.id

  health_check {
    path = "/"
    port = var.alb_port
  }
}

# LISTENER
resource "aws_lb_listener" "placeholder_listener" {
  load_balancer_arn = aws_lb.placeholder_alb.arn
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.placeholder_tg.arn
  }
}

# ATTACH EC2 TO TARGET GROUP

resource "aws_lb_target_group_attachment" "ec2_attach" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.placeholder_tg.arn
  target_id        = aws_instance.on_demand[count.index].id
  port             = var.alb_port
}

# Classic ELB
resource "aws_elb" "classic" {
  count            = var.lb_type == "classic" ? 1 : 0
  name             = var.lb_name
  subnets          = var.subnet_ids
  security_groups  = var.security_groups

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  instances = var.target_instance_ids

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
}
