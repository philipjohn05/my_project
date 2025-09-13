variable "bucket_name" {
  description = "The name of the S3 bucket for the personal site"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the personal site (optional)"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for HTTPS (required if using custom domain)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Name        = "Personal Portfolio Website"
    Environment = "Production"
    Project     = "personal-site"
  }
}