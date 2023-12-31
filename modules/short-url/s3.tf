resource "aws_s3_bucket" "short_url" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name = "Short URL Bucket"
  }
}

resource "aws_s3_bucket_policy" "short_url" {
  bucket = aws_s3_bucket.short_url.id

  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid    = "PolicyForCloudFrontPrivateContent"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.short_url.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceArn" : aws_cloudfront_distribution.short_url.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "short_url" {
  bucket = aws_s3_bucket.short_url.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "short_url" {
  bucket = aws_s3_bucket.short_url.id
  key    = "index.html"
  content = local_file.short_url_front.content
  content_type = "text/html"
}

data "template_file" "short_url_front" {
  template = file("${path.module}/index.html")
  vars = {
    lambdaUrl = aws_lambda_function_url.short_url.function_url
  }
}

resource "local_file" "short_url_front" {
  filename = "${path.module}/rendered-index.html"
  content  = data.template_file.short_url_front.rendered
}

