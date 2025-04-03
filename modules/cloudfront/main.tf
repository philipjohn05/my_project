resource "aws_cloudfront_distribution" "resume_distribution" {
  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = "ResumeS3Origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["pjfaraon.com", "www.pjfaraon.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "ResumeS3Origin"

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    viewer_protocol_policy = "redirect-to-https"

    # Set TTL values here for cache behavior
    min_ttl     = 0
    max_ttl     = 86400
    default_ttl = 3600
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  # Error handling: Redirect all 404 errors to index.html
  custom_error_response {
    error_code         = 404
    response_page_path = "/index.html"
    response_code      = 200
  }
}
