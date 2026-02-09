#!/bin/bash

# Configuration
APP_NAME="Konekin"
BUILD_DIR="./build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "Building ${APP_NAME}.app..."

# Clean up
rm -rf "${BUILD_DIR}"
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

# Create PkgInfo
echo "APPL????" > "${CONTENTS_DIR}/PkgInfo"

# Compile Swift files for each architecture
echo "Compiling for arm64..."
swiftc -o "${MACOS_DIR}/${APP_NAME}_arm64" \
    main.swift AppDelegate.swift GnirehtetManager.swift TutorialWindow.swift NotificationManager.swift \
    -sdk $(xcrun --show-sdk-path --sdk macosx) -target arm64-apple-macosx11.0 -O

echo "Compiling for x86_64..."
swiftc -o "${MACOS_DIR}/${APP_NAME}_x86_64" \
    main.swift AppDelegate.swift GnirehtetManager.swift TutorialWindow.swift NotificationManager.swift \
    -sdk $(xcrun --show-sdk-path --sdk macosx) -target x86_64-apple-macosx11.0 -O

# Create Universal Binary using lipo
echo "Creating Universal Binary..."
lipo -create -output "${MACOS_DIR}/${APP_NAME}" \
    "${MACOS_DIR}/${APP_NAME}_arm64" \
    "${MACOS_DIR}/${APP_NAME}_x86_64"

# Clean up architecture-specific binaries
rm "${MACOS_DIR}/${APP_NAME}_arm64"
rm "${MACOS_DIR}/${APP_NAME}_x86_64"

# Copy Info.plist
cp Info.plist "${CONTENTS_DIR}/"

# Copy Dependencies (Self-Sustaining)
echo "Copying dependencies..."
VENDOR_DIR="./Vendor"

cp "${VENDOR_DIR}/gnirehtet.jar" "${RESOURCES_DIR}/"
cp "${VENDOR_DIR}/gnirehtet.apk" "${RESOURCES_DIR}/"
cp "${VENDOR_DIR}/adb" "${RESOURCES_DIR}/"
cp -r "Assets/"* "${RESOURCES_DIR}/" 2>/dev/null || : # Ignore if empty

# Create a place for adb keys (optional, usually adb handles this in ~/.android)

# Set executable permissions explicitly
chmod +x "${MACOS_DIR}/${APP_NAME}"
chmod +x "${RESOURCES_DIR}/adb"

# Remove extended attributes (quarantine) - Recursive
xattr -cr "${APP_BUNDLE}"

# Ad-hoc code sign dependencies (Inside-Out)
echo "Signing dependencies..."
codesign --force --sign - "${RESOURCES_DIR}/adb"

# Ad-hoc code sign with entitlements (Main App)
echo "Signing the app with entitlements..."
codesign --force --deep --sign - --entitlements Entitlements.plist "${APP_BUNDLE}"

echo "Build complete: ${APP_BUNDLE}"
