# Glass Effect ID Backport Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `View.backport.glassEffectID(_:in:)` with native Liquid Glass identity forwarding on Apple OS 26 and no-op fallback behavior elsewhere.

**Architecture:** Add one focused extension file for Liquid Glass transition identity, separate from the rendering fallback in `View+GlassEffect.swift`. The method preserves Apple's identifier and namespace inputs. Native SwiftUI handles the effect on supported platforms; unsupported systems return the original content unchanged.

**Tech Stack:** Swift 6, SwiftUI, `swift-backport-pattern`, Swift Testing, Swift Package Manager, Xcode 26

## Global Constraints

- Preserve deployment targets: iOS 13, macOS 10.15, tvOS 13, watchOS 6, and visionOS 1.
- Match `View.glassEffectID(_:in:)` with an `ID: Hashable & Sendable` generic identifier and `Namespace.ID` namespace.
- Expose the method from iOS 14, macOS 11, tvOS 14, and watchOS 7, matching `Namespace.ID` availability.
- Add no configuration parameters or additional public types.
- Forward only on iOS, macOS, tvOS, and watchOS 26 or newer.
- Return `content` unchanged on older systems and visionOS.
- Do not use `matchedGeometryEffect` as a fallback.

---

### Task 1: Glass Effect Identity Modifier

**Files:**
- Create: `Sources/LiquidGlassBackport/View+GlassEffectID.swift`
- Modify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

**Interfaces:**
- Consumes: `Backport<Content>`, where `Content: View`, and SwiftUI's `Namespace.ID`.
- Produces: `func glassEffectID<ID: Hashable & Sendable>(_ id: ID?, in namespace: Namespace.ID) -> some View`.

- [ ] **Step 1: Add compile-time call-site coverage**

Inside the existing `#if canImport(SwiftUI)` scope in `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`, add the following support type and test before the final `#endif`:

```swift
private struct GlassEffectIDTestIdentifier: Hashable, Sendable {
    let rawValue: Int
}

private struct GlassEffectIDCallSite: View {
    @Namespace private var namespace

    var body: some View {
        VStack {
            Text("String")
                .backport.glassEffectID("string", in: namespace)
            Text("Custom")
                .backport.glassEffectID(
                    GlassEffectIDTestIdentifier(rawValue: 1),
                    in: namespace
                )

            let identifier: String? = nil
            Text("Nil")
                .backport.glassEffectID(identifier, in: namespace)
        }
    }
}

@Test("Backport glassEffectID(_:in:) accepts supported identifiers")
@MainActor
func glassEffectIDBackportAcceptsSupportedIdentifiers() {
    _ = GlassEffectIDCallSite()
}
```

- [ ] **Step 2: Verify the test fails before implementation**

Run: `swift test --filter glassEffectIDBackportAcceptsSupportedIdentifiers`

Expected: compilation fails because `Backport<Content>` has no `glassEffectID(_:in:)` member.

- [ ] **Step 3: Add the isolated backport extension**

Create `Sources/LiquidGlassBackport/View+GlassEffectID.swift`:

```swift
import SwiftUI

public extension Backport where Content: View {
    /// Backport of SwiftUI `View.glassEffectID(_:in:)`.
    ///
    /// On Apple OS 26+ this forwards identity metadata to native Liquid Glass.
    /// On earlier OS versions and visionOS it leaves the content unchanged.
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    @MainActor
    @ViewBuilder
    func glassEffectID<ID: Hashable & Sendable>(
        _ id: ID?,
        in namespace: Namespace.ID
    ) -> some View {
        #if os(visionOS)
        content
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            content.glassEffectID(id, in: namespace)
        } else {
            content
        }
        #endif
    }
}
```

- [ ] **Step 4: Verify targeted test coverage**

Run: `swift test --filter glassEffectIDBackportAcceptsSupportedIdentifiers`

Expected: the selected Swift Testing test passes and the package compiles the `String`, custom `Hashable & Sendable`, and typed `nil` call sites.

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
  Sources/LiquidGlassBackport/View+GlassEffectID.swift \
  Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift
git commit -m "feat(glass): add glass effect ID backport"
```
