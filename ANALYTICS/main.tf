provider "aws" {
  region = var.aws_region
}

# S3 Data Lake Bucket
resource "aws_s3_bucket" "data_lake" {
  bucket        = var.data_lake_bucket_name
  force_destroy = true
  tags = var.tags
}

resource "aws_s3_bucket_versioning" "data_lake_versioning" {
  bucket = aws_s3_bucket.data_lake.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Glue Catalog Database
resource "aws_glue_catalog_database" "analytics_db" {
  name = var.glue_database_name
}

# Glue Crawler
resource "aws_iam_role" "glue_role" {
  name = var.glue_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "glue.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_s3_access" {
  name = "glue-s3-access"
  role = aws_iam_role.glue_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:GetObject","s3:PutObject","s3:ListBucket"],
      Resource = [aws_s3_bucket.data_lake.arn, "${aws_s3_bucket.data_lake.arn}/*"]
    }]
  })
}

resource "aws_glue_crawler" "s3_crawler" {
  name          = var.glue_crawler_name
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.analytics_db.name

  s3_target {
    path = "s3://${aws_s3_bucket.data_lake.bucket}/data/"
  }
}

# Athena Results Bucket
resource "aws_s3_bucket" "athena_results" {
  bucket        = var.athena_results_bucket
  force_destroy = true
  tags          = var.tags
}

# Athena Workgroup
resource "aws_athena_workgroup" "analytics" {
  name = var.athena_workgroup_name

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.bucket}/results/"
    }
  }
}
provider "aws" {
  region = var.aws_region
}

# Kinesis Data Stream

resource "aws_kinesis_stream" "data_stream" {
  name             = var.kinesis_stream_name
  shard_count      = var.kinesis_shard_count
  retention_period = var.kinesis_retention_hours

  tags = var.tags
}

# Kinesis Firehose Delivery Stream (to S3)

resource "aws_kinesis_firehose_delivery_stream" "firehose_to_s3" {
  name        = var.firehose_name
  destination = "s3"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = var.firehose_s3_bucket_arn
    buffer_size        = 5
    buffer_interval    = 300
    compression_format = "UNCOMPRESSED"
  }

  tags = var.tags
}

# IAM Role for Firehose to write to S3

resource "aws_iam_role" "firehose_role" {
  name = var.firehose_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "firehose.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "firehose_s3_policy" {
  name = "firehose-s3-access"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:PutObject","s3:PutObjectAcl","s3:GetBucketLocation"],
      Resource = ["${var.firehose_s3_bucket_arn}/*"]
    }]
  })
}