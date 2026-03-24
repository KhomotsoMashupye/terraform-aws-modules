# Provider
provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "placeholder_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets
resource "aws_subnet" "placeholder_public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.placeholder_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "placeholder_private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.placeholder_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "placeholder_igw" {
  vpc_id = aws_vpc.placeholder_vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Public Route Table
resource "aws_route_table" "placeholder_public_rt" {
  vpc_id = aws_vpc.placeholder_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.placeholder_igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "placeholder_public_assoc" {
  count          = length(aws_subnet.placeholder_public)
  subnet_id      = aws_subnet.placeholder_public[count.index].id
  route_table_id = aws_route_table.placeholder_public_rt.id
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "placeholder_nat_eip" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"
}

# NAT Gateways
resource "aws_nat_gateway" "placeholder_nat" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.placeholder_nat_eip[count.index].id
  subnet_id     = aws_subnet.placeholder_public[count.index].id

  tags = {
    Name = "${var.vpc_name}-nat-${count.index + 1}"
  }
}

# Private Route Tables
resource "aws_route_table" "placeholder_private_rt" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.placeholder_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.placeholder_nat[count.index].id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt-${count.index + 1}"
  }
}

# Private Route Table Associations
resource "aws_route_table_association" "placeholder_private_assoc" {
  count          = length(aws_subnet.placeholder_private)
  subnet_id      = aws_subnet.placeholder_private[count.index].id
  route_table_id = aws_route_table.placeholder_private_rt[count.index].id
}