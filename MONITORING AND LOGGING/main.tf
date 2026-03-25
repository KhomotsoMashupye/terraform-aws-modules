provider "aws" {
  region = var.aws_region
}

# S3 bucket for storing logs
resource "aws_s3_bucket" "logs_bucket" {
  bucket        = var.logs_bucket_name
  force_destroy = true
  acl           = "private"

  versioning {
    status = "Enabled"
  }

  tags = var.tags
}

# CloudWatch log group
resource "aws_cloudwatch_log_group" "general_logs" {
  name              = "/tf/general-logs"
  retention_in_days = 30
  tags              = var.tags
}

# IAM role for CloudWatch to S3 export
resource "aws_iam_role" "cloudwatch_to_s3" {
  name = "cloudwatch-to-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "logs.${var.aws_region}.amazonaws.com"
      }
    }]
  })
}

# Attach policy to allow S3 writes
resource "aws_iam_role_policy" "cloudwatch_s3_policy" {
  name = "cloudwatch-s3-policy"
  role = aws_iam_role.cloudwatch_to_s3.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetBucketAcl"
      ],
      Resource = "${aws_s3_bucket.logs_bucket.arn}/*"
    }]
  })
}

# CloudWatch Logs subscription filter to export logs to S3
resource "aws_cloudwatch_log_resource_policy" "s3_export_policy" {
  policy_name     = "AllowLogsToS3"
  policy_document = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "logs.${var.aws_region}.amazonaws.com" }
        Action    = "logs:PutSubscriptionFilter"
        Resource  = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_subscription_filter" "export_to_s3" {
  name            = "export-logs-to-s3"
  log_group_name  = aws_cloudwatch_log_group.general_logs.name
  filter_pattern  = ""
  destination_arn = aws_s3_bucket.logs_bucket.arn
}