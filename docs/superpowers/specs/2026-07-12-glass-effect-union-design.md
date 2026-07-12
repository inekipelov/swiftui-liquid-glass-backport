# Glass Effect Union Backport Design

## Objective

Add a backport of SwiftUI's `View.glassEffectUnion(id:namespace:)` modifier.
It preserves native Liquid Glass union behavior on supported systems without
attempting to combine legacy fallback shapes across separate views.

## Public API

```swift
public extension Backport where Content: View {
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @MainActor
    @ViewBuilder
    func glassEffectUnion<ID: Hashable & Sendable>(
        id: ID?,
        namespace: Namespace.ID
    ) -> some View
}
```

The generic identifier is equivalent to Apple's
`(some Hashable & Sendable)?` parameter. The availability floor matches
`Namespace.ID`, which is unavailable on the package's older deployment
targets. The backport adds no parameters or public types.

## Runtime Behavior

On iOS 26, macOS 26, tvOS 26, and watchOS 26 or newer, the modifier forwards
the identifier and namespace to SwiftUI's native
`glassEffectUnion(id:namespace:)`.

On systems where `Namespace.ID` is available but the native modifier is not,
the method returns `content` unchanged. On visionOS it also returns
`content`, because Apple does not expose the native modifier there.

A `nil` identifier is forwarded unchanged on supported systems and remains a
no-op elsewhere.

## Structure

The implementation belongs in
`Sources/LiquidGlassBackport/View+GlassEffectUnion.swift`. Union metadata has
a separate responsibility from transition identity in
`View+GlassEffectID.swift`, even though both use `Namespace.ID`.

## Testing

Swift Testing compile-time coverage will verify calls using:

- A `String` identifier.
- A custom `Hashable & Sendable` identifier.
- A typed `nil` identifier.

The existing GitHub Actions platform matrix verifies iOS, macOS, tvOS, watchOS,
and visionOS availability boundaries.

## Constraints And Trade-offs

The fallback does not aggregate legacy material backgrounds with preferences,
anchors, or custom paths. Native union behavior combines only compatible Liquid
Glass effects with matching identifiers, shapes, and variants; reproducing that
across independent fallback views would require a new container protocol,
change layout and rendering ownership, and add behavior outside Apple's API.
Returning content unchanged preserves layout and avoids a misleading visual
approximation.
