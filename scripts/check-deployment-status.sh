#!/bin/bash

echo "=== Deployment Status Check ==="
echo ""

# Check if build directory exists and has recent changes
if [ -d "personal-site-main/build" ]; then
    echo "✅ Build directory exists"
    echo "📅 Last build: $(stat -c %y personal-site-main/build 2>/dev/null || stat -f %Sm personal-site-main/build 2>/dev/null)"
    
    # Check if skills data is in the build
    if [ -f "personal-site-main/build/static/js"/*.js ]; then
        echo ""
        echo "🔍 Checking if skills changes are in the build..."
        
        # Look for skills-related content in JS files
        if grep -r "GitLab\|Github Actions" personal-site-main/build/static/js/ 2>/dev/null; then
            echo "✅ Skills data found in build files"
        else
            echo "❌ Skills data not found in build files - may need to rebuild"
        fi
    fi
else
    echo "❌ Build directory not found"
    echo "💡 Run 'npm run build' in personal-site-main/ to create a fresh build"
fi

echo ""
echo "🚀 To fix caching issues:"
echo "1. Make sure your changes are committed and pushed"
echo "2. Trigger a new GitHub Actions deployment"
echo "3. Or run: ./scripts/force-cache-refresh.sh"
echo ""

echo "🧪 Quick tests:"
echo "1. Local build test: cd personal-site-main && npm run build && npm start"
echo "2. Check GitHub Actions: https://github.com/YOUR_USERNAME/YOUR_REPO/actions"
echo "3. Test with cache bypass: https://pjfaraon.com?v=$(date +%s)"