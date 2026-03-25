terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# Standard S3 Bucket


resource "aws_s3_bucket" "standard_bucket" {
  bucket        = var.s3_standard_bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "standard_versioning" {
  bucket = aws_s3_bucket.standard_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "standard_encryption" {
  bucket = aws_s3_bucket.standard_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "standard_bucket_lifecycle" {
  bucket = aws_s3_bucket.standard_bucket.id

  rule {
    id     = "archive-to-glacier"
    status = "Enabled"
    
    # Required for provider v5.x to apply to the whole bucket
    filter {} 

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}


#  Glacier S3 Bucket


resource "aws_s3_bucket" "glacier_bucket" {
  bucket        = var.s3_glacier_bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "glacier_versioning" {
  bucket = aws_s3_bucket.glacier_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "glacier_encryption" {
  bucket = aws_s3_bucket.glacier_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "glacier_bucket_lifecycle" {
  bucket = aws_s3_bucket.glacier_bucket.id

  rule {
    id     = "glacier-lifecycle"
    status = "Enabled"

    filter {}

    transition {
      days          = 1 
      storage_class = "GLACIER"
    }
  }
}


# Intelligent-Tiering S3 Bucket


resource "aws_s3_bucket" "intelligent_tiering_bucket" {
  bucket        = var.s3_intelligent_bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "intelligent_versioning" {
  bucket = aws_s3_bucket.intelligent_tiering_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "intelligent_encryption" {
  bucket = aws_s3_bucket.intelligent_tiering_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "intelligent_bucket_lifecycle" {
  bucket = aws_s3_bucket.intelligent_tiering_bucket.id

  rule {
    id     = "tiering-lifecycle"
    status = "Enabled"

    filter {}

    transition {
      days          = 30
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}


#  EBS Volumes


resource "aws_ebs_volume" "ebs_volume" {
  count             = length(var.ebs_volumes)
  availability_zone = var.ebs_volumes[count.index].availability_zone
  size              = var.ebs_volumes[count.index].size
  type              = var.ebs_volumes[count.index].type
  encrypted         = true

  tags = merge(var.tags, { Name = var.ebs_volumes[count.index].name })
}

# EFS File Systems

resource "aws_efs_file_system" "efs_fs" {
  count             = length(var.efs_file_systems)
  creation_token    = var.efs_file_systems[count.index].name
  performance_mode  = var.efs_file_systems[count.index].performance_mode
  encrypted         = true

  tags = merge(var.tags, { Name = var.efs_file_systems[count.index].name })
}

resource "aws_efs_mount_target" "efs_mount" {
  count           = length(var.efs_file_systems)
  file_system_id  = aws_efs_file_system.efs_fs[count.index].id
  subnet_id       = var.efs_file_systems[count.index].subnet_id
  security_groups = var.efs_file_systems[count.index].security_groups
}