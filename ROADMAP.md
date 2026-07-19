# Roadmap

LiquidGlassBackport backports Apple's Liquid Glass APIs and the adjacent
system chrome APIs that are required to build consistent interfaces across
older Apple platforms and OS releases.

## Foundation

- [x] Create the `LiquidGlassBackport` Swift package.
- [x] Use `swift-backport-pattern` for the `View.backport` API namespace.
- [x] Keep `LiquidGlassBackport.swift` limited to package imports.
- [x] Use Swift Testing for package tests.
- [x] Test SwiftPM builds on macOS 15 and macOS 26 in GitHub Actions.
- [x] Test iOS, tvOS, watchOS, and visionOS package compatibility in GitHub Actions.
- [x] Skip the expensive CI matrix for documentation-only pull requests.
- [x] Cancel obsolete CI runs for the same pull request or ref.
- [x] Require exactly one version label on every pull request.
- [x] Calculate Apple-platform-aligned calendar versions with tested scripts.
- [x] Publish annotated tags and GitHub Releases after merge into `main`.
- [x] Provide a dry-run mode for release calculation.
- [x] Document contribution, compatibility, and release requirements.

## Liquid Glass Effects

- [x] Add `Backported.Glass` with `.regular`, `.clear`, and `.identity`.
- [x] Support `Glass.interactive(_:)` and `Glass.tint(_:)`.
- [x] Expose fallback configuration through `material`, `color`, `edgeColor`, and `shadowColor`.
- [x] Implement `View.backport.glassEffect(_:in:)`.
- [x] Forward to native Liquid Glass on supported systems.
- [x] Provide a material-based fallback on older systems.
- [x] Add `Backported.GlassEffectContainer` with optional spacing.
- [x] Implement `View.backport.glassEffectID(_:in:)`.
- [x] Implement `View.backport.glassEffectUnion(id:namespace:)`.
- [x] Implement `Backported.GlassEffectTransition`.
- [x] Implement `View.backport.glassEffectTransition(_:)`.
- [x] Implement `View.backport.backgroundExtensionEffect()`.
- [x] Implement `View.backport.backgroundExtensionEffect(isEnabled:)`.

## Glass Button Styles

- [x] Implement `.buttonStyle(.backport.glass)`.
- [x] Implement `.buttonStyle(.backport.glassProminent)`.
- [x] Implement `.buttonStyle(.backport.glass(_))`.
- [x] Keep system button-style fallbacks internal to the library.
- [x] Remove the external ButtonStyleBackport dependency.

## Search UI

- [x] Add `Backported.SearchToolbarBehavior.automatic` and `.minimize`.
- [x] Implement `View.backport.searchToolbarBehavior(_:)` with a no-op fallback.
- [x] Add `Backported.SpacerSizing.fixed` and `.flexible`.
- [x] Implement `Backported.ToolbarSpacer(_:placement:)` with a best-effort SwiftUI `Spacer` fallback on older systems.
- [x] Add `Backported.ToolbarDefaultItemKind.search`.
- [x] Implement `Backported.DefaultToolbarItem(kind:placement:)` without emulating a custom search field on older systems.
- [x] Add compile-smoke coverage for search configuration and toolbar content.
- [x] Add a toolbar search usage example.

## Scroll and Safe-Area Chrome

- [ ] Implement `View.backport.scrollEdgeEffectStyle(_:for:)`.
- [ ] Implement `View.backport.scrollEdgeEffectHidden(_:for:)`.
- [ ] Implement `View.backport.safeAreaBar(edge:alignment:spacing:content:)`.
- [ ] Use `safeAreaInset` as the pre-native fallback for `safeAreaBar`.
- [ ] Document the fallback limitation: older systems cannot reproduce the native progressive blur.

## Toolbar and Tab Navigation

- [ ] Add `Backported.ToolbarDefaultItemKind.sidebarToggle`.
- [ ] Add `Backported.ToolbarDefaultItemKind.title`.
- [ ] Implement `View.backport.toolbar(removing:)` for default toolbar items.
- [ ] Implement `ToolbarContent.backport.sharedBackgroundVisibility(_:)`.
- [ ] Implement `CustomizableToolbarContent.backport.sharedBackgroundVisibility(_:)`.
- [ ] Implement `View.backport.tabViewBottomAccessory`.
- [ ] Add `TabViewBottomAccessoryPlacement` compatibility.
- [ ] Add `Backported.TabRole.automatic`.
- [ ] Add `Backported.TabRole.prominent` for newer systems.
- [ ] Preserve ordinary `TabView` navigation when tab roles are unavailable.
- [ ] Implement `View.backport.tabBarMinimizeBehavior(_:)`.
- [ ] Implement `View.backport.toolbarMinimizeBehavior(_:for:)` where the API is part of the supported deployment scope.
- [ ] Implement `Backported.ToolbarOverflowMenu`.
- [ ] Implement `View.backport.toolbarOverflowMenu(content:)`.
- [ ] Implement `ToolbarContent.backport.visibilityPriority(_:)`.
- [ ] Add `ToolbarItemPlacement.backport.topBarPinnedTrailing` compatibility.
- [ ] Add compile-smoke coverage for tab roles, accessories, and toolbar content.

## visionOS Glass

- [ ] Add a visionOS-specific `glassBackgroundEffect` compatibility layer.
- [ ] Support `glassBackgroundEffect(displayMode:)`.
- [ ] Support shape-based `glassBackgroundEffect(in:displayMode:)` overloads.
- [ ] Preserve native `GlassBackgroundEffect` configuration without adding package-only parameters.
- [ ] Evaluate `preferredSurroundingsEffect(_:)` separately; it is spatial-environment behavior rather than a direct Liquid Glass effect.

## iOS 27 and Later

- [ ] Track public Liquid Glass API additions in Apple's SDK documentation.
- [ ] Verify the iOS 27 refreshed Liquid Glass appearance against the existing forwarding APIs.
- [ ] Do not add a package API for the system Liquid Glass slider unless Apple exposes a public control surface.
- [ ] Evaluate `ToolbarOverflowMenu`, toolbar visibility priority, and pinned toolbar placements as a separate adjacent system-chrome scope.

## Documentation and Compatibility

- [x] Document the public API in `README.md`.
- [x] Link Apple's Liquid Glass overview and adoption documentation.
- [x] Link related open-source backport projects and their authors.
- [x] Document the deprecation and migration lifecycle for native Liquid Glass APIs.
- [ ] Add usage examples for every completed tab and safe-area API.
- [ ] Add platform availability tests for every public API.
- [ ] Add a migration guide from the backport namespace to native SwiftUI APIs.
