variable "aws_region" { type = string, default = "af-south-1" }

variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }

variable "db_sg_name" { type = string, default = "test-db-sg" }
variable "db_subnet_group_name" { type = string, default = "test-db-subnet-group" }

# RDS 
variable "rds_identifier" { type = string, default = "rds-test-db" }
variable "rds_engine" { type = string, default = "postgres" }
variable "rds_engine_version" { type = string, default = "16.11" }
variable "rds_instance_class" { type = string, default = "db.t3.medium" }
variable "rds_allocated_storage" { type = number, default = 20 }
variable "rds_db_name" { type = string, default = "rdsdb" }
variable "rds_username" { type = string, default = "admin" }
variable "rds_password" { type = string, sensitive = true }
variable "rds_multi_az" { type = bool, default = false }
variable "rds_backup_days" { type = number, default = 7 }
variable "rds_create_read_replica" { type = bool, default = false }

#  Aurora 
variable "create_aurora" { type = bool, default = false }
variable "aurora_identifier" { type = string, default = "aurora-test-cluster" }
variable "aurora_engine_version" { type = string, default = "15.4" }
variable "aurora_username" { type = string, default = "admin" }
variable "aurora_password" { type = string, sensitive = true }
variable "aurora_db_name" { type = string, default = "auroradb" }
variable "aurora_instance_count" { type = number, default = 1 }
variable "aurora_instance_class" { type = string, default = "db.t3.medium" }

#  DynamoDB 
variable "create_dynamodb" { type = bool, default = false }
variable "dynamodb_table_name" { type = string, default = "dynamodb-test" }

variable "allowed_cidrs" { type = list(string), default = ["0.0.0.0/0"] }
variable "tags" { type = map(string), default = { Environment = "dev" } }