# Remove the aws_s3_bucket block since the bucket already exists

# Use the existing bucket name as a variable

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = var.bucket_name
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "resume_policy" {
  bucket = var.bucket_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.public_access]
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = var.bucket_name

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_object" "website_files" {
  for_each = {
    for file in fileset("/Users/pjfaraon/Documents/my_project/personal-site-main/build", "**/*") : 
    file => file if !startswith(file, ".") 
  }

  bucket = var.bucket_name
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

