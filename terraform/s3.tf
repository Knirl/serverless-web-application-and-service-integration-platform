
# Existing frontend S3 bucket
resource "aws_s3_bucket" "frontend" {
  bucket = "p4-service-request-frontend-1052313"

  lifecycle {
    prevent_destroy = true
  }
}

# Keep the bucket private
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Existing default encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

    bucket_key_enabled       = true
    blocked_encryption_types = ["SSE-C"]
  }
}

# Allow CloudFront to read objects from this bucket
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"

    Statement = [{
      Sid    = "AllowCloudFrontServicePrincipal"
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.frontend.arn}/*"

      Condition = {
        ArnLike = {
          "AWS:SourceArn" = "arn:aws:cloudfront::109375139212:distribution/EZ6F4VFFHD91S"
        }
      }
    }]
  })

  lifecycle {
    prevent_destroy = true
  }
}
