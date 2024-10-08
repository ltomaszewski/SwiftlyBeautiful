// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftlyBeautiful",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftlyBeautiful",
            targets: ["SwiftlyBeautiful"]
        ),
        .executable(
            name: "SwiftlyBeautifulClient",
            targets: ["SwiftlyBeautifulClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/sjavora/swift-syntax-xcframeworks.git", from: "510.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "SwiftlyBeautifulMacros",
            dependencies: [
                .product(name: "SwiftSyntaxWrapper", package: "swift-syntax-xcframeworks")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "SwiftlyBeautiful", dependencies: ["SwiftlyBeautifulMacros"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "SwiftlyBeautifulClient", dependencies: ["SwiftlyBeautiful"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "SwiftlyBeautifulTests",
            dependencies: [
                "SwiftlyBeautifulMacros",
                .product(name: "SwiftSyntaxWrapper", package: "swift-syntax-xcframeworks"),
            ]
        ),
    ]
)
