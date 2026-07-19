# Background Extension Effect Backport Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `View.backport.backgroundExtensionEffect()` and `backgroundExtensionEffect(isEnabled:)` with native forwarding on Apple OS 26 and no-op fallback on older systems.

**Architecture:** Implement both overloads in one focused `Backport where Content: View` extension. Native SwiftUI owns mirrored safe-area copies, blur, and clipping on OS 26; earlier platforms return the original content without changing layout. Lifecycle annotations cover every Apple platform because the native API includes visionOS 26.

**Tech Stack:** Swift 6, SwiftUI, `swift-backport-pattern`, Swift Testing, Swift Package Manager, Xcode 26

## Global Constraints

- Preserve deployment targets: iOS 13, macOS 10.15, tvOS 13, watchOS 6, and visionOS 1.
- Match exactly `backgroundExtensionEffect()` and `backgroundExtensionEffect(isEnabled: Bool)`.
- Add no custom rendering, configuration types, or parameters.
- Forward only on iOS, macOS, tvOS, watchOS, and visionOS 26 or newer.
- Return `content` unchanged on earlier operating systems.
- Deprecate on version 26 and obsolete on version 27 for every Apple platform.

---

### Task 1: Background Extension Effect Modifiers

**Files:**
- Create: `Sources/LiquidGlassBackport/View+BackgroundExtensionEffect.swift`
- Modify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`
- Modify: `README.md`

**Interfaces:**
- Consumes: `Backport<Content>`, where `Content: View`.
- Produces: `func backgroundExtensionEffect() -> some View` and `func backgroundExtensionEffect(isEnabled: Bool) -> some View`.

- [ ] **Step 1: Add failing compile-time coverage for both overloads**

Inside the existing `#if canImport(SwiftUI)` scope in `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`, add this test before the final `#endif`:

```swift
@Test("Backport backgroundExtensionEffect supports both overloads")
@MainActor
func backgroundExtensionEffectBackportSupportsBothOverloads() {
    _ = Text("Default")
        .backport.backgroundExtensionEffect()
    _ = Text("Enabled")
        .backport.backgroundExtensionEffect(isEnabled: true)
    _ = Text("Disabled")
        .backport.backgroundExtensionEffect(isEnabled: false)
}
```

- [ ] **Step 2: Verify the test fails before implementation**

Run: `swift test --filter backgroundExtensionEffectBackportSupportsBothOverloads`

Expected: compilation fails because `Backport<Content>` has no `backgroundExtensionEffect` members.

- [ ] **Step 3: Create the backport extension**

Create `Sources/LiquidGlassBackport/View+BackgroundExtensionEffect.swift`:

```swift
import SwiftUI

@available(iOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native background extension effect.")
@available(macOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native background extension effect.")
@available(tvOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native background extension effect.")
@available(watchOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native background extension effect.")
@available(visionOS, deprecated: 26.0, obsoleted: 27.0, message: "Use SwiftUI's native background extension effect.")
public extension Backport where Content: View {
    /// Backport of SwiftUI `View.backgroundExtensionEffect()`.
    @MainActor
    @ViewBuilder
    func backgroundExtensionEffect() -> some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            content.backgroundExtensionEffect()
        } else {
            content
        }
    }

    /// Backport of SwiftUI `View.backgroundExtensionEffect(isEnabled:)`.
    @MainActor
    @ViewBuilder
    func backgroundExtensionEffect(isEnabled: Bool) -> some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            content.backgroundExtensionEffect(isEnabled: isEnabled)
        } else {
            content
        }
    }
}
```

- [ ] **Step 4: Document the new API**

Add this subsection to `README.md` after the `View effects` examples:

````markdown
### Background extension

Extend detail content beneath a system sidebar or inspector on Apple OS 26+:

```swift
BannerView()
    .backport.backgroundExtensionEffect(isEnabled: true)
```

Earlier operating systems leave the view unchanged.
````

- [ ] **Step 5: Verify targeted and complete package tests**

```bash
swift test --filter backgroundExtensionEffectBackportSupportsBothOverloads
swift test
```

Expected: the selected test passes, then all package tests pass.

- [ ] **Step 6: Build for macOS 26 lifecycle verification**

```bash
xcodebuild build \
  -quiet \
  -scheme swiftui-liquid-glass-backport \
  -destination 'platform=macOS' \
  MACOSX_DEPLOYMENT_TARGET=26.0 \
  CODE_SIGNING_ALLOWED=NO
```

Expected: Xcode exits successfully. The library must not emit self-deprecation errors.

- [ ] **Step 7: Inspect and commit the implementation**

```bash
git diff --check
git status --short
```

Expected: no whitespace errors; only the new extension, test file, and README are modified, aside from generated `.swiftpm/` artifacts that must not be staged.

```bash
git add \
  Sources/LiquidGlassBackport/View+BackgroundExtensionEffect.swift \
  Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift \
  README.md
git commit -m "feat(view): add background extension backport"
```
