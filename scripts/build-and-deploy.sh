#!/bin/bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PERSONAL_SITE_DIR="./personal-site-main"
ENVIRONMENT="${1:-prod}"

echo -e "${YELLOW}🏗️  Building personal site...${NC}"

# Check if personal-site directory exists
if [ ! -d "$PERSONAL_SITE_DIR" ]; then
    echo -e "${RED}❌ Personal site directory not found: $PERSONAL_SITE_DIR${NC}"
    exit 1
fi

# Step 1: Build the React application
echo -e "${YELLOW}📦 Building React application...${NC}"
cd "$PERSONAL_SITE_DIR"

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📥 Installing dependencies...${NC}"
    npm ci
fi

# Build the application
echo -e "${YELLOW}🔨 Running build...${NC}"
npm run build

# Verify build directory exists
if [ ! -d "build" ]; then
    echo -e "${RED}❌ Build failed - build directory not found${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build completed successfully${NC}"
echo -e "${GREEN}📁 Build files are ready in: ${PWD}/build${NC}"
echo -e "${YELLOW}💡 To deploy, run: cd ../environments/${ENVIRONMENT} && terragrunt apply${NC}"
