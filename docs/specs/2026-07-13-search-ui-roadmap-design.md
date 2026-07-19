# iOS 26 Search UI Backport Design

## Goal

Backport the SwiftUI search chrome APIs introduced in iOS 26, without
expanding the scope to APIs that already existed in earlier SDKs.

## Scope

The implementation covers the following package-owned configuration types and
forwarding APIs:

```swift
Backported.SearchToolbarBehavior.automatic
Backported.SearchToolbarBehavior.minimize
View.backport.searchToolbarBehavior(_:)

Backported.SpacerSizing.fixed
Backported.SpacerSizing.flexible
Backported.ToolbarSpacer(_:placement:)

Backported.ToolbarDefaultItemKind.search
Backported.DefaultToolbarItem(kind:placement:)
```

`SearchPresentationToolbarBehavior` is excluded because it was introduced in
iOS 17.1, macOS 14.1, tvOS 17.1, and watchOS 10.1. `TabRole.search` is excluded
because it was introduced with `TabRole` in iOS 18, macOS 15, tvOS 18,
watchOS 11, and visionOS 2. Those APIs can be evaluated separately, but they
are not iOS 26 API backports.

## Compatibility Behavior

- On iOS 26 and corresponding Apple platform releases, package APIs forward
  to the native SwiftUI implementation.
- Search toolbar behavior modifiers preserve their input view on older
  systems.
- A default search toolbar item does not emulate a custom search field on
  older systems; existing `searchable` behavior remains authoritative.
- Toolbar spacing and default search items use empty toolbar content as a
  neutral older-system fallback.
- The toolbar-content wrappers start at iOS 17.5 and macOS 14.5 because
  SwiftUI only safely type-erases limited-availability `ToolbarContent` from
  those releases. `DefaultToolbarItem` also supports visionOS 1 and later;
  `ToolbarSpacer` follows the native API and is unavailable on visionOS,
  tvOS, and watchOS.

## Exclusions

- No `Backported.Tab`, `Backported.TabView`, or `Backported.TabRole`.
- No `Backported.SearchPresentationToolbarBehavior`.
- No backport of the pre-iOS 26 `searchable`, `tabItem`, or sidebar search
  APIs.
- No custom search field or tab container implementation.

## Documentation Changes

- Mark implemented iOS 26 Search UI APIs in `ROADMAP.md`.
- Add the implemented APIs and their fallback behavior to `README.md`.
- Keep the requested `Backported.GlassEffectTransition.identity`,
  `.matchedGeometry`, and `.materialize` README mention removed without
  changing the implemented transition API.

## Verification

- Add compile-smoke tests for every new type, value, initializer, and modifier.
- Run SwiftPM tests and the repository release-script tests.
- Build the package for every platform covered by the CI matrix when practical.
- Inspect the final diff and confirm excluded pre-iOS 26 APIs were not added.
