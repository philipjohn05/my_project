output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_website.s3_bucket_name
}

output "s3_website_endpoint" {
  description = "S3 website endpoint"
  value       = module.s3_website.website_endpoint
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.cloudfront_domain_name
}

output "website_url" {
  description = "The URL of the deployed website"
  value       = var.domain_name != "" ? "https://${var.domain_name}" : "https://${module.cloudfront.cloudfront_domain_name}"
}