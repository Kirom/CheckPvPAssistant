#!/bin/bash

# Local packaging script for CheckPvPAssistant
# This script creates a release package similar to what GitHub Actions does

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 CheckPvPAssistant Local Packaging Script${NC}"
echo "================================================"

# Get version from TOC file
VERSION=$(grep "^## Version:" CheckPvPAssistant.toc | cut -d: -f2 | tr -d ' ')
if [ -z "$VERSION" ]; then
    echo -e "${RED}❌ Could not extract version from TOC file${NC}"
    exit 1
fi

echo -e "${BLUE}📦 Version: ${GREEN}$VERSION${NC}"

# Clean previous builds
if [ -d "build" ]; then
    echo -e "${YELLOW}🧹 Cleaning previous build...${NC}"
    rm -rf build/
fi

# Create build directory
mkdir -p build/CheckPvPAssistant

echo -e "${BLUE}📋 Copying files...${NC}"

# Copy core files
cp CheckPvPAssistant.toc build/CheckPvPAssistant/
cp -r src/ build/CheckPvPAssistant/

# Optional: Copy additional files if they exist
if [ -f "LICENSE" ]; then
    cp LICENSE build/CheckPvPAssistant/
fi

if [ -f "README.md" ]; then
    cp README.md build/CheckPvPAssistant/
fi

if [ -f "CHANGELOG.md" ]; then
    cp CHANGELOG.md build/CheckPvPAssistant/
fi

echo -e "${BLUE}🗜️  Creating ZIP archive...${NC}"

# Create the archive
cd build
zip -r "../CheckPvPAssistant-$VERSION.zip" CheckPvPAssistant/ -q

cd ..

# Get file size and hash
FILE_SIZE=$(du -h "CheckPvPAssistant-$VERSION.zip" | cut -f1)
FILE_HASH=$(sha256sum "CheckPvPAssistant-$VERSION.zip" | cut -d' ' -f1)

echo -e "${GREEN}✅ Package created successfully!${NC}"
echo "================================================"
echo -e "${BLUE}📄 File:${NC} CheckPvPAssistant-$VERSION.zip"
echo -e "${BLUE}📊 Size:${NC} $FILE_SIZE"
echo -e "${BLUE}🔐 SHA256:${NC} $FILE_HASH"

# Verify contents
echo -e "\n${BLUE}📋 Package contents:${NC}"
unzip -l "CheckPvPAssistant-$VERSION.zip" | grep -E "CheckPvPAssistant/"

echo -e "\n${GREEN}🎉 Local package ready for testing!${NC}"
echo -e "${YELLOW}💡 To test: Extract and copy to your WoW AddOns directory${NC}"

# Clean up build directory
rm -rf build/

echo -e "\n${BLUE}🔍 Next steps:${NC}"
echo "1. Test the package locally in WoW"
echo "2. If working correctly, create a git tag:"
echo -e "   ${YELLOW}git tag v$VERSION${NC}"
echo -e "   ${YELLOW}git push origin v$VERSION${NC}"
echo "3. GitHub Actions will handle the release automatically" 