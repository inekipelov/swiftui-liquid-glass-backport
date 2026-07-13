# iOS 26 Search UI Roadmap Design

## Goal

Extend the library roadmap with the SwiftUI search chrome APIs introduced in
iOS 26, without expanding the scope into a general `Tab` or `TabView`
backport.

## Scope

The roadmap will cover the following package-owned configuration types and
forwarding APIs:

```swift
Backported.SearchToolbarBehavior.automatic
Backported.SearchToolbarBehavior.minimize
View.backport.searchToolbarBehavior(_:)

Backported.SearchPresentationToolbarBehavior.automatic
Backported.SearchPresentationToolbarBehavior.avoidHidingContent
View.backport.searchPresentationToolbarBehavior(_:)

Backported.SpacerSizing.fixed
Backported.SpacerSizing.flexible
Backported.ToolbarSpacer(_:placement:)

Backported.ToolbarDefaultItemKind.search
Backported.DefaultToolbarItem(kind:placement:)

Backported.TabRole.search
Tab.init(role:content:)
```

The `Tab` overload accepts `Backported.TabRole`. It forwards `.search` to the
native SwiftUI role on iOS 26 and preserves an ordinary tab on iOS 18 through
iOS 25. It is unavailable on earlier systems because `SwiftUI.Tab` itself was
introduced in iOS 18.

## Compatibility Behavior

- On iOS 26 and corresponding Apple platform releases, package APIs forward
  to the native SwiftUI implementation.
- Search toolbar behavior modifiers preserve their input view on older
  systems.
- Search presentation toolbar behavior preserves its input view on older
  systems.
- A default search toolbar item does not emulate a custom search field on
  older systems; existing `searchable` behavior remains authoritative.
- Toolbar spacing uses the closest neutral toolbar-content fallback supported
  by the older platform.
- `Backported.TabRole.search` is a no-op on systems where `SwiftUI.Tab` exists
  but the native search role does not.

## Exclusions

- No `Backported.Tab` or `Backported.TabView`.
- No backport of the pre-iOS 26 `searchable`, `tabItem`, or sidebar search
  APIs.
- No attempt to reproduce the iOS 26 search-tab transformation on systems
  where SwiftUI does not provide it.
- No custom search field or tab container implementation.

## Documentation Changes

- Add a dedicated Search UI section to `ROADMAP.md`.
- Reconcile existing toolbar and tab roadmap items so each API appears once.
- Remove the `Backported.GlassEffectTransition.identity`,
  `.matchedGeometry`, `.materialize` row from the README API table without
  removing or changing the implemented transition API.

## Verification

- Inspect the final documentation diff for unrelated changes and duplicate
  roadmap entries.
- Confirm the removed README row no longer appears.
- Confirm every planned type, value, initializer, and modifier is named in the
  roadmap.
- Run Markdown-sensitive repository checks if the repository provides them.

