# Glass Effect ID Backport Design

## Objective

Add a backport of SwiftUI's `View.glassEffectID(_:in:)` modifier while
preserving Apple's public API semantics on supported systems and avoiding
incorrect geometry animation on older systems.

## Public API

```swift
public extension Backport where Content: View {
    @MainActor
    @ViewBuilder
    func glassEffectID<ID: Hashable & Sendable>(
        _ id: ID?,
        in namespace: Namespace.ID
    ) -> some View
}
```

The generic constraint is equivalent to Apple's opaque
`(some Hashable & Sendable)?` parameter. The backport adds no configuration
parameters.

## Runtime Behavior

On iOS 26, macOS 26, tvOS 26, and watchOS 26 or newer, the modifier forwards
the identifier and namespace to SwiftUI's native `glassEffectID(_:in:)`.

On earlier supported operating systems, the modifier returns `content`
unchanged. On visionOS it also returns `content`, because Apple does not expose
the native modifier on that platform.

A `nil` identifier is forwarded unchanged on supported systems and remains a
no-op elsewhere.

## Structure

The implementation belongs in
`Sources/LiquidGlassBackport/View+GlassEffectID.swift`. Keeping transition
identity separate from `View+GlassEffect.swift` prevents rendering fallback
logic and container-coordination metadata from sharing one implementation
scope.

## Testing

Swift Testing compile-time coverage will verify calls using:

- A `String` identifier.
- A custom `Hashable & Sendable` identifier.
- A typed `nil` identifier.

The existing GitHub Actions matrix verifies availability boundaries for iOS,
macOS, tvOS, watchOS, and visionOS.

## Constraints And Trade-offs

The fallback does not use `matchedGeometryEffect`. That modifier animates the
entire view geometry, requires source coordination that Apple's API does not
expose, and cannot reproduce coordination between native glass effects,
`GlassEffectContainer`, and `GlassEffectTransition`. Returning content
unchanged preserves layout and avoids introducing behavior not present in the
original API.
