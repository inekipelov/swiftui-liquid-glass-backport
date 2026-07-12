# LiquidGlassBackport

`LiquidGlassBackport` is a tiny Swift Package that composes Liquid Glass
backports behind one import.

It builds on [`swift-backport-pattern`](https://github.com/inekipelov/swift-backport-pattern)
and provides its Liquid Glass configuration and view backports locally.

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0+-F05138?logo=swift&logoColor=white" alt="Swift 6.0+"></a>
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-13.0+-CAFC63?logo=apple" alt="iOS 13.0+"></a>
  <a href="https://developer.apple.com/macos/"><img src="https://img.shields.io/badge/macOS-10.15+-CAFC63?logo=apple" alt="macOS 10.15+"></a>
  <a href="https://developer.apple.com/tvos/"><img src="https://img.shields.io/badge/tvOS-13.0+-CAFC63?logo=apple" alt="tvOS 13.0+"></a>
  <a href="https://developer.apple.com/watchos/"><img src="https://img.shields.io/badge/watchOS-6.0+-CAFC63?logo=apple" alt="watchOS 6.0+"></a>
  <a href="https://developer.apple.com/visionos/"><img src="https://img.shields.io/badge/visionOS-1.0+-CAFC63?logo=apple" alt="visionOS 1.0+"></a>
</p>

## Quick Start

```swift
import LiquidGlassBackport

Backported.GlassEffectContainer(spacing: 12) {
    Text("Liquid Glass")
        .padding()
        .backport.glassEffect(.regular.tint(.blue).interactive())

    Button("Continue") {}
        .buttonStyle(.backport.glassProminent)
}
```

## Backported APIs

| API | Backport behavior |
| --- | --- |
| `View.backport.glassEffect(_:in:)` | Uses native glass or a material-based fallback |
| `Backported.GlassEffectContainer(spacing:content:)` | Uses the native container or preserves its content |
| `View.backport.glassEffectID(_:in:)` | Uses native metadata or preserves its content |
| `View.backport.glassEffectUnion(id:namespace:)` | Uses native metadata or preserves its content |
| `Backported.GlassEffectTransition.identity`, `.matchedGeometry`, `.materialize` | Package-owned transition configuration |
| `View.backport.glassEffectTransition(_:)` | Uses the native transition or preserves its content |
| `View.backport.backgroundExtensionEffect()` | Uses the native effect or preserves its content |
| `View.backport.backgroundExtensionEffect(isEnabled:)` | Uses the native effect or preserves its content |
| `.buttonStyle(.backport.glass)` | Uses native glass or a bordered style |
| `.buttonStyle(.backport.glassProminent)` | Uses native glass or a bordered prominent style |
| `.buttonStyle(.backport.glass(_))` | Uses native configured glass or a bordered style |

## Installation

Add the package to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/inekipelov/swiftui-liquid-glass-backport.git", from: "26.0.0")
```

Then add `LiquidGlassBackport` to your target dependencies:

```swift
.product(name: "LiquidGlassBackport", package: "swiftui-liquid-glass-backport")
```

`LiquidGlassBackport` re-exports `Backport`

## Apple Liquid Glass docs

- [Liquid Glass overview](https://developer.apple.com/documentation/technologyoverviews/liquid-glass)
- [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)

## Roadmap

See [ROADMAP.md](ROADMAP.md) for implemented APIs and planned backports.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development, testing, versioning,
and release requirements.

## Related projects

- [UniversalGlass](https://github.com/Aeastr/UniversalGlass) by [Aeastr](https://github.com/Aeastr)
- [iOS-Backports](https://github.com/superwall/iOS-Backports) by [Superwall](https://github.com/superwall)
- [SwiftUIBackports](https://github.com/shaps80/SwiftUIBackports) by [Shaps Benon](https://github.com/shaps80)
