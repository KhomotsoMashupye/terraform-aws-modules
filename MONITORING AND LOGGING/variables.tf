variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "af-south-1"
}

variable "logs_bucket_name" {
  description = "Name of the S3 bucket to store CloudWatch logs"
  type        = string
  default     = "tf-general-logs-2026"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Project = "TerraformModules"
    Owner   = "YourName"
    Env     = "Dev"
  }
}