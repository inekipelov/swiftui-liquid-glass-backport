# Glass Button Styles Backport Design

## Objective

Move the glass button style API from `swiftui-button-style-backport` into this
package without retaining that package as a dependency. The implementation is
a selective port from upstream commit
`438d12b17527c6cb7cfa784a97e8dd322e60f201`.

## Public API

The package will support the same three call sites as the upstream package:

```swift
Button("Glass") {}
    .buttonStyle(.backport.glass)

Button("Prominent") {}
    .buttonStyle(.backport.glassProminent)

Button("Tinted") {}
    .buttonStyle(
        .backport.glass(.regular.interactive(true).tint(.blue))
    )
```

The entry point remains `PrimitiveButtonStyle.backport`. No calculated
`buttonStyle` property is added to `Backported.Glass`, and no parameters beyond
Apple's native glass button style API are introduced.

## Structure

The selective port consists of four source files:

- `PrimitiveButtonStyle+Backport.swift` provides the `.backport` namespace.
- `SystemButtonStyle+Backport.swift` provides only the `borderless`, `bordered`,
  and `borderedProminent` helpers required by legacy fallbacks.
- `GlassButtonStyle+Backport.swift` provides `glass` and `glass(_:)`.
- `GlassProminentButtonStyle+Backport.swift` provides `glassProminent`.

The configured overload accepts the package-owned `Backported.Glass`. Its
native bridge uses the existing `Backported.Glass.glass` calculated property;
the upstream package's former `swiftUIGlass` name is not restored.

## Runtime Behavior

On iOS 26, macOS 26, tvOS 26, and watchOS 26 or newer, the backport forwards to
SwiftUI's native glass button styles:

- `glass` forwards to `.glass`.
- `glass(_:)` forwards to `.glass(glass.glass)`.
- `glassProminent` forwards to `.glassProminent`.

On visionOS, where Apple does not expose the glass button styles, the backport
uses `bordered` for `glass` and `glass(_:)`, and `borderedProminent` for
`glassProminent`.

On earlier operating systems, the same system-style fallback chain as upstream
commit `438d12b` is preserved. Availability checks select the closest supported
SwiftUI style and ultimately fall back to `borderless` or `automatic` where a
bordered style is unavailable.

The fallback does not attempt to reproduce Liquid Glass rendering. It uses
native system button styles so interaction, accessibility, focus, and disabled
states remain owned by SwiftUI.

## Testing

Swift Testing coverage will compile all three public call sites and exercise
representative `Backported.Glass` configurations, including tint and
interactivity. The tests verify API composition rather than private SwiftUI
rendering behavior.

Verification will include:

- `swift test` for package tests on the local host.
- An Xcode build for the locally available Apple SDK.
- The existing GitHub Actions platform matrix for iOS, macOS, tvOS, watchOS,
  and visionOS availability boundaries.

## Scope And Trade-offs

The implementation does not copy unrelated upstream styles such as `link`,
`card`, `accessoryBar`, or `accessoryBarAction`. It does not add
`swiftui-button-style-backport` as a dependency and does not expose additional
fallback configuration.

Legacy styles will not visually match Liquid Glass. Preserving SwiftUI's
platform-native behavior is more reliable and maintainable than introducing a
custom button renderer that cannot reproduce Apple's private implementation.
