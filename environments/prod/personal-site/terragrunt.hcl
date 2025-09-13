include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/personal-site"
}

dependency "acm" {
  config_path = "../acm"
  mock_outputs = {
    certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }
}

dependency "route53" {
  config_path = "../route53"
  mock_outputs = {
    zone_id = "Z123456789012"
  }
  skip_outputs = true
}

inputs = {
  bucket_name         = "pjfaraon-personal-site-prod"
  domain_name         = ""  # Set your domain here if you have one
  acm_certificate_arn = dependency.acm.outputs.certificate_arn
  
  tags = {
    Name        = "Personal Site"
    Environment = "prod"
    Project     = "personal-portfolio"
    ManagedBy   = "terraform"
  }
}