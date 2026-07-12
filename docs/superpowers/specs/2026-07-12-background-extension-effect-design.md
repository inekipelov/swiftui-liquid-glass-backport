# Background Extension Effect Backport Design

## Objective

Add backports of SwiftUI's `View.backgroundExtensionEffect()` and
`View.backgroundExtensionEffect(isEnabled:)`. The APIs provide native
background extension behavior on Apple OS 26 and preserve layout unchanged on
older systems.

## Public API

```swift
public extension Backport where Content: View {
    @MainActor
    @ViewBuilder
    func backgroundExtensionEffect() -> some View

    @MainActor
    @ViewBuilder
    func backgroundExtensionEffect(isEnabled: Bool) -> some View
}
```

The public surface exactly matches Apple's two overloads and adds no
configuration types or parameters.

## Runtime Behavior

On iOS 26, macOS 26, tvOS 26, watchOS 26, and visionOS 26 or newer, each
overload forwards to SwiftUI's corresponding native modifier.

On earlier supported operating systems, both overloads return `content`
unchanged. The disabled overload does not need separate fallback behavior,
because both paths are no-ops before the native API exists.

## Structure

The implementation belongs in
`Sources/LiquidGlassBackport/View+BackgroundExtensionEffect.swift`. The file
contains only the two view modifier overloads and their availability selection.

Because Apple supports this API on visionOS 26, native forwarding is not
excluded for that platform. Lifecycle annotations deprecate the backport on
every Apple platform at version 26 and obsolete it at version 27.

## Testing

Swift Testing compile-time coverage will verify:

- The parameterless overload.
- The `isEnabled: true` overload.
- The `isEnabled: false` overload.

The existing GitHub Actions matrix verifies platform availability boundaries.

## Constraints And Trade-offs

The legacy fallback does not duplicate, mirror, blur, clip, or extend content.
Apple's native effect creates safe-area copies and has clipping semantics that
cannot be recreated faithfully with public SwiftUI APIs without altering
layout, rendering cost, and hit testing. Returning content unchanged is the
only behavior-preserving fallback.
