terraform {
  source = "../../modules/s3"
}

dependency "acm" {
  config_path = "./acm"
  skip_outputs = true
}


