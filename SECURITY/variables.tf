variable "aws_region" {
  type    = string
  default = "af-south-1"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "TerraformModules"
    Owner   = "YourName"
    Env     = "Dev"
  }
}

variable "resource_arn_to_protect" {
  type = string
  default = "arn:aws:ec2:region:account-id:instance/instance-id" # placeholder
}

variable "logs_bucket_name" {
  type = string
  default = "example-logs-bucket-2026"
}

variable "config_role_arn" {
  type    = string
  default = "arn:aws:iam::account-id:role/example-config-role" # placeholder
}

variable "secret_name" {
  type    = string
  default = "example-secret"
}

variable "secret_value" {
  type    = string
  default = "{\"username\":\"user\",\"password\":\"pass\"}"
}