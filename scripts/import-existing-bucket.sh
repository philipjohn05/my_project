#!/bin/bash

# Script to import existing S3 bucket into Terraform state
# This resolves the "BucketAlreadyOwnedByYou" error when the bucket exists but isn't tracked in Terraform

echo "Importing existing S3 bucket 'pjfaraon-resume-au' into Terraform state..."

# Change to the prod environment directory
cd "$(dirname "$0")/../environments/prod" || exit 1

# Import the existing S3 bucket
terragrunt import aws_s3_bucket.website_bucket pjfaraon-resume-au

# Import related resources if they exist
echo "Importing related S3 resources..."

# Try to import bucket website configuration
terragrunt import aws_s3_bucket_website_configuration.website_config pjfaraon-resume-au || echo "Website configuration not found or already imported"

# Try to import bucket public access block
terragrunt import aws_s3_bucket_public_access_block.website_bucket_pab pjfaraon-resume-au || echo "Public access block not found or already imported"

# Try to import bucket policy
terragrunt import aws_s3_bucket_policy.website_bucket_policy pjfaraon-resume-au || echo "Bucket policy not found or already imported"

echo "Import complete. Now run 'terragrunt plan' to verify the state."