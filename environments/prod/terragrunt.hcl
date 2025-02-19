terraform {
  source = "../../modules/s3"
}

dependency "acm" {
  config_path = "./acm"
}


inputs = {
  bucket_name = "pjfaraon-resume"
}

