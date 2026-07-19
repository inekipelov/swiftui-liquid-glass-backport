# iOS 26 Search UI Backports Implementation Plan

**Goal:** Implement the iOS 26 search toolbar and toolbar-content APIs with
native forwarding and neutral older-system fallbacks.

**Architecture:** Package-owned values mirror the native SwiftUI API shape.
View modifiers forward on Apple OS 26 and preserve their content earlier.
Toolbar-content wrappers forward on supported OS 26 platforms and otherwise
emit empty toolbar items; their minimum versions follow SwiftUI's safe
limited-availability `ToolbarContent` support.

**Tech Stack:** Swift 6, SwiftUI, Swift Testing, SwiftPM

## Task 1: Search toolbar behavior

**Files:**

- Add: `Sources/LiquidGlassBackport/Backported+SearchToolbarBehavior.swift`
- Add: `Sources/LiquidGlassBackport/View+SearchToolbarBehavior.swift`
- Modify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

- [x] Add a failing compile-smoke test for `.automatic`, `.minimize`, and
  `View.backport.searchToolbarBehavior(_:)`.
- [x] Add `Backported.SearchToolbarBehavior` with native platform
  availability for `.minimize`.
- [x] Forward the modifier on OS 26 and preserve content on older systems.
- [x] Run `swift test`.

## Task 2: Toolbar spacer

**Files:**

- Add: `Sources/LiquidGlassBackport/Backported+SpacerSizing.swift`
- Add: `Sources/LiquidGlassBackport/Backported+ToolbarSpacer.swift`
- Modify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

- [x] Add a failing compile-smoke test for both sizing values, default
  arguments, explicit sizing, and placement.
- [x] Add `Backported.SpacerSizing` and native bridging on iOS 26 and macOS 26.
- [x] Add `Backported.ToolbarSpacer` with native forwarding and empty toolbar
  content on older systems.
- [x] Run `swift test`.

## Task 3: Default search toolbar item

**Files:**

- Add: `Sources/LiquidGlassBackport/Backported+ToolbarDefaultItemKind.swift`
- Add: `Sources/LiquidGlassBackport/Backported+DefaultToolbarItem.swift`
- Modify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

- [x] Add a failing compile-smoke test for `.search`, the default placement,
  and an explicit placement.
- [x] Add `Backported.ToolbarDefaultItemKind.search`.
- [x] Add `Backported.DefaultToolbarItem` with native forwarding and empty
  toolbar content on older systems.
- [x] Run `swift test`.

## Task 4: Public documentation and verification

**Files:**

- Modify: `README.md`
- Modify: `ROADMAP.md`
- Modify: `docs/specs/2026-07-13-search-ui-roadmap-design.md`

- [x] Document the implemented APIs and compatibility floors.
- [x] Remove roadmap commitments for `SearchPresentationToolbarBehavior` and
  `TabRole.search`, which predate iOS 26.
- [x] Run `swift test` and `bash scripts/test-release-scripts.sh`.
- [x] Build the Swift package for the Apple-platform CI destinations that are
  available locally.
- [x] Run `git diff --check` and inspect the final diff.
