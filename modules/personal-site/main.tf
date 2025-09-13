locals {
  build_path = "${path.module}/../../personal-site-main/build"
  
  # Get all files from the build directory
  build_files_raw = fileset(local.build_path, "**/*")
  
  # Filter out directories and hidden files, create map with metadata
  build_files = {
    for file in local.build_files_raw : file => {
      source = "${local.build_path}/${file}"
      content_type = lookup({
        "html"  = "text/html",
        "css"   = "text/css",
        "js"    = "application/javascript",
        "json"  = "application/json",
        "png"   = "image/png",
        "jpg"   = "image/jpeg",
        "jpeg"  = "image/jpeg",
        "gif"   = "image/gif",
        "svg"   = "image/svg+xml",
        "webp"  = "image/webp",
        "ico"   = "image/x-icon",
        "woff"  = "font/woff",
        "woff2" = "font/woff2",
        "ttf"   = "font/ttf",
        "otf"   = "font/otf",
        "txt"   = "text/plain",
        "xml"   = "application/xml",
        "map"   = "application/json"
      }, try(split(".", file)[length(split(".", file)) - 1], ""), "application/octet-stream")
    }
    if fileexists("${local.build_path}/${file}") && !startswith(file, ".")
  }
}

# S3 bucket for hosting the personal site
module "s3_website" {
  source = "../s3"
  
  bucket_name = var.bucket_name
  build_files = local.build_files
  tags = var.tags
}

# CloudFront distribution for CDN
module "cloudfront" {
  source = "../cloudfront"
  
  bucket_name                    = module.s3_website.s3_bucket_name
  bucket_regional_domain_name    = module.s3_website.s3_bucket_regional_domain_name
  acm_certificate_arn            = var.acm_certificate_arn
  domain_name                    = var.domain_name
  tags                          = var.tags
  
  depends_on = [module.s3_website]
}

# Route53 record (if domain is provided)
module "route53" {
  source = "../route53"
  count  = var.domain_name != "" ? 1 : 0
  
  domain_name                = var.domain_name
  cloudfront_distribution_id = module.cloudfront.cloudfront_distribution_id
  cloudfront_domain_name     = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id  = module.cloudfront.cloudfront_hosted_zone_id
  tags                      = var.tags
}