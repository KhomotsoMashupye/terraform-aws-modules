provider "aws" {
  region = var.aws_region
}

# VPC Endpoints

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.public_route_table_ids
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.public_route_table_ids
}

# Virtual Private Gateway

resource "aws_vpn_gateway" "vgw" {
  vpc_id  = var.vpc_id
  tags = {
    Name = "private-vgw"
  }
}

# Direct Connect Gateway

resource "aws_dx_gateway" "direct_connect" {
  name      = "private-dx-gateway"
  amazon_side_asn = var.dx_gateway_asn
}

# Network ACL for private subnets

resource "aws_network_acl" "private_nacl" {
  vpc_id = var.vpc_id
  subnet_ids = var.private_subnet_ids

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "private-nacl"
  }
}

# Route 53 Private Hosted Zone

resource "aws_route53_zone" "private_zone" {
  name = var.route53_zone_name
  vpc {
    vpc_id = var.vpc_id
  }
  comment = "Private hosted zone for testing"
}