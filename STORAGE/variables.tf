variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "tags" {
  type        = map(string)
  default     = { Environment = "placeholder" }
  description = "Tags for all resources"
}

# S3 buckets

variable "s3_standard_bucket_name" {
  type        = string
  default     = "placeholder-standard-bucket"
  description = "S3 bucket for standard storage"
}

variable "s3_glacier_bucket_name" {
  type        = string
  default     = "placeholder-glacier-bucket"
  description = "S3 bucket for Glacier storage"
}

variable "s3_intelligent_bucket_name" {
  type        = string
  default     = "placeholder-intelligent-tiering-bucket"
  description = "S3 bucket for Intelligent-Tiering"
}

# EBS volumes

variable "ebs_volumes" {
  type = list(object({
    name              = string
    size              = number
    type              = string
    availability_zone = string
  }))
  default = [
    { name = "placeholder-ebs-1", size = 8, type = "gp3", availability_zone = "us-east-1a" },
    { name = "placeholder-ebs-2", size = 16, type = "gp3", availability_zone = "us-east-1b" }
  ]
}
# EFS
variable "efs_file_systems" {
  type = list(object({
    name            = string
    performance_mode = string
    subnet_id       = string
    security_groups = list(string)
  }))
  default = [
    { name = "placeholder-efs-1", performance_mode = "generalPurpose", subnet_id = "subnet-xxxx", security_groups = ["sg-xxxx"] }
  ]
}
