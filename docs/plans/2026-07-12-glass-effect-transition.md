# Glass Effect Transition Backport Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `Backported.GlassEffectTransition` and `View.backport.glassEffectTransition(_:)` with native forwarding on Apple OS 26 and no-op fallback elsewhere.

**Architecture:** Model Apple's three transition values with package-owned private variant storage. A separate view extension performs the platform availability check and bridges that value to `SwiftUI.GlassEffectTransition` only where the native API exists.

**Tech Stack:** Swift 6, SwiftUI, `swift-backport-pattern`, Swift Testing, Swift Package Manager, Xcode 26

## Global Constraints

- Preserve deployment targets: iOS 13, macOS 10.15, tvOS 13, watchOS 6, and visionOS 1.
- Expose exactly `identity`, `matchedGeometry`, and `materialize` transition variants.
- Add no public transition cases, configuration parameters, or additional dependencies.
- Forward only on iOS, macOS, tvOS, and watchOS 26 or newer.
- Return `content` unchanged on older systems and visionOS.
- Do not use `AnyTransition`, opacity, or `matchedGeometryEffect` as a fallback.

---

### Task 1: Transition Value And View Modifier

**Files:**
- Create: `Sources/LiquidGlassBackport/Backported+GlassEffectTransition.swift`
- Create: `Sources/LiquidGlassBackport/View+GlassEffectTransition.swift`
- Modify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

**Interfaces:**
- Consumes: `Backported.GlassEffectTransition` and `Backport<Content>`, where `Content: View`.
- Produces: `Backported.GlassEffectTransition.identity`, `.matchedGeometry`, `.materialize`, and `Backport.glassEffectTransition(_:)`.

- [ ] **Step 1: Add the failing compile-time test**

Inside the existing `#if canImport(SwiftUI)` scope in `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`, add this test before the final `#endif`:

```swift
@Test("Backport glassEffectTransition(_:) supports all transition variants")
@MainActor
func glassEffectTransitionBackportSupportsAllVariants() {
    let transitions: [Backported.GlassEffectTransition] = [
        .identity,
        .matchedGeometry,
        .materialize
    ]

    for transition in transitions {
        let view = Text("Liquid Glass")
            .backport.glassEffect()
            .backport.glassEffectTransition(transition)

        _ = view
    }

    _ = Text("Matched Geometry")
        .backport.glassEffectTransition(.matchedGeometry)
    _ = Text("Materialize")
        .backport.glassEffectTransition(.materialize)
}
```

- [ ] **Step 2: Verify the test fails before implementation**

Run: `swift test --filter glassEffectTransitionBackportSupportsAllVariants`

Expected: compilation fails because `Backported.GlassEffectTransition` and `Backport.glassEffectTransition(_:)` are undefined.

- [ ] **Step 3: Create the package-owned transition value and native bridge**

Create `Sources/LiquidGlassBackport/Backported+GlassEffectTransition.swift`:

```swift
import SwiftUI

public extension Backported {
    /// A backport value for configuring Liquid Glass effect transitions.
    struct GlassEffectTransition: Sendable {
        private enum Variant: Sendable {
            case identity
            case matchedGeometry
            case materialize
        }

        private let variant: Variant

        private init(variant: Variant) {
            self.variant = variant
        }

        /// The identity transition specifying no changes.
        public static var identity: Self { Self(variant: .identity) }

        /// A transition that matches the geometry of compatible glass effects.
        public static var matchedGeometry: Self {
            Self(variant: .matchedGeometry)
        }

        /// A transition that materializes glass without geometry matching.
        public static var materialize: Self { Self(variant: .materialize) }

        #if !os(visionOS)
        @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
        var swiftUITransition: SwiftUI.GlassEffectTransition {
            switch variant {
            case .identity:
                .identity
            case .matchedGeometry:
                .matchedGeometry
            case .materialize:
                .materialize
            }
        }
        #endif
    }
}
```

- [ ] **Step 4: Create the view modifier**

Create `Sources/LiquidGlassBackport/View+GlassEffectTransition.swift`:

```swift
import SwiftUI

public extension Backport where Content: View {
    /// Backport of SwiftUI `View.glassEffectTransition(_:)`.
    ///
    /// On Apple OS 26+ this forwards transition metadata to native Liquid Glass.
    /// On earlier OS versions and visionOS it leaves the content unchanged.
    @MainActor
    @ViewBuilder
    func glassEffectTransition(
        _ transition: Backported.GlassEffectTransition
    ) -> some View {
        #if os(visionOS)
        content
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            content.glassEffectTransition(transition.swiftUITransition)
        } else {
            content
        }
        #endif
    }
}
```

- [ ] **Step 5: Verify targeted and complete package tests**

```bash
swift test --filter glassEffectTransitionBackportSupportsAllVariants
swift test
```

Expected: the selected test passes, then all package tests pass.

- [ ] **Step 6: Build the macOS package**

```bash
xcodebuild build \
  -scheme swiftui-liquid-glass-backport \
  -destination 'platform=macOS' \
  CODE_SIGNING_ALLOWED=NO
```

Expected: Xcode prints `** BUILD SUCCEEDED **`.

- [ ] **Step 7: Inspect and commit the implementation**

```bash
git diff --check
git status --short
```

Expected: no whitespace errors; only the two new source files and test file are modified, aside from generated `.swiftpm/` artifacts that must not be staged.

```bash
git add \
  Sources/LiquidGlassBackport/Backported+GlassEffectTransition.swift \
  Sources/LiquidGlassBackport/View+GlassEffectTransition.swift \
  Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift
git commit -m "feat(glass): add glass effect transition backport"
```
