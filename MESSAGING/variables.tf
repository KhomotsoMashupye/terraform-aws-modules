variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "af-south-1"
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "placeholder-notifications-topic"
}

variable "sqs_queue_name" {
  description = "Name of the SQS queue"
  type        = string
  default     = "placeholder-queue"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project = "TerraformModules"
    Owner   = "YourName"
    Env     = "Dev"
  }
}