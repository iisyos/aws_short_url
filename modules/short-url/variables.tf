variable "bucket_name" {
  type        = string
  default     = "test-bucket"
  description = "Bucket name for short URL service"
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be between 3 and 63 characters long."
  }
}

variable "cf_distribution_name" {
  description = "CloudFront distribution name for short URL service"
  type        = string
  default     = "test-distribution"
}

variable "oac_name" {
  description = "Origin Access Control name for short URL service"
  type        = string
  default     = "test-oac"
}

variable "kvs_id" {
  description = "CloudFront KeyValueStore ID for short URL service"
  type        = string
}

variable "kvs_arn" {
  description = "CloudFront KeyValueStore ARN for short URL service"
  type        = string
}
