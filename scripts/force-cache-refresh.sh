#!/bin/bash

echo "=== CloudFront Cache Refresh ==="
echo ""

# Change to prod environment directory
cd "$(dirname "$0")/../environments/prod" || exit 1

# Get CloudFront distribution ID
DISTRIBUTION_ID=$(terragrunt output -raw cloudfront_distribution_id 2>/dev/null)

if [ -n "$DISTRIBUTION_ID" ]; then
    echo "✅ Found CloudFront Distribution ID: $DISTRIBUTION_ID"
    echo ""
    
    echo "🔄 Creating CloudFront invalidation for all files..."
    aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*" || {
        echo "❌ Failed to create invalidation. Make sure AWS CLI is configured."
        exit 1
    }
    
    echo ""
    echo "✅ Invalidation created successfully!"
    echo ""
    echo "⏰ Note: CloudFront invalidations typically take 10-15 minutes to complete."
    echo ""
    echo "🧪 You can test your changes by:"
    echo "1. Wait 10-15 minutes"
    echo "2. Visit https://pjfaraon.com"
    echo "3. Hard refresh (Ctrl+F5 or Cmd+Shift+R)"
    echo "4. Or open in incognito/private browser"
    echo ""
    echo "📊 Check invalidation status:"
    echo "https://console.aws.amazon.com/cloudfront/v3/home#/distributions/$DISTRIBUTION_ID"
    
else
    echo "❌ CloudFront distribution not found."
    echo "Available outputs:"
    terragrunt output 2>/dev/null || echo "No outputs available"
    exit 1
fi