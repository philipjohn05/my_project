variable "bucket_name" {
  description = "The name of the S3 bucket to store the portfolio website"
  type        = string
  default     = "pjfaraon-portfolio-website"  # Choose a unique name here
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Name        = "Personal Portfolio Website"
    Environment = "Production"
    Project     = "personal-site"
  }
}

variable "build_files" {
  description = "Map of build files to upload to S3"
  type = map(object({
    source       = string
    content_type = string
  }))
  default = {}
}

