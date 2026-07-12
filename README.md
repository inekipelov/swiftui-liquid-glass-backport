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

## Usage

Import the package once:

```swift
import LiquidGlassBackport
```

### Glass configuration

`Backported.Glass` mirrors SwiftUI's Liquid Glass configuration values:

```swift
let glass = Backported.Glass.regular
    .tint(.blue)
    .interactive()
```

Available variants are `.regular`, `.clear`, and `.identity`.
For custom legacy fallbacks, the value also exposes `material`, `color`,
`edgeColor`, and `shadowColor`.

### View effects

Apply Liquid Glass to a custom view with `.backport.glassEffect(_:in:)`:

```swift
Text("Liquid Glass")
    .padding(16)
    .backport.glassEffect(
        .regular.tint(.blue).interactive(),
        in: RoundedRectangle(cornerRadius: 16)
    )
```

Use `Backported.GlassEffectContainer` to coordinate multiple effects. On
Apple OS 26+, it forwards to SwiftUI's native container; earlier systems keep
their content and individual effect fallbacks.

```swift
Backported.GlassEffectContainer(spacing: 16) {
    Image(systemName: "pencil")
        .padding()
        .backport.glassEffect()

    Image(systemName: "note")
        .padding()
        .backport.glassEffect(.clear)
}
```

### Background extension

Extend detail content beneath a system sidebar or inspector on Apple OS 26+:

```swift
BannerView()
    .backport.backgroundExtensionEffect(isEnabled: true)
```

Earlier operating systems leave the view unchanged.

### Union and transitions

`glassEffectID(_:in:)` and `glassEffectUnion(id:namespace:)` are available on
iOS 14, macOS 11, tvOS 14, and watchOS 7 or newer because they use
`Namespace.ID`. `glassEffectTransition(_:)` accepts the package-owned
`Backported.GlassEffectTransition` values:

```swift
struct ControlsView: View {
    @Namespace private var glassNamespace

    var body: some View {
        Text("Action")
            .padding()
            .backport.glassEffect()
            .backport.glassEffectID("action", in: glassNamespace)
            .backport.glassEffectUnion(id: "controls", namespace: glassNamespace)
            .backport.glassEffectTransition(.matchedGeometry)
    }
}
```

Available transition values are `.identity`, `.matchedGeometry`, and
`.materialize`.

### Button styles

The package exposes glass button styles through the `backport` namespace:

```swift
Button("Glass") {}
    .buttonStyle(.backport.glass)

Button("Prominent") {}
    .buttonStyle(.backport.glassProminent)

Button("Configured") {}
    .buttonStyle(.backport.glass(.regular.interactive().tint(.blue)))
```

On Apple OS 26+, these APIs forward to native SwiftUI Liquid Glass. Older
systems use the package's platform-appropriate fallback or leave transition
metadata unchanged when it has no visual equivalent.

## Availability lifecycle

On iOS, macOS, tvOS, and watchOS, Liquid Glass entry points and glass button
styles are deprecated when an app raises its minimum deployment target to
version 26 and become unavailable at version 27. This lets the compiler
identify migration points to native SwiftUI APIs. visionOS remains exempt
because Apple doesn't expose the same native Liquid Glass API surface there.

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

- [iOS-Backports](https://github.com/superwall/iOS-Backports) by [Superwall](https://github.com/superwall)
- [SwiftUIBackports](https://github.com/shaps80/SwiftUIBackports) by [Shaps Benon](https://github.com/shaps80)
