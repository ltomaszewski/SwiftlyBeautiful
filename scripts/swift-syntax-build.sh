#!/bin/bash

# Set variables
SWIFT_SYNTAX_REPO="https://github.com/apple/swift-syntax.git"
SWIFT_SYNTAX_VERSION="509.0.0" # Change this as needed
OUTPUT_DIR="swift-syntax-precompiled"
XCFRAMEWORK_OUTPUT="$OUTPUT_DIR/SwiftSyntax.xcframework"
PACKAGE_NAME="swift-syntax-binary-package"

# 1. Clone the SwiftSyntax repository
git clone --branch "$SWIFT_SYNTAX_VERSION" "$SWIFT_SYNTAX_REPO" swift-syntax

# Navigate to the cloned repository
cd swift-syntax || exit

# 2. Build SwiftSyntax for macOS (x86_64 and arm64) in background
echo "Building SwiftSyntax for macOS..."
swift build --configuration release --arch x86_64 --arch arm64

## 3. Build SwiftSyntax for iOS (arm64 and x86_64 for simulator) in background
#echo "Building SwiftSyntax for iOS..."
#swift build --configuration release --arch arm64 --arch x86_64 --destination 'generic/platform=iOS' &

# 4. Wait for both builds to finish

# 5. Create an XCFramework
echo "Creating XCFramework..."
mkdir -p ../$OUTPUT_DIR
xcodebuild -create-xcframework \
    -framework build/arm64-apple-macosx/release/SwiftSyntax.framework \
    -framework build/x86_64-apple-macosx/release/SwiftSyntax.framework \
    -output "../$XCFRAMEWORK_OUTPUT"

# 6. Navigate back and clean up
cd ..
rm -rf swift-syntax

# 7. Create the Package.swift for the precompiled version
echo "Creating Package.swift..."

cat <<EOL > "$OUTPUT_DIR/Package.swift"
// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "$PACKAGE_NAME",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "SwiftSyntax",
            targets: ["SwiftSyntax"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "SwiftSyntax",
            path: "./SwiftSyntax.xcframework"
        ),
    ]
)
EOL

echo "Precompiled SwiftSyntax package is ready in $OUTPUT_DIR!"
