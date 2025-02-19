variable "zone_id" {
  description = "The Route 53 Hosted Zone ID"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  type        = string
}

variable "cloudfront_zone_id" {
  description = "The hosted zone ID for CloudFront"
  type        = string
}

