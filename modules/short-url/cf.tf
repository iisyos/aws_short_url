resource "aws_cloudfront_distribution" "short_url" {
  origin {
    domain_name = aws_s3_bucket.short_url.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.short_url.id

    origin_access_control_id = aws_cloudfront_origin_access_control.short_url.id
    connection_attempts      = "3"
    connection_timeout       = "10"
  }

  enabled = true

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.short_url.id
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "short_url" {
  name                              = var.oac_name
  description                       = "OAC for ${aws_s3_bucket.short_url.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
