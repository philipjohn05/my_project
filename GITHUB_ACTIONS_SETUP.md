# GitHub Actions CI/CD Setup Guide

This guide explains how to set up automated deployment of your personal site using GitHub Actions.

## 🏗️ Architecture

The CI/CD pipeline includes:

1. **Pull Request Checks** (`pr-check.yml`):
   - Runs tests and linting
   - Shows Terraform plan in PR comments
   - Validates infrastructure changes

2. **Deployment Pipeline** (`deploy.yml`):
   - Builds React application
   - Deploys infrastructure with Terragrunt
   - Invalidates CloudFront cache
   - Provides deployment summary

## 🔧 Setup Instructions

### Step 1: Create AWS IAM User for GitHub Actions

1. **Create IAM User:**
   ```bash
   aws iam create-user --user-name github-actions-personal-site
   ```

2. **Create IAM Policy:**
   ```bash
   cat > github-actions-policy.json << 'EOF'
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "s3:*",
           "cloudfront:*",
           "acm:*",
           "route53:*",
           "dynamodb:GetItem",
           "dynamodb:PutItem",
           "dynamodb:DeleteItem"
         ],
         "Resource": "*"
       },
       {
         "Effect": "Allow",
         "Action": [
           "iam:PassRole",
           "iam:GetRole",
           "iam:CreateRole",
           "iam:DeleteRole",
           "iam:AttachRolePolicy",
           "iam:DetachRolePolicy",
           "iam:ListInstanceProfilesForRole",
           "iam:CreateServiceLinkedRole",
           "iam:DeleteServiceLinkedRole",
           "iam:ListRolePolicies",
           "iam:ListAttachedRolePolicies"
         ],
         "Resource": "*"
       }
     ]
   }
   EOF
   
   aws iam create-policy \
     --policy-name GitHubActionsPersonalSitePolicy \
     --policy-document file://github-actions-policy.json
   ```

3. **Attach Policy to User:**
   ```bash
   aws iam attach-user-policy \
     --user-name github-actions-personal-site \
     --policy-arn arn:aws:iam::YOUR_ACCOUNT_ID:policy/GitHubActionsPersonalSitePolicy
   ```

4. **Create Access Keys:**
   ```bash
   aws iam create-access-key --user-name github-actions-personal-site
   ```
   
   Save the `AccessKeyId` and `SecretAccessKey` from the output.

### Step 2: Configure GitHub Secrets

In your GitHub repository, go to **Settings** > **Secrets and variables** > **Actions** and add:

#### Repository Secrets
- `AWS_ACCESS_KEY_ID`: The AccessKeyId from Step 1
- `AWS_SECRET_ACCESS_KEY`: The SecretAccessKey from Step 1

#### Environment Secrets (Optional)
Create environment `prod` in **Settings** > **Environments** and add the same secrets for production-specific access control.

### Step 3: Configure GitHub Repository

1. **Enable GitHub Actions:**
   - Go to **Settings** > **Actions** > **General**
   - Enable "Allow all actions and reusable workflows"

2. **Set up Branch Protection (Recommended):**
   - Go to **Settings** > **Branches**
   - Add rule for `main` branch:
     - ✅ Require status checks to pass before merging
     - ✅ Require branches to be up to date before merging
     - ✅ Select status checks: "Test React App", "Terraform Plan"

### Step 4: Test the Setup

1. **Create a test branch:**
   ```bash
   git checkout -b test-github-actions
   ```

2. **Make a small change:**
   ```bash
   echo "<!-- Test change -->" >> personal-site-main/public/index.html
   git add .
   git commit -m "Test GitHub Actions setup"
   git push origin test-github-actions
   ```

3. **Create Pull Request:**
   - GitHub Actions will automatically run tests and show Terraform plan
   - Check the Actions tab for build status

4. **Merge to main:**
   - After PR approval, merge to main
   - Deployment will run automatically

## 📋 Workflow Details

### Deploy Workflow Triggers

- **Automatic**: Pushes to `main` branch with changes in:
  - `personal-site-main/**`
  - `environments/**`
  - `modules/**`
  - `.github/workflows/deploy.yml`

- **Manual**: Use "Run workflow" button in GitHub Actions tab

### Build Process

1. ✅ **Checkout code**
2. ✅ **Setup Node.js** (uses `.nvmrc` version)
3. ✅ **Install dependencies** (`npm ci`)
4. ✅ **Run tests** (`npm test`)
5. ✅ **Run linting** (`npm run lint`)
6. ✅ **Build application** (`npm run build`)
7. ✅ **Upload build artifacts**

### Deploy Process

1. ✅ **Download build files**
2. ✅ **Configure AWS credentials**
3. ✅ **Setup Terraform & Terragrunt**
4. ✅ **Deploy infrastructure** (`terragrunt apply`)
5. ✅ **Invalidate CloudFront cache**
6. ✅ **Generate deployment summary**

## 🔍 Monitoring and Troubleshooting

### View Deployment Status
- **GitHub Actions Tab**: See all workflow runs
- **Environments Tab**: View deployment history and URLs
- **AWS Console**: Monitor S3, CloudFront, and other resources

### Common Issues

1. **AWS Permissions Error:**
   - Verify IAM user has correct policies attached
   - Check AWS credentials in GitHub secrets

2. **Terraform State Lock:**
   - Check DynamoDB table `terraform-state-lock` for active locks
   - Wait for lock to expire or manually remove if needed

3. **Build Failures:**
   - Check Node.js version matches `.nvmrc`
   - Verify all dependencies are in `package.json`
   - Review test failures in Actions logs

4. **Deployment Timeouts:**
   - CloudFront distributions take 10-15 minutes to deploy
   - Increase workflow timeout if needed

### Manual Deployment

If you need to deploy manually:

```bash
# Build locally
./scripts/build-and-deploy.sh

# Deploy via GitHub Actions
gh workflow run deploy.yml
```

## 🚀 Advanced Configuration

### Multiple Environments

To add staging environment:

1. **Create environment config:**
   ```bash
   mkdir -p environments/staging
   cp environments/prod/terragrunt.hcl environments/staging/
   # Edit staging-specific values
   ```

2. **Update workflow:**
   ```yaml
   # In deploy.yml
   type: choice
   options:
     - prod
     - staging
   ```

### Custom Domain Setup

1. **Configure ACM certificate** in your ACM module
2. **Update personal site config:**
   ```hcl
   inputs = {
     domain_name = "your-domain.com"
     # ...
   }
   ```

3. **Ensure Route53 is configured** for your domain

### Security Enhancements

1. **Use OIDC instead of access keys** (recommended):
   - Configure GitHub OIDC provider in AWS
   - Use `aws-actions/configure-aws-credentials` with role assumption

2. **Restrict IAM permissions:**
   - Use resource-specific ARNs instead of "*"
   - Create separate policies for different environments

3. **Enable branch protection:**
   - Require PR reviews
   - Require status checks
   - Restrict push to main branch

## 📊 Cost Optimization

- **S3**: Pay only for storage and requests
- **CloudFront**: Free tier includes 1TB/month transfer
- **Route53**: ~$0.50/month per hosted zone
- **GitHub Actions**: 2000 minutes/month free for public repos

Total estimated cost: **$1-5/month** depending on traffic.

---

## 🎉 You're All Set!

Your personal site now has:
- ✅ Automated testing and linting
- ✅ Infrastructure as Code deployment  
- ✅ CloudFront CDN with cache invalidation
- ✅ Pull request validation
- ✅ Deployment summaries and monitoring

Push changes to `main` and watch your site deploy automatically! 🚀