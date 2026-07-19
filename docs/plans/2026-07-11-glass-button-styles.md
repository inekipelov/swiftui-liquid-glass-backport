# Glass Button Styles Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add package-owned `.backport.glass`, `.backport.glassProminent`, and `.backport.glass(_:)` primitive button styles.

**Architecture:** Extend `PrimitiveButtonStyle` with the existing `Backport` namespace, then selectively port the required system fallback helpers and glass style entries from `swiftui-button-style-backport` commit `438d12b`. Native OS 26 implementations delegate to SwiftUI; older platforms and visionOS use SwiftUI system styles.

**Tech Stack:** Swift 6, SwiftUI, `swift-backport-pattern`, Swift Testing, Swift Package Manager, Xcode 26

## Global Constraints

- Preserve deployment targets: iOS 13, macOS 10.15, tvOS 13, watchOS 6, and visionOS 1.
- Do not add `swiftui-button-style-backport` or another dependency.
- Expose exactly `.backport.glass`, `.backport.glassProminent`, and `.backport.glass(_:)` for this feature.
- Do not add a `buttonStyle` property to `Backported.Glass`.
- Use the existing `Backported.Glass.glass` native bridge.
- Do not port `link`, `card`, `accessoryBar`, or `accessoryBarAction`.
- Add no fallback configuration parameters beyond Apple's native API.

---

### Task 1: Namespace And System Fallback Styles

**Files:**
- Create: `Sources/LiquidGlassBackport/PrimitiveButtonStyle+Backport.swift`
- Create: `Sources/LiquidGlassBackport/SystemButtonStyle+Backport.swift`
- Modify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

**Interfaces:**
- Consumes: `Backport<Content>` from `swift-backport-pattern`.
- Produces: `PrimitiveButtonStyle.backport`, `Backport.borderless`, `Backport.bordered`, and `Backport.borderedProminent`.

- [ ] **Step 1: Add the failing compile-time test**

Append inside the existing `#if canImport(SwiftUI)` scope:

```swift
@Test("Button style backport exposes system fallback styles")
@MainActor
func buttonStyleBackportExposesSystemFallbackStyles() {
    _ = Button("Borderless") {}.buttonStyle(.backport.borderless)
    _ = Button("Bordered") {}.buttonStyle(.backport.bordered)
    _ = Button("Prominent") {}.buttonStyle(.backport.borderedProminent)
}
```

- [ ] **Step 2: Verify the test fails before implementation**

Run: `swift test --filter buttonStyleBackportExposesSystemFallbackStyles`

Expected: compilation fails because `PrimitiveButtonStyle` has no static member `backport`.

- [ ] **Step 3: Create the namespace**

Create `Sources/LiquidGlassBackport/PrimitiveButtonStyle+Backport.swift`:

```swift
import SwiftUI

public extension PrimitiveButtonStyle where Self == DefaultButtonStyle {
    /// A namespace for `DefaultButtonStyle` backports.
    @MainActor @preconcurrency
    static var backport: Backport<Self> {
        Backport(DefaultButtonStyle())
    }
}
```

- [ ] **Step 4: Create the required fallback helpers**

Create `Sources/LiquidGlassBackport/SystemButtonStyle+Backport.swift`:

```swift
import SwiftUI

public extension Backport where Content: PrimitiveButtonStyle {
    @MainActor
    var borderless: some PrimitiveButtonStyle {
        #if os(tvOS)
        if #available(tvOS 17.0, *) { return .borderless } else { return .plain }
        #elseif os(watchOS)
        if #available(watchOS 8.0, *) { return .borderless } else { return .automatic }
        #else
        return .borderless
        #endif
    }

    @MainActor
    var bordered: some PrimitiveButtonStyle {
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 15.0, *) { return .bordered } else { return .backport.borderless }
        #elseif os(iOS)
        if #available(iOS 15.0, *) { return .bordered } else { return .backport.borderless }
        #elseif os(macOS)
        if #available(macOS 12.0, *) { return .bordered } else { return .backport.borderless }
        #elseif os(tvOS) || os(visionOS)
        return .bordered
        #elseif os(watchOS)
        if #available(watchOS 7.0, *) { return .bordered } else { return .automatic }
        #else
        return .bordered
        #endif
    }

    @MainActor
    var borderedProminent: some PrimitiveButtonStyle {
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 15.0, *) { return .borderedProminent } else { return .borderless }
        #elseif os(iOS)
        if #available(iOS 15.0, *) { return .borderedProminent } else { return .borderless }
        #elseif os(macOS)
        if #available(macOS 12.0, *) { return .borderedProminent } else { return .borderless }
        #elseif os(tvOS)
        if #available(tvOS 15.0, *) { return .borderedProminent } else { return .bordered }
        #elseif os(watchOS)
        if #available(watchOS 8.0, *) { return .borderedProminent } else { return .automatic }
        #elseif os(visionOS)
        return .borderedProminent
        #else
        return .borderedProminent
        #endif
    }
}
```

Keep the upstream availability branches unchanged; formatting may be expanded to match Swift style.

- [ ] **Step 5: Verify the targeted test passes**

Run: `swift test --filter buttonStyleBackportExposesSystemFallbackStyles`

Expected: one selected test passes.

- [ ] **Step 6: Commit Task 1**

```bash
git add Sources/LiquidGlassBackport/PrimitiveButtonStyle+Backport.swift Sources/LiquidGlassBackport/SystemButtonStyle+Backport.swift Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift
git commit -m "feat(button-style): add system fallback styles"
```

### Task 2: Glass Button Styles

**Files:**
- Create: `Sources/LiquidGlassBackport/GlassButtonStyle+Backport.swift`
- Create: `Sources/LiquidGlassBackport/GlassProminentButtonStyle+Backport.swift`
- Modify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`

**Interfaces:**
- Consumes: the Task 1 namespace and fallback helpers, `Backported.Glass`, and `Backported.Glass.glass`.
- Produces: `Backport.glass`, `Backport.glass(_ glass: Backported.Glass)`, and `Backport.glassProminent`.

- [ ] **Step 1: Add tests for the three requested call sites**

Append inside the existing `#if canImport(SwiftUI)` scope:

```swift
@Test("Button style backport exposes glass styles")
@MainActor
func buttonStyleBackportExposesGlassStyles() {
    _ = Button("Glass") {}.buttonStyle(.backport.glass)
    _ = Button("Prominent") {}.buttonStyle(.backport.glassProminent)
    _ = Button("Configured") {}
        .buttonStyle(.backport.glass(.regular.interactive(true).tint(.blue)))
}
```

- [ ] **Step 2: Verify the test fails before implementation**

Run: `swift test --filter buttonStyleBackportExposesGlassStyles`

Expected: compilation fails because the glass style members are undefined.

- [ ] **Step 3: Create default and configured glass styles**

Create `Sources/LiquidGlassBackport/GlassButtonStyle+Backport.swift`:

```swift
import SwiftUI

public extension Backport where Content: PrimitiveButtonStyle {
    /// A backport of SwiftUI's default glass button style.
    @MainActor
    var glass: some PrimitiveButtonStyle {
        #if os(visionOS)
        return bordered
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            return .glass
        } else {
            return bordered
        }
        #endif
    }

    /// A backport of SwiftUI's configurable glass button style.
    @MainActor
    func glass(_ glass: Backported.Glass) -> some PrimitiveButtonStyle {
        #if os(visionOS)
        return .backport.bordered
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            return .glass(glass.glass)
        } else {
            return .backport.bordered
        }
        #endif
    }
}
```

- [ ] **Step 4: Create the prominent glass style**

Create `Sources/LiquidGlassBackport/GlassProminentButtonStyle+Backport.swift`:

```swift
import SwiftUI

public extension Backport where Content: PrimitiveButtonStyle {
    /// A backport of SwiftUI's prominent glass button style.
    @MainActor
    var glassProminent: some PrimitiveButtonStyle {
        #if os(visionOS)
        return .backport.borderedProminent
        #else
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            return .glassProminent
        } else {
            return .backport.borderedProminent
        }
        #endif
    }
}
```

- [ ] **Step 5: Verify targeted and complete tests pass**

Run:

```bash
swift test --filter buttonStyleBackportExposesGlassStyles
swift test
```

Expected: the selected test passes, then all five package tests pass.

- [ ] **Step 6: Commit Task 2**

```bash
git add Sources/LiquidGlassBackport/GlassButtonStyle+Backport.swift Sources/LiquidGlassBackport/GlassProminentButtonStyle+Backport.swift Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift
git commit -m "feat(button-style): add glass button styles"
```

### Task 3: Cross-Platform Verification

**Files:**
- Verify: `Sources/LiquidGlassBackport/PrimitiveButtonStyle+Backport.swift`
- Verify: `Sources/LiquidGlassBackport/SystemButtonStyle+Backport.swift`
- Verify: `Sources/LiquidGlassBackport/GlassButtonStyle+Backport.swift`
- Verify: `Sources/LiquidGlassBackport/GlassProminentButtonStyle+Backport.swift`
- Verify: `Tests/LiquidGlassBackportTests/LiquidGlassBackportTests.swift`
- Verify: `.github/workflows/test.yml`

**Interfaces:**
- Consumes: the complete API from Tasks 1 and 2.
- Produces: local build evidence and CI coverage for every supported Apple platform.

- [ ] **Step 1: Run package verification**

Run: `swift test`

Expected: all five tests pass without warnings from the new source files.

- [ ] **Step 2: Build with Xcode on macOS**

```bash
xcodebuild build -scheme swiftui-liquid-glass-backport -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO
```

Expected: `** BUILD SUCCEEDED **`.

- [ ] **Step 3: Confirm CI platform coverage**

```bash
rg -n 'macOS 26|iOS 26 simulator|tvOS 26 simulator|watchOS 26 simulator|visionOS 26 simulator' .github/workflows/test.yml
```

Expected: five matrix entries, covering every package platform.

- [ ] **Step 4: Inspect the final change set**

```bash
git diff --check HEAD~2..HEAD
git status --short
```

Expected: no whitespace errors and a clean working tree.
