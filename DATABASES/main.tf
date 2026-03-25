provider "aws" {
  region = var.aws_region
}

# Security Group for Databases

resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = "Allow access to databases"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = var.allowed_cidrs
    description     = "Full access for testing"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Subnet Group for RDS / Aurora
resource "aws_db_subnet_group" "db_subnets" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}

#  Standard RDS instance 
resource "aws_db_instance" "rds" {
  identifier             = var.rds_identifier
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_allocated_storage
  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  multi_az               = var.rds_multi_az
  publicly_accessible    = false
  backup_retention_period = var.rds_backup_days
  skip_final_snapshot    = true
  tags                   = var.tags
}

# RDS Read Replica
resource "aws_db_instance" "rds_read_replica" {
  count               = var.rds_create_read_replica ? 1 : 0
  identifier          = "${var.rds_identifier}-replica"
  replicate_source_db = aws_db_instance.rds.id
  instance_class      = var.rds_instance_class
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true
  tags                 = var.tags
}

# Aurora Cluster 
resource "aws_rds_cluster" "aurora_cluster" {
  count                 = var.create_aurora ? 1 : 0
  cluster_identifier    = var.aurora_identifier
  engine                = "aurora-postgresql"
  engine_version        = var.aurora_engine_version
  master_username       = var.aurora_username
  master_password       = var.aurora_password
  database_name         = var.aurora_db_name
  backup_retention_period = var.aurora_backup_days
  db_subnet_group_name  = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  tags                  = var.tags
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = var.create_aurora ? var.aurora_instance_count : 0
  identifier         = "${var.aurora_identifier}-instance-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora_cluster[0].id
  instance_class     = var.aurora_instance_class
  engine             = "aurora-postgresql"
  publicly_accessible = false
  tags               = var.tags
}

# DynamoDB Table 
resource "aws_dynamodb_table" "dynamo_table" {
  count          = var.create_dynamodb ? 1 : 0
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.tags
}