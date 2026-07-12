# Contribution And Release Automation Design

## Objective

Define a contribution policy and automate package releases from pull requests
merged into `main`. The repository uses Apple-platform-aligned calendar
versioning, publishes every release-bearing version as both an annotated Git
tag and a GitHub Release, and performs no release action for explicitly exempt
pull requests.

## Branch Model

The repository uses trunk-based development. Contributors submit pull
requests directly to `main`; there is no `develop` release branch.

Release automation runs only after a pull request is merged into `main`.
Closing a pull request without merging never creates a version, tag, or
release.

## Version Labels

Every pull request must have exactly one of these labels:

- `version:major`
- `version:minor`
- `version:patch`
- `version:none`

A dedicated required check rejects pull requests with no version label or
with more than one version label. The release workflow repeats this validation
after merge as a defense-in-depth check.

## Calendar Versioning

Published versions use this format:

```text
<apple-platform-generation>.<feature-release>.<patch-release>
```

The labels have the following meaning:

- `version:major` advances to the next Apple platform generation and resets
  the other components to zero.
- `version:minor` publishes new backport API or other backwards-compatible
  functionality in the current generation and resets the patch component.
- `version:patch` publishes fixes to implementation, fallbacks,
  compatibility, tests, or release packaging.
- `version:none` publishes no tag or GitHub Release. It is appropriate for
  documentation, CI, repository maintenance, and other non-release changes.

The first release is configured as `26.0.0`. This is a bootstrap value only;
the contribution policy describes the first component generically as the
Apple platform generation.

Breaking changes are not published within a platform generation. Public API
must first be deprecated, remain available where practical, and only be
removed as part of a later platform-generation release.

## Release Workflow

The release workflow listens for merged pull requests targeting `main` and
uses the merged commit SHA as the exact release target.

For `version:major`, `version:minor`, and `version:patch`, the workflow:

1. Serializes releases through a single non-cancelling concurrency group.
2. Fetches all repository tags after entering the concurrency group.
3. Finds the latest valid calendar-version tag.
4. Uses `26.0.0` when no release tag exists; otherwise calculates the next
   version from the pull request label.
5. Fails if the calculated tag already exists.
6. Creates and pushes an annotated Git tag on the pull request merge commit.
7. Publishes a GitHub Release from that tag with generated release notes.

For `version:none`, the workflow performs validation and exits without write
operations.

Canonical release tags contain only the numeric version, for example
`26.0.0`, without a `v` prefix. This keeps Git tags, GitHub Releases, and Swift
Package Manager versions identical.

## Security And Permissions

The workflows use `pull_request_target` only for metadata-driven operations
whose definitions come from the trusted default branch. They never execute or
source code from an unmerged pull request.

The label check receives read-only pull request metadata. The release job has
only the permissions required to read pull request metadata and write tags and
GitHub Releases. Untrusted event values are passed through environment
variables instead of being interpolated directly into shell source.

The release workflow verifies that the merge commit belongs to `main` before
creating a tag. A single concurrency group prevents two merged pull requests
from calculating the same next version.

## Contribution Guide

Add a root `CONTRIBUTING.md` and link it from `README.md`. The guide documents:

- The pull-request-only contribution flow into `main`.
- The required version labels and calendar-version semantics.
- Conventional commit and `.gitlint` requirements.
- Preservation of existing backport APIs and the deprecation policy.
- Native forwarding on supported systems and proportionate fallbacks on
  older systems.
- Swift Testing requirements for public API and behavior changes.
- README and roadmap updates for new public API.
- Automatic release behavior after merge.

## Files

Implementation will add or update:

- `.github/workflows/version-label.yml`
- `.github/workflows/release.yml`
- `CONTRIBUTING.md`
- `README.md`
- `ROADMAP.md`

Version calculation and label validation should remain dependency-free and
testable. Small repository scripts may be introduced if keeping the logic
inside workflow YAML would make it difficult to verify independently.

## Verification

Verification must cover:

- Zero, one, and multiple version-label cases.
- `version:none` producing no version output.
- Bootstrap calculation producing `26.0.0` when no prior tag exists.
- Major, minor, and patch calculations from an existing version.
- Rejection of malformed and duplicate tags.
- YAML syntax and workflow expression validation.
- A dry-run mode that reports the selected label, merge SHA, and calculated
  version without creating a tag or GitHub Release.

The first pull request that introduces release automation uses
`version:none`. Live write-path validation is performed with a controlled
release-bearing pull request after the workflow is present on `main`.
