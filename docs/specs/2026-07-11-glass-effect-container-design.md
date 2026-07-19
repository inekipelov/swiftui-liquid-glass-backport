# GlassEffectContainer Backport Design

## Objective

Add a `Backported.GlassEffectContainer` view that preserves the public shape of
Apple's `SwiftUI.GlassEffectContainer` while supporting the package's existing
deployment targets.

## Public API

```swift
public extension Backported {
    struct GlassEffectContainer<Content: View>: View {
        @MainActor
        public init(
            spacing: CGFloat? = nil,
            @ViewBuilder content: () -> Content
        )
    }
}
```

The initializer has the same two inputs as Apple's API: optional `spacing` and
a view-building `content` closure. The backport adds no configuration options.

Example:

```swift
Backported.GlassEffectContainer(spacing: 16) {
    HStack(spacing: 16) {
        firstView.backport.glassEffect()
        secondView.backport.glassEffect()
    }
}
```

## Runtime Behavior

On iOS 26, macOS 26, tvOS 26, and watchOS 26 or newer, the backport forwards
the stored content and spacing to `SwiftUI.GlassEffectContainer`.

On earlier supported operating systems, the container returns its content
without adding layout, rendering, or interaction behavior. Nested
`.backport.glassEffect(...)` modifiers continue to render their existing
per-view fallback.

On visionOS, the container always returns its content because Apple marks
`SwiftUI.GlassEffectContainer` unavailable on that platform.

## Structure

The implementation belongs in
`Sources/LiquidGlassBackport/Backported+GlassEffectContainer.swift`.
The view stores only:

- `spacing: CGFloat?`
- The built generic `Content`

Its `body` selects the native container or unmodified content with compile-time
visionOS exclusion and runtime availability checks for other platforms.

## Testing

Swift Testing coverage will verify that:

- The initializer compiles with omitted spacing.
- The initializer compiles with explicit spacing.
- The content closure supports multiple child views through `@ViewBuilder`.
- The backport composes with `.backport.glassEffect(...)`.
- visionOS and pre-26 platform builds do not reference the unavailable native
  container.

The existing GitHub Actions platform matrix provides the cross-platform build
verification that cannot be completed locally without every Apple platform SDK.

## Constraints And Trade-offs

The fallback intentionally does not emulate shape merging, morphing, or shared
rendering optimization. Those behaviors are private SwiftUI implementation
details and cannot be reproduced faithfully with public APIs. Returning content
unchanged preserves layout and avoids introducing non-native parameters or
surprising rendering behavior.
