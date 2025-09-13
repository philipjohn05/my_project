#!/bin/bash

echo "=== CloudFront Distribution Validation ==="
echo ""

# Change to prod environment directory
cd "$(dirname "$0")/../environments/prod" || exit 1

# Get CloudFront distribution details
echo "🔍 Getting CloudFront distribution details..."
DISTRIBUTION_ID=$(terragrunt output -raw cloudfront_distribution_id 2>/dev/null)
DISTRIBUTION_DOMAIN=$(terragrunt output -raw cloudfront_domain_name 2>/dev/null)
WEBSITE_URL=$(terragrunt output -raw website_endpoint 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ]; then
    echo "✅ CloudFront Distribution ID: $DISTRIBUTION_ID"
    echo "✅ CloudFront Domain: $DISTRIBUTION_DOMAIN"
    echo "✅ Configured Aliases: pjfaraon.com, www.pjfaraon.com"
    echo ""
    
    # Test the CloudFront distribution
    echo "🧪 Testing CloudFront distribution..."
    
    echo "1. Testing CloudFront domain directly:"
    curl -I "https://$DISTRIBUTION_DOMAIN" 2>/dev/null | head -n 5 || echo "❌ Failed to reach CloudFront domain"
    
    echo ""
    echo "2. Testing custom domain (pjfaraon.com):"
    curl -I "https://pjfaraon.com" 2>/dev/null | head -n 5 || echo "❌ Failed to reach pjfaraon.com"
    
    echo ""
    echo "3. Testing www redirect:"
    curl -I "https://www.pjfaraon.com" 2>/dev/null | head -n 5 || echo "❌ Failed to reach www.pjfaraon.com"
    
    echo ""
    echo "4. Testing HTTP to HTTPS redirect:"
    curl -I "http://pjfaraon.com" 2>/dev/null | head -n 10 || echo "❌ Failed HTTP redirect test"
    
    echo ""
    echo "📋 Manual validation steps:"
    echo "1. Open https://pjfaraon.com in your browser"
    echo "2. Open https://www.pjfaraon.com in your browser"
    echo "3. Try http://pjfaraon.com - should redirect to HTTPS"
    echo "4. Check browser dev tools for CloudFront headers (X-Cache, X-Amz-Cf-Id)"
    
else
    echo "❌ CloudFront distribution not found. Make sure deployment completed successfully."
    echo ""
    echo "Available outputs:"
    terragrunt output 2>/dev/null
fi

echo ""
echo "🔗 Useful validation URLs:"
echo "- https://pjfaraon.com"
echo "- https://www.pjfaraon.com" 
echo "- https://$DISTRIBUTION_DOMAIN"
echo ""
echo "🛠️  CloudFront Management Console:"
echo "https://console.aws.amazon.com/cloudfront/v3/home#/distributions/$DISTRIBUTION_ID"