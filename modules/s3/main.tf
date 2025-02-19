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

resource "aws_s3_object" "resume_files" {
  for_each = { for file in fileset("${path.module}/files", "*") : file => file if !startswith(file, ".") }

  bucket = var.bucket_name
  key    = each.value
  source = "${path.module}/files/${each.value}"
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg"
  }, split(".", each.value)[1], "application/octet-stream")
}

