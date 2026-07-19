# Toolbar Spacer Legacy Fallback Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the empty legacy `Backported.ToolbarSpacer` content with a best-effort SwiftUI `Spacer()` toolbar item while leaving native OS 26 forwarding unchanged.

**Architecture:** Keep the public `Backported.ToolbarSpacer(_:placement:)` API and its existing `ToolbarContent` implementation. Only the pre-iOS 26 and pre-macOS 26 branches change from `EmptyView()` to `Spacer()`; documentation explicitly states that legacy `.fixed` and `.flexible` share this approximate fallback.

**Tech Stack:** Swift 6, SwiftUI, Swift Testing, Xcode 26.5, iOS 18.6 and iOS 26.5 simulators

## Global Constraints

- Preserve the public signatures of `Backported.ToolbarSpacer` and `Backported.SpacerSizing`.
- Keep native `SwiftUI.ToolbarSpacer` forwarding unchanged on iOS 26 and macOS 26.
- Use `Spacer()` for both `.fixed` and `.flexible` on older systems.
- Do not add UIKit, AppKit, runtime introspection, or a new dependency.
- Do not change `Backported.DefaultToolbarItem` or its empty fallback.
- Do not add public, package, or internal API solely to inspect opaque toolbar content.
- Keep `ToolbarSpacer` unavailable on tvOS, watchOS, and visionOS.
- Treat compile-smoke, platform builds, and visual simulator inspection as the verification boundary for framework-owned toolbar layout.

---

### Task 1: Replace the Empty Legacy Toolbar Content

**Files:**
- Modify: `Sources/LiquidGlassBackport/Backported+ToolbarSpacer.swift`
- Verify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

**Interfaces:**
- Consumes: `Backported.ToolbarSpacer.init(_:placement:)`, `Backported.SpacerSizing`, `SwiftUI.ToolbarItem`, and `SwiftUI.Spacer`
- Produces: unchanged public toolbar-content API with a `Spacer()`-based legacy body

- [x] **Step 1: Record the old fallback contract**

Run:

```bash
rg -n 'EmptyView\(\)' Sources/LiquidGlassBackport/Backported+ToolbarSpacer.swift
```

Expected: two matches, one in the unavailable-OS-26 branch and one in the compile-time non-iOS/macOS branch. This is the approved source-level red check because the concrete `ToolbarContent` body is opaque and the specification rejects adding test-only API to expose it.

- [x] **Step 2: Replace the fallback and update its API documentation**

In `Sources/LiquidGlassBackport/Backported+ToolbarSpacer.swift`, replace the type documentation and `body` implementation with:

```swift
    /// Backport of SwiftUI `ToolbarSpacer`.
    ///
    /// On iOS 26 and macOS 26 this forwards to SwiftUI. On earlier systems it
    /// inserts a customizable toolbar item containing a best-effort `Spacer`.
    struct ToolbarSpacer: ToolbarContent, CustomizableToolbarContent {
        private let sizing: SpacerSizing
        private let placement: ToolbarItemPlacement
        private let fallbackID: String

        public init(
            _ sizing: SpacerSizing = .flexible,
            placement: ToolbarItemPlacement = .automatic
        ) {
            self.sizing = sizing
            self.placement = placement
            fallbackID = UUID().uuidString
        }

        @ToolbarContentBuilder
        public var body: some CustomizableToolbarContent {
            #if os(iOS) || os(macOS)
            if #available(iOS 26.0, macOS 26.0, *) {
                SwiftUI.ToolbarSpacer(
                    sizing.spacerSizing,
                    placement: placement
                )
            } else {
                ToolbarItem(id: fallbackID, placement: placement) {
                    Spacer()
                }
            }
            #else
            ToolbarItem(id: fallbackID, placement: placement) {
                Spacer()
            }
            #endif
        }
    }
```

- [x] **Step 3: Verify the source contract changed exactly once**

Run:

```bash
rg -n 'EmptyView\(\)' Sources/LiquidGlassBackport/Backported+ToolbarSpacer.swift
rg -n 'Spacer\(\)' Sources/LiquidGlassBackport/Backported+ToolbarSpacer.swift
```

Expected:

- the `EmptyView` scan exits 1 and prints nothing;
- the `Spacer` scan prints exactly two fallback lines;
- the native `SwiftUI.ToolbarSpacer` call is unchanged.

- [x] **Step 4: Run the package tests**

Run:

```bash
swift test
```

Expected: all 12 existing tests pass. The existing `ToolbarSpacerCallSite` continues to compile its default, `.fixed`, `.flexible`, placement, and customizable-toolbar usages.

---

### Task 2: Align Public and Planning Documentation

**Files:**
- Modify: `README.md`
- Modify: `ROADMAP.md`
- Modify: `docs/plans/2026-07-18-search-ui-backports.md`
- Verify: `docs/specs/2026-07-13-search-ui-roadmap-design.md`

**Interfaces:**
- Consumes: the implemented `Spacer()` legacy fallback from Task 1
- Produces: repository documentation that distinguishes the Spacer fallback from `DefaultToolbarItem`'s empty fallback

- [x] **Step 1: Update the README API table**

In `README.md`, replace:

```markdown
| `Backported.ToolbarSpacer(_:placement:)` | Uses the native spacer or empty toolbar content |
```

with:

```markdown
| `Backported.ToolbarSpacer(_:placement:)` | Uses the native spacer or a best-effort SwiftUI `Spacer` item |
```

Keep the adjacent `Backported.DefaultToolbarItem(kind:placement:)` row unchanged.

- [x] **Step 2: Update the completed roadmap entry**

In `ROADMAP.md`, replace:

```markdown
- [x] Implement `Backported.ToolbarSpacer(_:placement:)` with a neutral older-system fallback.
```

with:

```markdown
- [x] Implement `Backported.ToolbarSpacer(_:placement:)` with a best-effort SwiftUI `Spacer` fallback on older systems.
```

- [x] **Step 3: Align the original implementation plan with the final contract**

In `docs/plans/2026-07-18-search-ui-backports.md`, change the architecture paragraph to:

```markdown
**Architecture:** Package-owned values mirror the native SwiftUI API shape.
View modifiers forward on Apple OS 26 and preserve their content earlier.
`ToolbarSpacer` forwards on supported OS 26 platforms and otherwise emits a
toolbar item containing `Spacer`; `DefaultToolbarItem` continues to emit empty
toolbar content. Their minimum versions follow SwiftUI's safe
limited-availability `ToolbarContent` support.
```

Replace the completed Task 2 item:

```markdown
- [x] Add `Backported.ToolbarSpacer` with native forwarding and empty toolbar
  content on older systems.
```

with:

```markdown
- [x] Add `Backported.ToolbarSpacer` with native forwarding and a best-effort
  SwiftUI `Spacer` toolbar item on older systems.
```

- [x] **Step 4: Verify documentation consistency**

Run:

```bash
rg -n 'ToolbarSpacer.*empty|Toolbar spacing.*empty|ToolbarSpacer.*neutral' \
  README.md \
  ROADMAP.md \
  docs/specs/2026-07-13-search-ui-roadmap-design.md \
  docs/plans/2026-07-18-search-ui-backports.md
```

Expected: no active description claims that `Backported.ToolbarSpacer` uses empty or neutral legacy content. Historical removal instructions may mention the deleted roadmap wording but must not describe the current implementation.

Run:

```bash
rg -n 'DefaultToolbarItem.*empty|default search.*empty|Default search items.*empty' \
  README.md \
  docs/specs/2026-07-13-search-ui-roadmap-design.md \
  docs/plans/2026-07-18-search-ui-backports.md
```

Expected: the default search item remains documented as empty on older systems.

---

### Task 3: Verify Legacy and Native Toolbar Paths

**Files:**
- Verify: `Sources/LiquidGlassBackport/Backported+ToolbarSpacer.swift`
- Verify: `Sources/LiquidGlassBackport/Previews/SearchAPIPreview.swift`
- Verify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

**Interfaces:**
- Consumes: the completed source and documentation changes
- Produces: compiler, test, and visual evidence for both legacy and native availability paths

- [x] **Step 1: Run repository verification scripts**

Run:

```bash
swift test
bash scripts/test-release-scripts.sh
```

Expected: 12 Swift tests pass and all release-script tests pass.

- [x] **Step 2: Exercise the legacy iOS 18.6 build and tests**

Run:

```bash
xcodebuild test -quiet \
  -scheme swiftui-liquid-glass-backport \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=18.6' \
  -derivedDataPath /tmp/lg-backport-toolbar-spacer-ios18 \
  CODE_SIGNING_ALLOWED=NO
```

Expected: exit 0; the pre-iOS-26 `Spacer()` fallback compiles and all 12 tests pass.

- [x] **Step 3: Exercise the native iOS 26.5 path**

Run:

```bash
xcodebuild test -quiet \
  -scheme swiftui-liquid-glass-backport \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5' \
  -derivedDataPath /tmp/lg-backport-toolbar-spacer-ios26 \
  CODE_SIGNING_ALLOWED=NO
```

Expected: exit 0; native `SwiftUI.ToolbarSpacer` forwarding compiles and all 12 tests pass.

- [x] **Step 4: Inspect the legacy fallback visually**

Use the `build-ios-apps:ios-simulator-browser` skill to render `SearchAPIPreview` from `Sources/LiquidGlassBackport/Previews/SearchAPIPreview.swift` on iPhone 16 Pro Max / iOS 18.6.

Expected:

- the preview renders without a toolbar-layout warning or crash;
- the Filter and Compose actions remain visible;
- the fallback spacer allocates visible horizontal separation between the actions;
- the default search item remains absent because its legacy fallback is still empty.

- [x] **Step 5: Inspect the native path visually**

Render the same `SearchAPIPreview` on iPhone 17 Pro Max / iOS 26.5.

Expected:

- the native search item is visible;
- native fixed and flexible toolbar spacing remains intact;
- the source change causes no visual regression on the native path.

- [x] **Step 6: Verify Release compilation and diff integrity**

Run:

```bash
xcodebuild build -quiet \
  -configuration Release \
  -scheme swiftui-liquid-glass-backport \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/lg-backport-toolbar-spacer-release \
  CODE_SIGNING_ALLOWED=NO
git diff --check
git status --short
```

Expected:

- Release build exits 0;
- `git diff --check` exits 0;
- status contains only the approved source, README, ROADMAP, implementation-plan, and new plan changes.

- [x] **Step 7: Commit the implementation**

```bash
git add \
  Sources/LiquidGlassBackport/Backported+ToolbarSpacer.swift \
  README.md \
  ROADMAP.md \
  docs/plans/2026-07-18-search-ui-backports.md \
  docs/plans/2026-07-19-toolbar-spacer-fallback.md
git commit -m "feat: add Spacer toolbar fallback"
```
