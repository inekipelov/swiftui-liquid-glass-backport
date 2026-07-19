# Liquid Glass Previews Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add three iOS Xcode previews that demonstrate the library's button styles, custom-view effects, and search APIs using visually clear, interactive examples.

**Architecture:** Each category lives in one self-contained file under `Sources/LiquidGlassBackport/Previews`. Entire files are guarded by `#if DEBUG && os(iOS)`, and all preview-only views are private so Release builds and the public package API remain unchanged.

**Tech Stack:** Swift 6, SwiftUI, Xcode `#Preview`, Swift Testing, Xcode 26.5

## Global Constraints

- Create exactly three preview source files and no shared fourth preview file.
- Guard each complete file with `#if DEBUG && os(iOS)`.
- Keep every preview-only view and sample model private.
- Demonstrate package-owned `.backport` and `Backported` APIs, not direct native Liquid Glass calls.
- Use only system colors, gradients, and SF Symbols; add no assets or dependencies.
- Keep the search preview on the toolbar-search path; do not add `Backported.Tab` or a search-tab example.
- Do not change existing backport behavior, public API, `Package.swift`, or production tests.
- Treat preview compilation as the verification boundary because these files add sample UI rather than runtime library behavior.

---

### Task 1: Button Styles Preview

**Files:**
- Create: `Sources/LiquidGlassBackport/Previews/ButtonStylesPreview.swift`

**Interfaces:**
- Consumes: `PrimitiveButtonStyle.backport`, `Backport.glass`, `Backport.glassProminent`, `Backport.glass(_:)`, and `Backported.Glass`
- Produces: one private iOS preview demonstrating standard, prominent, and configured glass button styles

- [ ] **Step 1: Verify the preview is absent**

Run:

```bash
test -f Sources/LiquidGlassBackport/Previews/ButtonStylesPreview.swift
```

Expected: exit 1 because the preview has not been implemented.

- [ ] **Step 2: Create the button styles preview**

Create `Sources/LiquidGlassBackport/Previews/ButtonStylesPreview.swift`:

```swift
#if DEBUG && os(iOS)
import SwiftUI

@available(iOS 17.0, *)
private struct ButtonStylesPreview: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .cyan, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Explore Landmarks")
                        .font(.largeTitle.bold())
                    Text("Use glass styles for actions that float above content.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 14) {
                    Button {} label: {
                        Label("Learn More", systemImage: "book")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.backport.glass)

                    Button {} label: {
                        Label("Get Started", systemImage: "arrow.right")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.backport.glassProminent)

                    Button {} label: {
                        Label("Add to Favorites", systemImage: "heart.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(
                        .backport.glass(
                            .regular.tint(.orange).interactive()
                        )
                    )
                }
                .controlSize(.large)
            }
            .padding(28)
            .frame(maxWidth: 420)
        }
    }
}

#Preview("Button styles") {
    if #available(iOS 17.0, *) {
        ButtonStylesPreview()
    } else {
        Text("Requires iOS 17 or later")
    }
}
#endif
```

- [ ] **Step 3: Compile the iOS Debug target**

Run:

```bash
xcodebuild build -quiet \
  -scheme swiftui-liquid-glass-backport \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/lg-backport-button-preview \
  CODE_SIGNING_ALLOWED=NO
```

Expected: exit 0 with no Swift compiler diagnostics from `ButtonStylesPreview.swift`.

- [ ] **Step 4: Commit the button preview**

```bash
git add Sources/LiquidGlassBackport/Previews/ButtonStylesPreview.swift
git commit -m "docs: add Liquid Glass button preview"
```

---

### Task 2: Custom Views Preview

**Files:**
- Create: `Sources/LiquidGlassBackport/Previews/CustomViewsPreview.swift`

**Interfaces:**
- Consumes: `Backported.GlassEffectContainer`, `Backported.Glass`, `View.backport.glassEffect(_:in:)`, `View.backport.glassEffectID(_:in:)`, and `View.backport.glassEffectTransition(_:)`
- Produces: one private interactive iOS preview demonstrating grouped custom glass, shape, tint, interactivity, identity, and morphing

- [ ] **Step 1: Verify the preview is absent**

Run:

```bash
test -f Sources/LiquidGlassBackport/Previews/CustomViewsPreview.swift
```

Expected: exit 1 because the preview has not been implemented.

- [ ] **Step 2: Create the custom views preview**

Create `Sources/LiquidGlassBackport/Previews/CustomViewsPreview.swift`:

```swift
#if DEBUG && os(iOS)
import SwiftUI

@available(iOS 17.0, *)
private struct CustomViewsPreview: View {
    @State private var isExpanded = true
    @Namespace private var namespace

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Backported.GlassEffectContainer(spacing: 20) {
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        badge(
                            "sun.max.fill",
                            id: "sun",
                            tint: .orange
                        )

                        if isExpanded {
                            badge(
                                "cloud.rain.fill",
                                id: "rain",
                                tint: .blue
                            )
                            badge(
                                "wind",
                                id: "wind",
                                tint: .mint
                            )
                        }
                    }

                    Button {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            isExpanded.toggle()
                        }
                    } label: {
                        Label(
                            isExpanded ? "Collapse" : "Expand",
                            systemImage: isExpanded
                                ? "rectangle.compress.vertical"
                                : "rectangle.expand.vertical"
                        )
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                    .backport.glassEffect(
                        .regular.tint(.purple).interactive(),
                        in: Capsule()
                    )
                    .backport.glassEffectID("toggle", in: namespace)
                    .backport.glassEffectTransition(.matchedGeometry)
                }
            }
        }
    }

    private func badge(
        _ systemImage: String,
        id: String,
        tint: Color
    ) -> some View {
        Image(systemName: systemImage)
            .font(.system(size: 30, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 72, height: 72)
            .backport.glassEffect(
                .regular.tint(tint),
                in: RoundedRectangle(cornerRadius: 20)
            )
            .backport.glassEffectID(id, in: namespace)
            .backport.glassEffectTransition(.matchedGeometry)
    }
}

#Preview("Custom views") {
    if #available(iOS 17.0, *) {
        CustomViewsPreview()
    } else {
        Text("Requires iOS 17 or later")
    }
}
#endif
```

- [ ] **Step 3: Compile the iOS Debug target**

Run:

```bash
xcodebuild build -quiet \
  -scheme swiftui-liquid-glass-backport \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/lg-backport-custom-preview \
  CODE_SIGNING_ALLOWED=NO
```

Expected: exit 0 with no Swift compiler diagnostics from `CustomViewsPreview.swift`.

- [ ] **Step 4: Commit the custom views preview**

```bash
git add Sources/LiquidGlassBackport/Previews/CustomViewsPreview.swift
git commit -m "docs: add custom Liquid Glass preview"
```

---

### Task 3: Search API Preview

**Files:**
- Create: `Sources/LiquidGlassBackport/Previews/SearchAPIPreview.swift`

**Interfaces:**
- Consumes: `View.backport.searchToolbarBehavior(_:)`, `Backported.ToolbarSpacer`, `Backported.SpacerSizing`, `Backported.DefaultToolbarItem`, and `Backported.ToolbarDefaultItemKind.search`
- Produces: one private interactive iOS preview demonstrating minimized toolbar search, default search-item placement, toolbar spacing, and local result filtering

- [ ] **Step 1: Verify the preview is absent**

Run:

```bash
test -f Sources/LiquidGlassBackport/Previews/SearchAPIPreview.swift
```

Expected: exit 1 because the preview has not been implemented.

- [ ] **Step 2: Create the search API preview**

Create `Sources/LiquidGlassBackport/Previews/SearchAPIPreview.swift`:

```swift
#if DEBUG && os(iOS)
import SwiftUI

private struct PreviewMessage: Identifiable {
    let id: Int
    let sender: String
    let subject: String
    let systemImage: String
}

@available(iOS 17.5, *)
private struct SearchAPIPreview: View {
    @State private var query = ""

    private let messages = [
        PreviewMessage(
            id: 1,
            sender: "Apple Park",
            subject: "Welcome to Cupertino",
            systemImage: "building.2.fill"
        ),
        PreviewMessage(
            id: 2,
            sender: "Yosemite",
            subject: "Trail conditions",
            systemImage: "mountain.2.fill"
        ),
        PreviewMessage(
            id: 3,
            sender: "Ocean Beach",
            subject: "Sunset forecast",
            systemImage: "sun.horizon.fill"
        )
    ]

    private var filteredMessages: [PreviewMessage] {
        guard !query.isEmpty else {
            return messages
        }

        return messages.filter {
            $0.sender.localizedCaseInsensitiveContains(query)
                || $0.subject.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredMessages) { message in
                Label {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.sender)
                            .font(.headline)
                        Text(message.subject)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: message.systemImage)
                        .foregroundStyle(Color.accentColor)
                }
            }
            .navigationTitle("Inbox")
            .searchable(text: $query, prompt: "Search messages")
            .backport.searchToolbarBehavior(.minimize)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Filter", systemImage: "line.3.horizontal.decrease") {}
                }

                Backported.ToolbarSpacer(
                    .flexible,
                    placement: .bottomBar
                )

                Backported.DefaultToolbarItem(
                    kind: .search,
                    placement: .bottomBar
                )

                Backported.ToolbarSpacer(
                    .fixed,
                    placement: .bottomBar
                )

                ToolbarItem(placement: .bottomBar) {
                    Button("Compose", systemImage: "square.and.pencil") {}
                }
            }
        }
    }
}

#Preview("Search API") {
    if #available(iOS 17.5, *) {
        SearchAPIPreview()
    } else {
        Text("Requires iOS 17.5 or later")
    }
}
#endif
```

- [ ] **Step 3: Compile and run the package tests on iOS 26**

Run:

```bash
xcodebuild test -quiet \
  -scheme swiftui-liquid-glass-backport \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5' \
  -derivedDataPath /tmp/lg-backport-search-preview \
  CODE_SIGNING_ALLOWED=NO
```

Expected: exit 0; all 12 existing tests pass and all three preview files compile.

- [ ] **Step 4: Commit the search preview**

```bash
git add Sources/LiquidGlassBackport/Previews/SearchAPIPreview.swift
git commit -m "docs: add search API preview"
```

---

### Task 4: Final Verification

**Files:**
- Verify: `Sources/LiquidGlassBackport/Previews/ButtonStylesPreview.swift`
- Verify: `Sources/LiquidGlassBackport/Previews/CustomViewsPreview.swift`
- Verify: `Sources/LiquidGlassBackport/Previews/SearchAPIPreview.swift`
- Verify: `docs/specs/2026-07-19-liquid-glass-previews-design.md`

**Interfaces:**
- Consumes: the three completed preview files
- Produces: verified Debug-only examples with no public API or Release-build impact

- [ ] **Step 1: Verify exact file and guard coverage**

Run:

```bash
find Sources/LiquidGlassBackport/Previews -type f -name '*.swift' | sort
rg --files-without-match '^#if DEBUG && os\(iOS\)$' Sources/LiquidGlassBackport/Previews/*.swift
rg -n '^(public|package|internal) ' Sources/LiquidGlassBackport/Previews
```

Expected:

- exactly the three approved files are listed;
- the guard scan prints nothing because every file has the required guard;
- the visibility scan prints nothing because preview declarations are private.

- [ ] **Step 2: Run SwiftPM tests**

Run:

```bash
swift test
```

Expected: 12 tests pass with no failures.

- [ ] **Step 3: Verify the iOS Debug previews compile**

Run:

```bash
xcodebuild test -quiet \
  -scheme swiftui-liquid-glass-backport \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max,OS=26.5' \
  -derivedDataPath /tmp/lg-backport-previews-final \
  CODE_SIGNING_ALLOWED=NO
```

Expected: exit 0 and 12 tests pass.

- [ ] **Step 4: Verify Release exclusion and diff integrity**

Run:

```bash
xcodebuild build -quiet \
  -configuration Release \
  -scheme swiftui-liquid-glass-backport \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/lg-backport-previews-release \
  CODE_SIGNING_ALLOWED=NO
git diff --check
git status --short
```

Expected:

- the Release build exits 0 with preview code excluded by `#if DEBUG`;
- `git diff --check` exits 0;
- status contains only the implementation plan if it has not yet been committed.
