output "s3_bucket_name" {
  value = var.bucket_name # Use the provided bucket name instead of a resource reference
}

output "s3_bucket_domain_name" {
  value = "s3-website-${var.bucket_name}.s3.amazonaws.com" # Manually construct the website endpoint
}

output "files_in_build" {
  value = fileset("${path.module}/../../personal-site-main/build", "*")
}

