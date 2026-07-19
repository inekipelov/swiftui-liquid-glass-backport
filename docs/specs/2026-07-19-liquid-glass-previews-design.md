# Liquid Glass Previews Design

## Goal

Add three self-contained Xcode previews that demonstrate the library's three
implemented Liquid Glass categories: button styles, custom views, and search
UI. The previews should make each effect visually obvious and show package API
usage that can be copied into an application.

The examples follow Apple's patterns from:

- [Build a SwiftUI app with the new design](https://developer.apple.com/videos/play/wwdc2025/323/)
- [Applying Liquid Glass to custom views](https://developer.apple.com/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views)

## Location and Build Scope

Add exactly three files:

```text
Sources/LiquidGlassBackport/Previews/ButtonStylesPreview.swift
Sources/LiquidGlassBackport/Previews/CustomViewsPreview.swift
Sources/LiquidGlassBackport/Previews/SearchAPIPreview.swift
```

Each complete file is guarded with:

```swift
#if DEBUG && os(iOS)
```

This keeps the previews discoverable by Xcode Canvas for iOS Debug builds
while excluding all preview declarations and sample UI from Release builds and
from macOS, tvOS, watchOS, and visionOS compilation.

Preview-only views are private. They do not add public package API.

## Button Styles Preview

`ButtonStylesPreview.swift` presents a compact call-to-action card over a
colorful gradient so the glass material has visible content to sample.

It demonstrates:

```swift
.buttonStyle(.backport.glass)
.buttonStyle(.backport.glassProminent)
.buttonStyle(.backport.glass(.regular.tint(.orange).interactive()))
```

The hierarchy contains a standard action, a prominent primary action, and a
tinted semantic action. The example uses standard `Button` and `Label`
components rather than custom button rendering.

## Custom Views Preview

`CustomViewsPreview.swift` presents multiple symbol badges inside
`Backported.GlassEffectContainer`. A local `@State` value expands and
collapses the badge collection, while `@Namespace` and package identity APIs
demonstrate morphing.

It demonstrates:

```swift
Backported.GlassEffectContainer(spacing:content:)
View.backport.glassEffect(_:in:)
View.backport.glassEffectID(_:in:)
View.backport.glassEffectTransition(_:)
```

The effects are applied after layout and appearance modifiers. Interactive
glass is used only on the control that responds to input. Related glass views
share one container, following Apple's rendering and sampling guidance.

## Search API Preview

`SearchAPIPreview.swift` presents a searchable list in a `NavigationStack`.
The list filters immediately from local sample data so the search field is
functional in Xcode's interactive preview.

It demonstrates:

```swift
View.backport.searchToolbarBehavior(.minimize)
Backported.ToolbarSpacer(_:placement:)
Backported.DefaultToolbarItem(kind:placement:)
Backported.ToolbarDefaultItemKind.search
```

The toolbar follows Apple's bottom-bar example: flexible spacing positions the
default search item, and fixed spacing separates it from an adjacent compose
action. Existing SwiftUI `searchable` remains responsible for search state and
results.

Because the toolbar-content wrappers start at iOS 17.5, the preview body uses
an availability branch before constructing the search example. Xcode Canvas
on iOS 26 exercises the native forwarding paths.

## Visual Treatment

Each file is self-contained and uses system colors, SF Symbols, and gradients;
no image assets or shared fourth preview file are added. Previews use an iPhone
canvas and remain interactive where the demonstrated API is interactive.

## Verification

- Run `swift test` to ensure the package and existing tests remain valid.
- Run the package test target on an iOS 26 simulator so all three Debug-only
  preview files and their `#Preview` expansions compile.
- Run `git diff --check` and inspect the final diff for public declarations,
  native-only API calls, or files outside the approved three-preview scope.

## Exclusions

- No preview-only Swift Package target.
- No public demo types or reusable sample-model API.
- No asset catalog or downloaded media.
- No `Backported.Tab` or search-tab example.
- No changes to the behavior of existing backport APIs.
