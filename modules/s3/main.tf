# Define the AWS provider
provider "aws" {
  region = "ap-southeast-2"  # Sydney region
}

# Define the S3 bucket resource
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name  # Use the bucket name variable
  acl    = "public-read"    # Make the bucket publicly readable

  tags = {
    Name        = "My Portfolio Website"
    Environment = "Production"
  }
}

# Upload the files to S3
resource "aws_s3_object" "website_files" {
  for_each = {
    for file in fileset("/Users/pjfaraon/Documents/my_project/personal-site-main/build", "**/*") : 
    file => file if !startswith(file, ".")
  }

  bucket = aws_s3_bucket.website_bucket.bucket  # Ensure the bucket reference is correct
  key    = each.value
  source = "/Users/pjfaraon/Documents/my_project/personal-site-main/build/${each.value}"

  content_type = lookup({
    "html"  = "text/html",
    "css"   = "text/css",
    "js"    = "application/javascript",
    "png"   = "image/png",
    "jpg"   = "image/jpeg",
    "jpeg"  = "image/jpeg",
    "gif"   = "image/gif",
    "svg"   = "image/svg+xml",
    "webp"  = "image/webp",
    "woff"  = "font/woff",
    "woff2" = "font/woff2",
    "ttf"   = "font/ttf",
    "otf"   = "font/otf",
    "json"  = "application/json",
    "txt"   = "text/plain",
  }, try(split(".", each.value)[length(split(".", each.value)) - 1], "other"), "application/octet-stream")
}
