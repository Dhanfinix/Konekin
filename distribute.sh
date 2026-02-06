#!/bin/bash

# Configuration
APP_NAME="Konekin"
BUILD_DIR="./build"
DIST_DIR="./dist"
DMG_NAME="${APP_NAME}_Installer.dmg"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"

# 1. Clean Build
echo "🚀 Starting fresh build..."
./build.sh

# 2. Prepare Dist Directory
echo "📦 Preparing distribution..."
rm -rf "${DIST_DIR}"
mkdir -p "${DIST_DIR}"

# 3. Create Temporary Folder for DMG Content
DMG_SRC="${DIST_DIR}/src"
mkdir -p "${DMG_SRC}"
cp -r "${APP_BUNDLE}" "${DMG_SRC}/"
ln -s /Applications "${DMG_SRC}/Applications"

# 4. Create DMG using hdiutil
echo "📀 Creating DMG..."
rm -f "${DIST_DIR}/${DMG_NAME}"
hdiutil create -volname "${APP_NAME}" -srcfolder "${DMG_SRC}" -ov -format UDZO "${DIST_DIR}/${DMG_NAME}"

# 5. Cleanup
rm -rf "${DMG_SRC}"

echo "✅ Distribution ready: ${DIST_DIR}/${DMG_NAME}"
echo "⚠️  NOTE: Since this is ad-hoc signed, other users may see 'App is damaged' error."
echo "👉 Tell them to run: xattr -cr /Applications/${APP_NAME}.app"
