# Contribution And Release Automation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Validate one release label on every pull request and automatically publish Apple-platform-aligned CalVer tags and GitHub Releases after merges into `main`.

**Architecture:** Keep label selection and CalVer calculation in dependency-free Bash scripts with executable regression tests. GitHub Actions call those scripts from trusted default-branch code, serialize release writes, tag the exact merge commit, and generate GitHub release notes. Repository-facing contribution rules live in a root `CONTRIBUTING.md` linked from the README.

**Tech Stack:** Bash 3.2+, Git, GitHub Actions, GitHub CLI, Markdown, Swift Package Manager.

## Global Constraints

- The repository uses pull requests into `main`; there is no `develop` branch.
- Every pull request has exactly one of `version:major`, `version:minor`, `version:patch`, or `version:none`.
- Published versions use `<apple-platform-generation>.<feature-release>.<patch-release>`.
- The bootstrap release is `26.0.0`; contribution rules must describe the generation generically.
- Every major, minor, and patch version receives an annotated tag and a GitHub Release.
- `version:none` performs no release write.
- Release tags have no `v` prefix.
- Release jobs are serialized and never cancel an in-progress release.
- Workflows never execute code from an unmerged pull request.
- Preserve the existing `.gitlint`, Swift Testing, and GitHub Actions conventions.

---

### Task 1: Release Metadata Scripts

**Files:**
- Create: `scripts/version-label.sh`
- Create: `scripts/next-calver.sh`
- Create: `scripts/latest-calver.sh`
- Create: `scripts/test-release-scripts.sh`

**Interfaces:**
- Produces: `scripts/version-label.sh [labels...]`, printing exactly one recognized label or exiting nonzero.
- Produces: `scripts/next-calver.sh <label> [current-version]`, printing the next version or no output for `version:none`.
- Produces: `scripts/latest-calver.sh [tags...]`, printing the highest valid release tag and rejecting malformed numeric tags.

- [ ] **Step 1: Add failing executable regression tests**

Cover zero and duplicate labels, all four valid labels, bootstrap `26.0.0`, major/minor/patch calculations, `version:none`, version ordering, malformed tags, and duplicate tags.

- [ ] **Step 2: Run the tests and verify they fail**

Run: `bash scripts/test-release-scripts.sh`

Expected: FAIL because the production scripts do not exist.

- [ ] **Step 3: Implement the scripts**

Use `set -euo pipefail`, numeric component validation, deterministic output, and no network dependencies. `next-calver.sh` must calculate:

```text
version:major  26.4.3 -> 27.0.0
version:minor  26.4.3 -> 26.5.0
version:patch  26.4.3 -> 26.4.4
version:none   26.4.3 -> no output
no prior tag  any release label -> 26.0.0
```

- [ ] **Step 4: Run the regression tests**

Run: `bash scripts/test-release-scripts.sh`

Expected: `Release script tests passed` and exit code 0.

- [ ] **Step 5: Commit**

```bash
git add scripts
git commit -m "feat(release): add CalVer calculation scripts"
```

### Task 2: Pull Request Version Label Check

**Files:**
- Create: `.github/workflows/version-label.yml`
- Test: `scripts/test-release-scripts.sh`

**Interfaces:**
- Consumes: `scripts/version-label.sh`.
- Produces: required check name `Version label` for pull requests targeting `main`.

- [ ] **Step 1: Add the workflow**

Trigger on `pull_request_target` activity that can alter PR contents or labels. Use only `contents: read` and `pull-requests: read`. Checkout the trusted default branch and pass `toJSON(github.event.pull_request.labels.*.name)` through an environment variable.

- [ ] **Step 2: Validate workflow syntax and label behavior**

Run:

```bash
ruby -e 'require "yaml"; YAML.load_file(".github/workflows/version-label.yml")'
bash scripts/test-release-scripts.sh
```

Expected: both commands exit 0.

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/version-label.yml
git commit -m "ci(release): require one version label"
```

### Task 3: Automatic Release Workflow

**Files:**
- Create: `.github/workflows/release.yml`
- Modify: `scripts/test-release-scripts.sh`

**Interfaces:**
- Consumes: all three release scripts.
- Produces: annotated numeric tag and GitHub Release for merged release-bearing PRs.
- Produces: manual dry-run inputs `version_label`, `current_version`, and `target_sha`.

- [ ] **Step 1: Add dry-run regression cases**

Verify the script outputs required by a manual workflow run: selected label, optional current version, calculated version, and an empty calculated version for `version:none`.

- [ ] **Step 2: Add `.github/workflows/release.yml`**

The workflow must:

- Trigger on merged PRs to `main` and manual dispatch.
- Use `concurrency.group: release-main` and `cancel-in-progress: false`.
- Checkout the exact merge SHA with complete tag history.
- Revalidate the version label.
- Verify the target SHA is contained in `origin/main`.
- Find the latest canonical tag after entering the concurrency group.
- Fail when a calculated tag already exists.
- Print a report before writes.
- Skip writes during manual dispatch and for `version:none`.
- Configure a tag identity, create an annotated tag, push it, and call `gh release create --verify-tag --generate-notes`.

- [ ] **Step 3: Validate workflow syntax and expressions**

Run:

```bash
ruby -e 'require "yaml"; YAML.load_file(".github/workflows/release.yml")'
bash scripts/test-release-scripts.sh
git diff --check
```

Expected: all commands exit 0.

- [ ] **Step 4: Commit**

```bash
git add .github/workflows/release.yml scripts/test-release-scripts.sh
git commit -m "ci(release): publish CalVer releases after merge"
```

### Task 4: Contribution Policy And Repository Documentation

**Files:**
- Create: `CONTRIBUTING.md`
- Modify: `README.md`
- Modify: `ROADMAP.md`

**Interfaces:**
- Produces: contributor-facing branch, label, testing, API compatibility, commit, and release rules.

- [ ] **Step 1: Add `CONTRIBUTING.md`**

Document:

- PR-only changes into `main`.
- Exactly one required version label.
- Generic Apple-platform-aligned CalVer semantics.
- Automatic tags and GitHub Releases.
- Conventional commit and `.gitlint` rules.
- Backport preservation, deprecation, native forwarding, and fallback requirements.
- Swift Testing and documentation requirements.

- [ ] **Step 2: Link the guide from README**

Add a `Contributing` section linking `CONTRIBUTING.md`. Update the installation example from the unreleased `0.1.0` line to the bootstrap-compatible `26.0.0` version.

- [ ] **Step 3: Update roadmap checkboxes**

Add contribution/release automation entries and mark completed implementation items only after their verification passes. Preserve all existing toolbar and tab-navigation goals.

- [ ] **Step 4: Validate documentation**

Run:

```bash
git diff --check
rg -n "version:(major|minor|patch|none)|apple-platform-generation|CONTRIBUTING" CONTRIBUTING.md README.md ROADMAP.md
```

Expected: all four labels, the generic CalVer format, and contribution link are present.

- [ ] **Step 5: Commit**

```bash
git add CONTRIBUTING.md README.md ROADMAP.md
git commit -m "docs: add contribution and release policy"
```

### Task 5: Final Verification

**Files:**
- Verify: `.github/workflows/version-label.yml`
- Verify: `.github/workflows/release.yml`
- Verify: `scripts/*.sh`
- Verify: `CONTRIBUTING.md`
- Verify: `README.md`
- Verify: `ROADMAP.md`

- [ ] **Step 1: Run release automation tests**

Run: `bash scripts/test-release-scripts.sh`

Expected: `Release script tests passed`.

- [ ] **Step 2: Parse all workflows**

Run:

```bash
for workflow in .github/workflows/*.yml; do
  ruby -e 'require "yaml"; YAML.load_file(ARGV.fetch(0))' "$workflow"
done
```

Expected: exit code 0.

- [ ] **Step 3: Run package tests**

Run: `swift test`

Expected: all Swift Testing tests pass.

- [ ] **Step 4: Inspect repository state**

Run:

```bash
git diff --check
git status --short
git log --oneline -5
```

Expected: no unintended or generated files; only planned commits are present.

- [ ] **Step 5: Record external configuration requirement**

Report that repository rules must require `Version label` and existing test checks before merge. The workflow introduction PR uses `version:none`; a later controlled PR validates the live write path.
