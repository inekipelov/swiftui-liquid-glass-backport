# GlassEffectContainer Backport Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `Backported.GlassEffectContainer` with Apple's initializer shape, native forwarding on supported OS 26 platforms, and a structural no-op fallback elsewhere.

**Architecture:** A focused SwiftUI view stores optional spacing and generic built content. Its body creates `SwiftUI.GlassEffectContainer` only where Apple exposes it; older systems and visionOS return the stored content unchanged, leaving nested glass-effect modifiers responsible for their own fallback rendering.

**Tech Stack:** Swift 6, SwiftUI, Swift Package Manager, Swift Testing, Xcode 26

---

## File Structure

- Create `Sources/LiquidGlassBackport/Backported+GlassEffectContainer.swift`: public backported container and native/no-op body selection.
- Modify `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`: compile-time API coverage for default spacing, explicit spacing, multiple children, and nested glass effects.

### Task 1: Add API Contract Tests

**Files:**
- Modify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

- [x] **Step 1: Add the failing compile-time tests**

Append the following tests inside the existing `#if canImport(SwiftUI)` block:

```swift
@Test("GlassEffectContainer supports default spacing")
@MainActor
func glassEffectContainerSupportsDefaultSpacing() {
    let container = Backported.GlassEffectContainer {
        Text("Glass")
            .backport.glassEffect()
    }

    _ = container
}

@Test("GlassEffectContainer supports explicit spacing and multiple children")
@MainActor
func glassEffectContainerSupportsSpacingAndMultipleChildren() {
    let container = Backported.GlassEffectContainer(spacing: 16) {
        Text("First")
            .backport.glassEffect()
        Text("Second")
            .backport.glassEffect()
    }

    _ = container
}
```

- [x] **Step 2: Run the tests and verify the API is missing**

Run:

```bash
swift test
```

Expected: compilation fails because `Backported` has no member type named
`GlassEffectContainer`.

### Task 2: Implement Backported.GlassEffectContainer

**Files:**
- Create: `Sources/LiquidGlassBackport/Backported+GlassEffectContainer.swift`
- Test: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

- [x] **Step 1: Add the minimal container implementation**

Create `Sources/LiquidGlassBackport/Backported+GlassEffectContainer.swift` with:

```swift
import SwiftUI

public extension Backported {
    @MainActor
    @preconcurrency
    struct GlassEffectContainer<Content: View>: View {
        private let spacing: CGFloat?
        private let content: Content

        public init(
            spacing: CGFloat? = nil,
            @ViewBuilder content: () -> Content
        ) {
            self.spacing = spacing
            self.content = content()
        }

        @ViewBuilder
        public var body: some View {
            #if os(visionOS)
            content
            #else
            if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
                SwiftUI.GlassEffectContainer(spacing: spacing) {
                    content
                }
            } else {
                content
            }
            #endif
        }
    }
}
```

This exposes only Apple's `spacing` and `content` inputs. The visionOS compile
guard is required because Apple marks its native type unavailable there.

- [x] **Step 2: Run Swift Testing**

Run:

```bash
swift test
```

Expected: all three Swift Testing tests pass: the existing glass-effect test and
the two new container API tests.

- [x] **Step 3: Check formatting and unintended changes**

Run:

```bash
git diff --check
git status --short
```

Expected: no whitespace errors; only the new source file and modified test file
appear as implementation changes.

- [x] **Step 4: Commit the implementation**

```bash
git add Sources/LiquidGlassBackport/Backported+GlassEffectContainer.swift \
  Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift
git commit -m "feat(container): backport glass effect container"
```

Expected: one commit containing the source and tests.

### Task 3: Verify Apple Platform Builds

**Files:**
- Verify: `.github/workflows/test.yml`

- [x] **Step 1: Build the macOS destination locally**

Run:

```bash
xcodebuild build \
  -scheme swiftui-liquid-glass-backport \
  -destination 'platform=macOS' \
  CODE_SIGNING_ALLOWED=NO
```

Expected: `** BUILD SUCCEEDED **`.

- [x] **Step 2: Verify the existing CI matrix covers the required branches**

Run:

```bash
rg -n "macOS 26|iOS 26 simulator|tvOS 26 simulator|watchOS 26 simulator|visionOS 26 simulator" \
  .github/workflows/test.yml
```

Expected: five matrix entries. No workflow changes are required.

- [x] **Step 3: Run final package verification**

Run:

```bash
swift test
git diff --check
git status --short
```

Expected: all three tests pass, no whitespace errors, and the implementation
commit leaves no uncommitted source or test changes.

The next pushed commit must pass the existing Xcode matrix. In particular,
visionOS verifies the compile-time no-op branch, while watchOS verifies native
container availability at watchOS 26.
