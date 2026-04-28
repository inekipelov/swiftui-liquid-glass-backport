# LiquidGlassBackport

`LiquidGlassBackport` is a tiny Swift Package that composes Liquid Glass
backports behind one import.

It builds on [`swift-backport-pattern`](https://github.com/inekipelov/swift-backport-pattern),
[`swiftui-glass-type-backport`](https://github.com/inekipelov/swiftui-glass-type-backport),
and [`swiftui-button-style-backport`](https://github.com/inekipelov/swiftui-button-style-backport).

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0+-F05138?logo=swift&logoColor=white" alt="Swift 6.0+"></a>
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-13.0+-CAFC63?logo=apple" alt="iOS 13.0+"></a>
  <a href="https://developer.apple.com/macos/"><img src="https://img.shields.io/badge/macOS-10.15+-CAFC63?logo=apple" alt="macOS 10.15+"></a>
  <a href="https://developer.apple.com/tvos/"><img src="https://img.shields.io/badge/tvOS-13.0+-CAFC63?logo=apple" alt="tvOS 13.0+"></a>
  <a href="https://developer.apple.com/watchos/"><img src="https://img.shields.io/badge/watchOS-6.0+-CAFC63?logo=apple" alt="watchOS 6.0+"></a>
  <a href="https://developer.apple.com/visionos/"><img src="https://img.shields.io/badge/visionOS-1.0+-CAFC63?logo=apple" alt="visionOS 1.0+"></a>
</p>

## Usage

// Later

## Installation

Add the package to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/inekipelov/swiftui-liquid-glass-backport.git", from: "0.1.0")
```

Then add `LiquidGlassBackport` to your target dependencies:

```swift
.product(name: "LiquidGlassBackport", package: "swiftui-liquid-glass-backport")
```

`LiquidGlassBackport` re-exports `Backport`, `ButtonStyleBackport`, and
`GlassBackport` through package linking, so you can keep one top-level dependency.

## Apple Liquid Glass docs

- [Liquid Glass overview](https://developer.apple.com/documentation/technologyoverviews/liquid-glass)
- [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)
