output "function_name" {
    value = aws_cloudfront_function.short_url.name
}

output "domain_name" {
    value = aws_cloudfront_distribution.short_url.domain_name
}