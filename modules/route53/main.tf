resource "aws_route53_record" "resume_dns" {
  zone_id = var.zone_id
  name    = "pjfaraon.com"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_redirect" {
  zone_id = var.zone_id
  name    = "www.pjfaraon.com"
  type    = "CNAME"
  ttl     = 300
  records = ["pjfaraon.com"]
}

