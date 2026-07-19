# Glass Effect Union Backport Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `View.backport.glassEffectUnion(id:namespace:)` with native Liquid Glass union forwarding on Apple OS 26 and no-op fallback behavior elsewhere.

**Architecture:** Add a focused extension for glass union metadata. It shares SwiftUI's `Namespace.ID` availability floor with `glassEffectID`, but has separate source ownership because union rendering semantics are distinct from transition identity.

**Tech Stack:** Swift 6, SwiftUI, `swift-backport-pattern`, Swift Testing, Swift Package Manager, Xcode 26

## Global Constraints

- Preserve deployment targets: iOS 13, macOS 10.15, tvOS 13, watchOS 6, and visionOS 1.
- Expose the method from iOS 14, macOS 11, tvOS 14, and watchOS 7, matching `Namespace.ID` availability.
- Match `View.glassEffectUnion(id:namespace:)` with an `ID: Hashable & Sendable` generic identifier and `Namespace.ID` namespace.
- Add no configuration parameters or additional public types.
- Forward only on iOS, macOS, tvOS, and watchOS 26 or newer.
- Return `content` unchanged on older systems and visionOS.
- Do not combine fallback paths, backgrounds, or shapes.

---

### Task 1: Glass Effect Union Modifier

**Files:**
- Create: `Sources/LiquidGlassBackport/View+GlassEffectUnion.swift`
- Modify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

**Interfaces:**
- Consumes: `Backport<Content>`, where `Content: View`, and SwiftUI's `Namespace.ID`.
- Reuses: `GlassEffectIDTestIdentifier` from the existing test target.
- Produces: `func glassEffectUnion<ID: Hashable & Sendable>(id: ID?, namespace: Namespace.ID) -> some View`.

- [ ] **Step 1: Add compile-time union call-site coverage**

Inside the existing `#if canImport(SwiftUI)` scope in `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`, add the following test view and test before the final `#endif`:

```swift
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private struct GlassEffectUnionCallSite: View {
    @Namespace private var namespace

    var body: some View {
        VStack {
            Text("String")
                .backport.glassEffectUnion(id: "string", namespace: namespace)
            Text("Custom")
                .backport.glassEffectUnion(
                    id: GlassEffectIDTestIdentifier(rawValue: 1),
                    namespace: namespace
                )

            let identifier: String? = nil
            Text("Nil")
                .backport.glassEffectUnion(id: identifier, namespace: namespace)
        }
    }
}

@Test("Backport glassEffectUnion(id:namespace:) accepts supported identifiers")
@MainActor
func glassEffectUnionBackportAcceptsSupportedIdentifiers() {
    if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
        _ = GlassEffectUnionCallSite()
    }
}
```

- [ ] **Step 2: Verify the test fails before implementation**

Run: `swift test --filter glassEffectUnionBackportAcceptsSupportedIdentifiers`

Expected: compilation fails because `Backport<Content>` has no `glassEffectUnion(id:namespace:)` member.

- [ ] **Step 3: Add the isolated backport extension**

Create `Sources/LiquidGlassBackport/View+GlassEffectUnion.swift`:

```swift
import SwiftUI

public extension Backport where Content: View {
    /// Backport of SwiftUI `View.glassEffectUnion(id:namespace:)`.
    ///
    /// On Apple OS 26+ this forwards union metadata to native Liquid Glass.
    /// On earlier OS versions and visionOS it leaves the content unchanged.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @MainActor
    @ViewBuilder
    func glassEffectUnion<ID: Hashable & Sendable>(
        id: ID?,
        namespace: Namespace.ID
    ) -> some View {
        #if os(visionOS)
        content
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            content.glassEffectUnion(id: id, namespace: namespace)
        } else {
            content
        }
        #endif
    }
}
```

- [ ] **Step 4: Verify targeted test coverage**

Run: `swift test --filter glassEffectUnionBackportAcceptsSupportedIdentifiers`

Expected: the selected Swift Testing test passes and the package compiles the `String`, custom `Hashable & Sendable`, and typed `nil` union call sites.

- [ ] **Step 5: Verify the complete package and macOS build**

```bash
swift test
xcodebuild build \
  -scheme swiftui-liquid-glass-backport \
  -destination 'platform=macOS' \
  CODE_SIGNING_ALLOWED=NO
```

Expected: all package tests pass and Xcode prints `** BUILD SUCCEEDED **`.

- [ ] **Step 6: Inspect and commit the implementation**

```bash
git diff --check
git status --short
```

Expected: no whitespace errors; only the new source file and test file are modified, aside from generated `.swiftpm/` artifacts that must not be staged.

```bash
git add \
  Sources/LiquidGlassBackport/View+GlassEffectUnion.swift \
  Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift
git commit -m "feat(glass): add glass effect union backport"
```
