output "cloudfront_url" {
  value = aws_cloudfront_distribution.resume_distribution.domain_name
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.resume_distribution.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.resume_distribution.id
}

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.resume_distribution.hosted_zone_id
}

