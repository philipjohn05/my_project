#!/bin/bash

echo "=== Manual Deployment Script ==="
echo ""

# Build the latest version locally
echo "🔨 Building latest version locally..."
cd personal-site-main
npm run build

if [ ! -d "build" ]; then
    echo "❌ Build failed or build directory not found"
    exit 1
fi

echo "✅ Build completed successfully"
echo ""

# Show what we're about to deploy
echo "🔍 Local build contents:"
find build -name "*.js" -path "*/static/js/*" | head -5

echo ""
echo "📤 Uploading to S3..."

# Sync to S3 bucket
aws s3 sync build/ s3://pjfaraon-resume-au/ --delete --exclude ".DS_Store"

if [ $? -eq 0 ]; then
    echo "✅ S3 sync completed successfully"
    echo ""
    
    # Verify the upload by checking for GitLab in uploaded files
    echo "🔍 Verifying upload contains latest changes..."
    sleep 2  # Give S3 a moment to update
    
    # Test if GitLab appears in the main page
    if curl -s "http://pjfaraon-resume-au.s3-website-ap-southeast-2.amazonaws.com" | grep -i "gitlab" >/dev/null; then
        echo "✅ GitLab found in S3 - upload successful!"
    else
        echo "⚠️ GitLab not found yet - may need a moment to propagate"
    fi
    
    echo ""
    echo "🔄 Invalidating CloudFront cache..."
    
    # Get the CloudFront distribution ID from the cloudfront directory
    cd ../environments/prod/cloudfront
    DISTRIBUTION_ID=$(terragrunt output -raw cloudfront_distribution_id 2>/dev/null)
    
    if [ -n "$DISTRIBUTION_ID" ]; then
        echo "Distribution ID: $DISTRIBUTION_ID"
        aws cloudfront create-invalidation --distribution-id "$DISTRIBUTION_ID" --paths "/*"
        echo "✅ CloudFront invalidation initiated"
        echo ""
        echo "⏰ Changes should be visible in 10-15 minutes at:"
        echo "   🌐 https://pjfaraon.com"
        echo "   🌐 https://ddg6ffmjyv2vo.cloudfront.net"
    else
        echo "❌ Could not find CloudFront distribution ID"
    fi
    
else
    echo "❌ S3 sync failed"
    exit 1
fi

cd ..
echo ""
echo "🎉 Manual deployment completed!"
echo "💡 If changes still don't appear, try:"
echo "   - Wait 15 minutes for cache to clear"
echo "   - Use incognito browser mode"
echo "   - Add ?v=$(date +%s) to the URL"