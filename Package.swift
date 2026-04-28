// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swiftui-liquid-glass-backport",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "LiquidGlassBackport",
            targets: ["LiquidGlassBackport"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/inekipelov/swift-backport-pattern.git", from: "0.2.0"),
        .package(url: "https://github.com/inekipelov/swiftui-button-style-backport.git", from: "0.2.1"),
        .package(url: "https://github.com/inekipelov/swiftui-glass-type-backport.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "LiquidGlassBackport",
            dependencies: [
                .product(name: "Backport", package: "swift-backport-pattern"),
                .product(name: "ButtonStyleBackport", package: "swiftui-button-style-backport"),
                .product(name: "GlassBackport", package: "swiftui-glass-type-backport")
            ]
        ),
        .testTarget(
            name: "LiquidGlassBackportTests",
            dependencies: ["LiquidGlassBackport"]
        )
    ]
)
