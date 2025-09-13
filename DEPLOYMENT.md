# Personal Site Deployment Guide

This guide explains how to deploy your React personal site to AWS using Terraform and Terragrunt.

## Architecture

The deployment creates the following AWS resources:

- **S3 Bucket**: Hosts static files with website configuration
- **CloudFront**: CDN for global distribution and HTTPS
- **ACM Certificate**: SSL certificate for custom domain (if configured)
- **Route53**: DNS configuration for custom domain (if configured)

## Prerequisites

1. **AWS CLI** configured with appropriate permissions
2. **Terraform** (>= 1.0)
3. **Terragrunt** (>= 0.45.0)
4. **Node.js** (>= 16.x) for building the React app
5. **S3 bucket** for Terraform state (configured in `backend.hcl`)
6. **DynamoDB table** for state locking (configured in `backend.hcl`)

## Quick Start

### Option 1: Automated Deployment (Recommended)

Use the provided script to build and deploy in one command:

```bash
# Deploy to production
./scripts/build-and-deploy.sh prod

# The script will:
# 1. Build the React application
# 2. Deploy infrastructure with Terragrunt
# 3. Upload files to S3
# 4. Display the website URL
```

### Option 2: Manual Deployment

1. **Build the React application:**
   ```bash
   cd personal-site-main
   npm ci
   npm run build
   ```

2. **Deploy infrastructure:**
   ```bash
   cd environments/prod/personal-site
   terragrunt init
   terragrunt plan
   terragrunt apply
   ```

3. **Get the website URL:**
   ```bash
   terragrunt output website_url
   ```

## Configuration

### Custom Domain (Optional)

To use a custom domain:

1. **Update ACM certificate:**
   - Configure your ACM module to issue a certificate for your domain
   - Certificate must be in `us-east-1` region for CloudFront

2. **Update personal-site configuration:**
   ```hcl
   # In environments/prod/personal-site/terragrunt.hcl
   inputs = {
     bucket_name         = "your-site-bucket-name"
     domain_name         = "your-domain.com"  # Set your domain
     acm_certificate_arn = dependency.acm.outputs.certificate_arn
     # ...
   }
   ```

3. **Update Route53:**
   - Ensure your Route53 module is configured for your domain
   - The personal-site module will create the necessary A/AAAA records

### Environment Variables

You can customize the deployment by modifying:

- `environments/prod/personal-site/terragrunt.hcl` - Production configuration
- `modules/personal-site/variables.tf` - Available variables

### Tags

All resources are tagged automatically. You can customize tags in the terragrunt configuration:

```hcl
inputs = {
  tags = {
    Name        = "Personal Site"
    Environment = "prod"
    Project     = "personal-portfolio"
    Owner       = "your-name"
    ManagedBy   = "terraform"
  }
}
```

## File Structure

```
.
├── environments/
│   └── prod/
│       └── personal-site/
│           └── terragrunt.hcl          # Environment configuration
├── modules/
│   ├── personal-site/                  # Main module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── s3/                            # S3 bucket module
│   ├── cloudfront/                    # CloudFront module
│   └── route53/                       # Route53 module
├── scripts/
│   └── build-and-deploy.sh           # Automated deployment script
├── personal-site-main/                # React application
│   ├── src/
│   ├── build/                         # Generated after npm run build
│   └── package.json
├── backend.hcl                        # Terraform backend configuration
└── terragrunt.hcl                     # Root Terragrunt configuration
```

## Troubleshooting

### Build Issues

- Ensure Node.js version matches `.nvmrc`
- Clear `node_modules` and run `npm ci` if dependency issues occur
- Check build logs in `personal-site-main/` directory

### Deployment Issues

- **State Lock**: If Terragrunt is stuck, check DynamoDB for active locks
- **S3 Bucket**: Ensure the bucket name is globally unique
- **Permissions**: Verify AWS CLI has sufficient permissions for all services
- **Certificate**: ACM certificates for CloudFront must be in `us-east-1`

### CloudFront Propagation

- New distributions take 10-15 minutes to become available
- Cache invalidation may be needed for updates: `aws cloudfront create-invalidation --distribution-id <ID> --paths "/*"`

## Cleanup

To destroy the infrastructure:

```bash
cd environments/prod/personal-site
terragrunt destroy
```

**Warning**: This will permanently delete your S3 bucket and all files.

## Next Steps

1. **CI/CD**: Set up GitHub Actions or similar for automated deployments
2. **Monitoring**: Add CloudWatch alarms for 4xx/5xx errors
3. **Security**: Implement WAF rules if needed
4. **Performance**: Configure CloudFront caching rules
5. **Backup**: Set up S3 versioning or cross-region replication