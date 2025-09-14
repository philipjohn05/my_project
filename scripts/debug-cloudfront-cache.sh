#!/bin/bash

echo "=== CloudFront Cache Debug ==="
echo ""

# Change to prod environment directory
cd "$(dirname "$0")/../environments/prod" || exit 1

# Get CloudFront details
DISTRIBUTION_ID=$(terragrunt output -raw cloudfront_distribution_id 2>/dev/null)
CLOUDFRONT_DOMAIN=$(terragrunt output -raw cloudfront_domain_name 2>/dev/null)
S3_WEBSITE_ENDPOINT=$(terragrunt output -raw website_endpoint 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ]; then
    echo "✅ CloudFront Distribution ID: $DISTRIBUTION_ID"
    echo "✅ CloudFront Domain: $CLOUDFRONT_DOMAIN"
    echo "✅ S3 Website Endpoint: $S3_WEBSITE_ENDPOINT"
    echo ""
    
    # Test direct S3 access
    echo "🔍 Testing direct S3 website endpoint..."
    echo "S3 Direct URL: http://$S3_WEBSITE_ENDPOINT"
    curl -I "http://$S3_WEBSITE_ENDPOINT" 2>/dev/null | head -n 5 || echo "❌ S3 direct access failed"
    
    echo ""
    echo "🔍 Testing CloudFront distribution..."
    echo "CloudFront URL: https://$CLOUDFRONT_DOMAIN"
    curl -I "https://$CLOUDFRONT_DOMAIN" 2>/dev/null | head -n 10 || echo "❌ CloudFront access failed"
    
    echo ""
    echo "🔍 Testing custom domain (pjfaraon.com)..."
    curl -I "https://pjfaraon.com" 2>/dev/null | head -n 10 || echo "❌ Custom domain failed"
    
    echo ""
    echo "🧪 Testing if changes are visible in each layer..."
    
    # Check S3 for GitLab content
    echo "1. Checking S3 endpoint for GitLab content:"
    if curl -s "http://$S3_WEBSITE_ENDPOINT" | grep -i "gitlab" >/dev/null 2>&1; then
        echo "   ✅ GitLab found in S3 response"
    else
        echo "   ❌ GitLab NOT found in S3 response"
    fi
    
    # Check CloudFront for GitLab content
    echo "2. Checking CloudFront for GitLab content:"
    if curl -s "https://$CLOUDFRONT_DOMAIN" | grep -i "gitlab" >/dev/null 2>&1; then
        echo "   ✅ GitLab found in CloudFront response"
    else
        echo "   ❌ GitLab NOT found in CloudFront response (CACHED!)"
    fi
    
    # Check custom domain for GitLab content
    echo "3. Checking pjfaraon.com for GitLab content:"
    if curl -s "https://pjfaraon.com" | grep -i "gitlab" >/dev/null 2>&1; then
        echo "   ✅ GitLab found in pjfaraon.com response"
    else
        echo "   ❌ GitLab NOT found in pjfaraon.com response (CACHED!)"
    fi
    
    echo ""
    echo "🔧 Checking recent CloudFront invalidations..."
    aws cloudfront list-invalidations --distribution-id "$DISTRIBUTION_ID" --max-items 5 2>/dev/null || echo "❌ Could not list invalidations"
    
    echo ""
    echo "💡 Manual cache bust URLs to try:"
    echo "   https://pjfaraon.com/?v=$(date +%s)"
    echo "   https://$CLOUDFRONT_DOMAIN/?v=$(date +%s)"
    
    echo ""
    echo "🚀 Force invalidation commands:"
    echo "   aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths '/*'"
    echo "   aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths '/static/js/*'"
    
else
    echo "❌ CloudFront distribution not found"
fi