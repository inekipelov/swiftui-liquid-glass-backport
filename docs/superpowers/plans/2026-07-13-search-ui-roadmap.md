# iOS 26 Search UI Roadmap Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Document the iOS 26 SwiftUI Search UI backport scope and remove the requested transition-value row from the README API table.

**Architecture:** This is a documentation-only change. `ROADMAP.md` will group the new search-specific configuration types, modifiers, toolbar content, and tab role in a dedicated section while removing duplicate entries from the broader toolbar/tab section; `README.md` will retain the transition modifier but omit the package-owned transition values row.

**Tech Stack:** Markdown, Git, ripgrep

## Global Constraints

- Scope only APIs introduced with iOS 26; do not plan a general `Tab` or `TabView` backport.
- Keep `Backported.TabRole.search` and a `SwiftUI.Tab` initializer overload that accepts it; the overload is available only where `SwiftUI.Tab` exists.
- Do not add `Backported.Tab` or `Backported.TabView`.
- Do not change source code or tests in this task.
- Preserve all unrelated README and roadmap content.

---

### Task 1: Update the public documentation roadmap

**Files:**
- Modify: `README.md:41`
- Modify: `ROADMAP.md:43-65`

**Interfaces:**
- Consumes: the approved API inventory in `docs/superpowers/specs/2026-07-13-search-ui-roadmap-design.md`
- Produces: a dedicated `## Search UI` roadmap section naming every approved type, value, initializer, modifier, fallback, and verification requirement

- [ ] **Step 1: Remove the transition-value table row from README**

Delete exactly this row and leave `View.backport.glassEffectTransition(_:)` documented:

```markdown
| `Backported.GlassEffectTransition.identity`, `.matchedGeometry`, `.materialize` | Package-owned transition configuration |
```

- [ ] **Step 2: Add the Search UI roadmap section**

Insert the following section after `## Glass Button Styles`:

```markdown
## Search UI

- [ ] Add `Backported.SearchToolbarBehavior.automatic` and `.minimize`.
- [ ] Implement `View.backport.searchToolbarBehavior(_:)` with a no-op fallback.
- [ ] Add `Backported.SearchPresentationToolbarBehavior.automatic` and `.avoidHidingContent`.
- [ ] Implement `View.backport.searchPresentationToolbarBehavior(_:)` with a no-op fallback.
- [ ] Add `Backported.SpacerSizing.fixed` and `.flexible`.
- [ ] Implement `Backported.ToolbarSpacer(_:placement:)` with a neutral older-system fallback.
- [ ] Add `Backported.ToolbarDefaultItemKind.search`.
- [ ] Implement `Backported.DefaultToolbarItem(kind:placement:)` without emulating a custom search field on older systems.
- [ ] Add `Backported.TabRole.search`.
- [ ] Add a `SwiftUI.Tab` initializer overload that accepts `Backported.TabRole`.
- [ ] Forward the search tab role on iOS 26 and ignore it on iOS 18 through iOS 25.
- [ ] Add compile-smoke coverage for search configuration, toolbar content, and the search tab role.
- [ ] Add usage examples for toolbar search and search-tab placement.
```

- [ ] **Step 3: Remove duplicate toolbar/tab roadmap entries**

Remove these entries from `## Toolbar and Tab Navigation`, because the new Search UI section owns them:

```markdown
- [ ] Implement `Backported.ToolbarSpacer` with a native forwarding path.
- [ ] Provide a neutral `Spacer` fallback for `ToolbarSpacer`.
- [ ] Implement `Backported.DefaultToolbarItem`.
- [ ] Add `Backported.ToolbarDefaultItemKind.search`.
- [ ] Add `Backported.TabRole.search`.
```

Keep `ToolbarDefaultItemKind.sidebarToggle`, `ToolbarDefaultItemKind.title`,
`View.backport.toolbar(removing:)`, and `Backported.TabRole.automatic` in the
general toolbar/tab section because they are not search-only iOS 26 additions.

- [ ] **Step 4: Verify exact documentation coverage**

Run:

```bash
rg -n "GlassEffectTransition.identity|SearchToolbarBehavior|SearchPresentationToolbarBehavior|SpacerSizing|ToolbarDefaultItemKind.search|TabRole.search|Backported.TabView|Backported.Tab\\b" README.md ROADMAP.md
```

Expected:

- no `GlassEffectTransition.identity` match in `README.md`;
- approved Search UI symbols appear in `ROADMAP.md`;
- no `Backported.Tab` or `Backported.TabView` roadmap commitment.

- [ ] **Step 5: Verify Markdown diff integrity**

Run:

```bash
git diff --check
git diff -- README.md ROADMAP.md
```

Expected: `git diff --check` exits 0 and the diff contains only the requested README row deletion plus the Search UI roadmap reorganization.

- [ ] **Step 6: Commit the documentation changes**

```bash
git add README.md ROADMAP.md docs/superpowers/plans/2026-07-13-search-ui-roadmap.md
git commit -m "docs: expand iOS 26 search UI roadmap"
```

