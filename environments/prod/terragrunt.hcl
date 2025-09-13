terraform {
  source = "../../modules/s3"
}

dependency "acm" {
  config_path = "./acm"
  mock_outputs = {
    certificate_arn = ""
  }
  skip_outputs = true
}

locals {
  # Get all files from the personal site build directory
  build_path = "${get_parent_terragrunt_dir()}/personal-site-main/build"
  
  build_files_raw = try(fileset(local.build_path, "**/*"), [])
  
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
    if can(fileexists("${local.build_path}/${file}")) && fileexists("${local.build_path}/${file}") && !startswith(file, ".")
  }
}

inputs = {
  bucket_name = "pjfaraon-resume-au"
  build_files = local.build_files
  
  tags = {
    Name        = "Personal Portfolio Website"
    Environment = "prod"
    Project     = "personal-site"
    ManagedBy   = "terraform"
  }
}


