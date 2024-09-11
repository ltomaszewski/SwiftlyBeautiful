#!/bin/bash

# Get the project root directory (assuming the script is located in the "scripts" folder)
PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)

# Name of the scheme (replace with your actual scheme name if different)
SCHEME="SwiftlyBeautiful"

# Output folder located in the project root
OUTPUT_DIR="$PROJECT_ROOT/build"

# Clean the build directory
rm -rf $OUTPUT_DIR

# Change the working directory to the project root
cd "$PROJECT_ROOT" || exit

# Function to archive for a specific platform
archive() {
    PLATFORM=$1
    DESTINATION=$2
    ARCHIVE_PATH=$3

    echo "Archiving for $PLATFORM ($DESTINATION)..."

    xcodebuild archive \
        -scheme $SCHEME \
        -destination "$DESTINATION" \
        -archivePath "$ARCHIVE_PATH" \
        -configuration Release \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        -quiet \

    if [ $? -ne 0 ]; then
        echo "Archiving for $PLATFORM failed!"
        exit 1
    fi
}

# Archive for all platforms in parallel
archive "iOS Device" "generic/platform=iOS" "$OUTPUT_DIR/iOS-Device.xcarchive" &
PID_IOS_DEVICE=$!

archive "iOS Simulator" "generic/platform=iOS Simulator" "$OUTPUT_DIR/iOS-Simulator.xcarchive" &
PID_IOS_SIMULATOR=$!

archive "macOS" "generic/platform=macOS" "$OUTPUT_DIR/macOS.xcarchive" &
PID_MACOS=$!

# Wait for all archives to complete
wait $PID_IOS_DEVICE
wait $PID_IOS_SIMULATOR
wait $PID_MACOS

# Create the xcframework
echo "Creating xcframework..."

xcodebuild -create-xcframework \
    -framework "$OUTPUT_DIR/iOS-Device.xcarchive/Products/usr/local/lib/$SCHEME.framework" \
    -framework "$OUTPUT_DIR/iOS-Simulator.xcarchive/Products/usr/local/lib/$SCHEME.framework" \
    -framework "$OUTPUT_DIR/macOS.xcarchive/Products/usr/local/lib/$SCHEME.framework" \
    -output "$OUTPUT_DIR/$SCHEME.xcframework"

if [ $? -ne 0 ]; then
    echo "Failed to create xcframework!"
    exit 1
fi

echo "Successfully created $SCHEME.xcframework in $OUTPUT_DIR"
