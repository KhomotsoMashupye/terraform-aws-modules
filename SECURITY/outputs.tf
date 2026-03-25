output "kms_key_id" {
  value = aws_kms_key.general_encryption.id
}

output "shield_protection_id" {
  value = aws_shield_protection.example_protection.id
}

output "guardduty_detector_id" {
  value = aws_guardduty_detector.example_guardduty.id
}

output "cloudtrail_name" {
  value = aws_cloudtrail.example_trail.name
}

output "logs_bucket_name" {
  value = aws_s3_bucket.logs_bucket.id
}

output "secret_arn" {
  value = aws_secretsmanager_secret.example_secret.arn
}