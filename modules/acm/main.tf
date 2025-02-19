provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "resume_cert" {
  provider          = aws.us_east_1 # Ensures ACM is created in us-east-1
  domain_name       = "pjfaraon.com"
  validation_method = "DNS"

  subject_alternative_names = ["www.pjfaraon.com"]

  lifecycle {
    create_before_destroy = true
  }
}

