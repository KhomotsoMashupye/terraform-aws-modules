# S3
output "standard_bucket_arn" {
  value = aws_s3_bucket.standard_bucket.arn
}

output "glacier_bucket_arn" {
  value = aws_s3_bucket.glacier_bucket.arn
}

output "intelligent_tiering_bucket_arn" {
  value = aws_s3_bucket.intelligent_tiering_bucket.arn
}

# EBS
output "ebs_volume_ids" {
  value = aws_ebs_volume.ebs_volume[*].id
}

# EFS
output "efs_file_system_ids" {
  value = aws_efs_file_system.efs_fs[*].id
}
