output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket  # This should match the resource name in main.tf
}

output "s3_bucket_domain_name" {
  value = "${aws_s3_bucket.website_bucket.bucket}.s3.amazonaws.com"
}

