data "archive_file" "short_url" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "short_url" {
  function_name    = "short_url_lambda"
  filename         = data.archive_file.short_url.output_path
  source_code_hash = data.archive_file.short_url.output_base64sha256
  runtime          = "nodejs18.x"
  role             = aws_iam_role.short_url.arn
  handler          = "put-short-url.handler"
  publish          = true
  environment {
    variables = {
        KVS_ARN                 = var.kvs_arn
    }
  }
}

resource "aws_iam_role" "short_url" {
  name = "short_url_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "short_url" {
  name   = "short_url_lambda_policy"
  role   = aws_iam_role.short_url.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": "cloudfront-keyvaluestore:PutKey",
      "Resource": "arn:aws:cloudfront::*:key-value-store/${var.kvs_id}"
    }
  ]
}
POLICY
}

resource "aws_lambda_function_url" "short_url" {
    function_name = aws_lambda_function.short_url.function_name
    authorization_type = "NONE"
}