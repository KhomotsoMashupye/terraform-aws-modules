variable "aws_region" {
  type    = string
  default = "af-south-1"
}

variable "data_lake_bucket_name" { type = string }
variable "glue_database_name" { type = string }
variable "glue_role_name" { type = string }
variable "glue_crawler_name" { type = string }
variable "athena_results_bucket" { type = string }
variable "athena_workgroup_name" { type = string }
variable "tags" {
  type    = map(string)
  default = { Environment = "dev" }
}


variable "kinesis_stream_name" { type = string }
variable "kinesis_shard_count" { type = number, default = 1 }
variable "kinesis_retention_hours" { type = number, default = 24 }

variable "firehose_name" { type = string }
variable "firehose_s3_bucket_arn" { type = string }
variable "firehose_role_name" { type = string }

variable "tags" {
  type = map(string)
  default = { Environment = "dev" }
}