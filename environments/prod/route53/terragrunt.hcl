terraform {
  source = "../../../modules/route53"
}

dependency "cloudfront" {
  config_path = "../cloudfront"
}

inputs = {
  zone_id                = "Z058203934T5QV6Q457F2" # Replace with your actual Hosted Zone ID
  cloudfront_domain_name = dependency.cloudfront.outputs.cloudfront_url
  cloudfront_zone_id     = dependency.cloudfront.outputs.cloudfront_zone_id
}

