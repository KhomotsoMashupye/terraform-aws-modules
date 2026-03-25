output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.general_logs.name
}

output "s3_logs_bucket" {
  value = aws_s3_bucket.logs_bucket.id
}

output "cloudwatch_to_s3_role_arn" {
  value = aws_iam_role.cloudwatch_to_s3.arn
}