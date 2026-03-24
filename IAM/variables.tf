variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = "placeholder-role"
}

variable "assume_role_service" {
  description = "Service allowed to assume the role"
  type        = string
  default     = "ec2.amazonaws.com"
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
  default     = "placeholder-policy"
}

variable "policy_actions" {
  description = "List of actions allowed in the policy"
  type        = list(string)
  default     = ["s3:ListBucket"]
}

variable "user_name" {
  description = "Name of the IAM user"
  type        = string
  default     = "placeholder-user"
}

variable "group_name" {
  description = "Name of the IAM group"
  type        = string
  default     = "placeholder-group"
}

variable "tags" {
  description = "Tags for all IAM resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "placeholder"
  }
}