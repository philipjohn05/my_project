terraform {
  source = "../../../modules/cloudfront"
}

dependency "s3" {
  config_path = "../"
}

dependency "acm" {
  config_path = "../acm"
}

inputs = {
  s3_bucket_domain_name = dependency.s3.outputs.s3_bucket_domain_name
  acm_certificate_arn   = dependency.acm.outputs.acm_certificate_arn
}

