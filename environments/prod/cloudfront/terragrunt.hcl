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
  s3_website_endpoint = dependency.s3.outputs.website_endpoint
  acm_certificate_arn   = dependency.acm.outputs.acm_certificate_arn
}

