output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}

output "s3_bucket_domain_name" {
  value = aws_s3_bucket.website_bucket.bucket_domain_name
}

output "s3_bucket_regional_domain_name" {
  value = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.website_bucket.arn
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

