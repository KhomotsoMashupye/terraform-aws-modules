output "data_lake_bucket" {
  value = aws_s3_bucket.data_lake.id
}

output "glue_database" {
  value = aws_glue_catalog_database.analytics_db.name
}

output "athena_results_bucket" {
  value = aws_s3_bucket.athena_results.id
}

output "athena_workgroup" {
  value = aws_athena_workgroup.analytics.name
}
output "kinesis_stream_name" {
  value = aws_kinesis_stream.data_stream.name
}

output "firehose_delivery_stream_name" {
  value = aws_kinesis_firehose_delivery_stream.firehose_to_s3.name
}