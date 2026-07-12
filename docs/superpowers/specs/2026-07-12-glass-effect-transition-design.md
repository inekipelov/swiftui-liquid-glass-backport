# Glass Effect Transition Backport Design

## Objective

Add a package-owned representation of SwiftUI's `GlassEffectTransition` and a
backport of `View.glassEffectTransition(_:)`. The API configures native glass
effect transitions on supported systems without changing general view
transitions on older systems.

## Public API

```swift
public extension Backported {
    struct GlassEffectTransition: Sendable {
        public static var identity: Self { get }
        public static var matchedGeometry: Self { get }
        public static var materialize: Self { get }
    }
}

public extension Backport where Content: View {
    @MainActor
    @ViewBuilder
    func glassEffectTransition(
        _ transition: Backported.GlassEffectTransition
    ) -> some View
}
```

The public surface has exactly Apple's three transition variants. It adds no
parameters or custom transition cases.

## Runtime Behavior

On iOS 26, macOS 26, tvOS 26, and watchOS 26 or newer,
`glassEffectTransition(_:)` forwards the bridged value to SwiftUI's native
modifier.

On earlier supported operating systems and visionOS, the modifier returns
`content` unchanged. Apple does not expose the native Liquid Glass transition
API on visionOS.

## Structure

`Sources/LiquidGlassBackport/Backported+GlassEffectTransition.swift` defines
the `Backported.GlassEffectTransition` value and its private native bridge.
`Sources/LiquidGlassBackport/View+GlassEffectTransition.swift` owns runtime
availability selection and native modifier forwarding.

The type uses private variant storage, following `Backported.Glass`. The native
bridge is compiled out on visionOS and is only available on Apple OS 26 or
newer.

## Testing

Swift Testing compile-time coverage will verify:

- Each public transition variant.
- Composition with `.backport.glassEffect()`.
- Calls to `.backport.glassEffectTransition(.matchedGeometry)` and
  `.materialize`.

The existing GitHub Actions matrix verifies iOS, macOS, tvOS, watchOS, and
visionOS availability boundaries.

## Constraints And Trade-offs

The fallback does not use `AnyTransition`, opacity, or
`matchedGeometryEffect`. Those APIs change the full view transition and cannot
reproduce Apple's coordination of Liquid Glass effects inside
`GlassEffectContainer`. Returning content unchanged preserves layout and avoids
unexpected animations.
