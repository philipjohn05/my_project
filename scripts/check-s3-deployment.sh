#!/bin/bash

echo "=== S3 Deployment Verification ==="
echo ""

# Change to prod environment directory
cd "$(dirname "$0")/../environments/prod" || exit 1

# Get S3 bucket name
BUCKET_NAME=$(terragrunt output -raw s3_bucket_name 2>/dev/null)

if [ -n "$BUCKET_NAME" ]; then
    echo "✅ Found S3 Bucket: $BUCKET_NAME"
    echo ""
    
    # Check when files were last modified in S3
    echo "🕒 Checking S3 file timestamps (showing latest 10 files)..."
    aws s3 ls s3://$BUCKET_NAME/ --recursive --human-readable | sort -k1,2 | tail -10
    
    echo ""
    echo "🔍 Checking if skills data is in deployed JS files..."
    
    # Download and check main JS file for skills data
    TEMP_DIR=$(mktemp -d)
    echo "Downloading JS files to check content..."
    
    aws s3 sync s3://$BUCKET_NAME/static/js/ "$TEMP_DIR/" --exclude "*" --include "*.js" 2>/dev/null
    
    if [ -d "$TEMP_DIR" ] && [ "$(ls -A $TEMP_DIR)" ]; then
        if grep -r "GitLab\|Github Actions" "$TEMP_DIR/" 2>/dev/null; then
            echo "✅ Skills data found in deployed S3 files!"
        else
            echo "❌ Skills data NOT found in deployed S3 files"
            echo "📋 This suggests the deployment didn't upload your latest changes"
        fi
        
        echo ""
        echo "📊 Deployed JS files:"
        ls -la "$TEMP_DIR/"
        
        # Compare with local build
        echo ""
        echo "🔄 Comparing with local build..."
        LOCAL_BUILD="../personal-site-main/build/static/js"
        if [ -d "$LOCAL_BUILD" ]; then
            echo "Local build files:"
            ls -la "$LOCAL_BUILD/"
            
            # Quick size comparison
            echo ""
            echo "File size comparison (Local vs S3):"
            for file in "$TEMP_DIR"/*.js; do
                filename=$(basename "$file")
                if [ -f "$LOCAL_BUILD/$filename" ]; then
                    local_size=$(stat -f%z "$LOCAL_BUILD/$filename" 2>/dev/null || stat -c%s "$LOCAL_BUILD/$filename" 2>/dev/null)
                    s3_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
                    echo "$filename: Local=${local_size}b, S3=${s3_size}b $([ $local_size -eq $s3_size ] && echo '✅' || echo '❌')"
                fi
            done
        else
            echo "❌ Local build not found. Run 'npm run build' first."
        fi
        
    else
        echo "❌ Could not download S3 files. Check AWS CLI permissions."
    fi
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    
    echo ""
    echo "🔧 Troubleshooting steps:"
    echo "1. Check GitHub Actions deployment logs"
    echo "2. Verify build process completed successfully"
    echo "3. Check if Terraform uploaded files to S3"
    echo "4. Manual upload: aws s3 sync personal-site-main/build/ s3://$BUCKET_NAME/ --delete"
    
else
    echo "❌ S3 bucket not found. Check Terraform deployment."
    echo "Available outputs:"
    terragrunt output 2>/dev/null || echo "No outputs available"
fi