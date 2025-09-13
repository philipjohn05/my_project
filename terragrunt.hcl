include "backend" {
  path = find_in_parent_folders("backend.hcl")
}

locals {
  # Common tags for all resources
  common_tags = {
    Owner       = "pjfaraon"
    ManagedBy   = "terragrunt"
    Repository  = "personal-infrastructure"
  }
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
EOF
}

# Configure remote state
remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-pjfaraon"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}