data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "food_images" {
  bucket = "${var.project_name}-${var.environment}-food-images-${data.aws_caller_identity.current.account_id}"

  force_destroy = false

  tags = {
    Name      = "${var.project_name}-food-images"
    Component = "Food Image Storage"
  }
}

resource "aws_s3_bucket_versioning" "food_images" {
  bucket = aws_s3_bucket.food_images.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "food_images" {
  bucket = aws_s3_bucket.food_images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "food_images" {
  bucket = aws_s3_bucket.food_images.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "food_images" {
  bucket = aws_s3_bucket.food_images.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
