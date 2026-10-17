
# Existing CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "frontend" {
  name                              = "oac-p4-service-request-frontend-1052313.s3.ap-southe-mv6rbxy4wyb"
  description                       = "Created by CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"

  lifecycle {
    prevent_destroy = true
  }
}

# Existing CloudFront distribution
resource "aws_cloudfront_distribution" "frontend" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = ""
  price_class         = "PriceClass_All"
  default_root_object = "index.html"

  tags = {
    Name = "p4-service-request-distribution"
  }

  # Preserve the existing origin ID and OAC association
  origin {
    domain_name = "p4-service-request-frontend-1052313.s3.ap-southeast-1.amazonaws.com"
    origin_id   = "p4-service-request-frontend-1052313.s3.ap-southeast-1.amazonaws.com-mv6r7b041ei"

    origin_access_control_id = aws_cloudfront_origin_access_control.frontend.id

    connection_attempts         = 3
    connection_timeout          = 10
    response_completion_timeout = 0

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  default_cache_behavior {
    target_origin_id       = "p4-service-request-frontend-1052313.s3.ap-southeast-1.amazonaws.com-mv6r7b041ei"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    compress        = true
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  # Preserve the existing CloudFront WAF association
  web_acl_id = "arn:aws:wafv2:us-east-1:109375139212:global/webacl/CreatedByCloudFront-606a21ea/42b16bcb-e244-4d32-ba1e-c15d8b9fe3be"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Protect the existing distribution from accidental Terraform deletion.
  lifecycle {
    prevent_destroy = true
  }
}
