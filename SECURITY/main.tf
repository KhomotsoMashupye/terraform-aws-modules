provider "aws" {
  region = var.aws_region
}

# KMS Key for encryption
resource "aws_kms_key" "general_encryption" {
  description         = "General purpose encryption key"
  enable_key_rotation = true
  deletion_window_in_days = 7
  tags = var.tags
}

# AWS Shield Advanced Protection (Optional, billing applies)
resource "aws_shield_protection" "example_protection" {
  name     = "example-shield-protection"
  resource_arn = var.resource_arn_to_protect
}

# GuardDuty Detector
resource "aws_guardduty_detector" "example_guardduty" {
  enable = true
}

# CloudTrail
resource "aws_cloudtrail" "example_trail" {
  name                          = "example-trail"
  s3_bucket_name                = aws_s3_bucket.logs_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}

# S3 bucket for logs
resource "aws_s3_bucket" "logs_bucket" {
  bucket        = var.logs_bucket_name
  force_destroy = true
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

# AWS Config Recorder
resource "aws_config_configuration_recorder" "example_config" {
  name     = "example-config-recorder"
  role_arn = var.config_role_arn

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

# AWS Config Delivery Channel
resource "aws_config_delivery_channel" "example_delivery" {
  name           = "example-config-delivery"
  s3_bucket_name = aws_s3_bucket.logs_bucket.id
  config_snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
}

# Secrets Manager example
resource "aws_secretsmanager_secret" "example_secret" {
  name = var.secret_name
  description = "Example secret for Terraform module testing"
  recovery_window_in_days = 7
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id     = aws_secretsmanager_secret.example_secret.id
  secret_string = var.secret_value
}