# Contributing

Contributions to LiquidGlassBackport are made through pull requests targeting
`main`. The repository uses Apple-platform-aligned calendar versioning and
publishes releases automatically after merge.

## Development workflow

1. Create a branch from the latest `main`.
2. Keep the change focused on one API, fix, or repository concern.
3. Add or update tests and documentation with the implementation.
4. Run the relevant verification commands locally.
5. Open a pull request targeting `main` and apply exactly one version label.

Direct pushes to `main` are not part of the contribution workflow.

## Version labels

Every pull request must have exactly one of these labels:

- `version:major` advances to the next Apple platform generation and resets
  the feature and patch components to zero.
- `version:minor` adds new backport API or other backwards-compatible
  functionality and resets the patch component to zero.
- `version:patch` fixes implementation, fallback, compatibility, tests, or
  release packaging without adding public API.
- `version:none` publishes no version. Use it for documentation, CI,
  repository maintenance, and other changes that do not affect the package
  release.

The version format is:

```text
<apple-platform-generation>.<feature-release>.<patch-release>
```

This is calendar versioning aligned with Apple platform generations. The
first component does not represent a SemVer breaking-change counter.

Merged pull requests labeled `version:major`, `version:minor`, or
`version:patch` automatically receive an annotated Git tag and a GitHub
Release. Tags contain the numeric version without a `v` prefix. Pull requests
labeled `version:none` create neither a tag nor a release.

## Backport API policy

Public API should mirror Apple's native API as closely as practical:

- Preserve Apple's names, parameter labels, defaults, and semantics.
- Do not add package-only parameters to an Apple API surface.
- Place APIs in the existing `backport` namespace or package-owned
  `Backported` types.
- Forward to native SwiftUI when the API is available.
- Provide the smallest behavior-preserving fallback on older systems.
- Document behavior that public APIs on older systems cannot reproduce.
- Keep implementation helpers internal or private.

Existing backport APIs remain available for as long as practical. Breaking
changes are not published within a platform generation. Deprecate public API
before removal, and reserve removals for a later platform-generation release.

## Tests

Tests use Swift Testing. New public API requires compile-smoke coverage, and
behavioral fallback changes require targeted assertions where the behavior is
observable without relying on private framework details.

Run the package tests:

```bash
swift test
```

Changes to release automation must also run:

```bash
bash scripts/test-release-scripts.sh
```

The pull request must pass the repository's GitHub Actions matrix before
merge. The required `Test matrix` check aggregates the platform jobs, while
the required `Version label` check validates the release category.

## Commits

Commit messages follow the conventional format enforced by `.gitlint`:

```text
<type>(optional-scope): concise description
```

Supported types are `feat`, `fix`, `docs`, `style`, `refactor`, `test`,
`chore`, `build`, `ci`, `perf`, and `revert`. Keep titles within 72 characters,
body lines within 100 characters, and do not use `wip` in the title.

## Documentation

When a pull request adds or changes public API:

- Update `README.md` with a focused usage example.
- Update `ROADMAP.md` to reflect completed and planned work.
- Link the relevant Apple documentation in design or implementation notes.
- Describe availability and fallback limitations.

## Release automation

Release automation runs only after a pull request is merged into `main`. It
serializes publication, reconciles every unreleased pull request in `main`
history order, tags each release-bearing merge commit, and generates GitHub
release notes. This reconciliation preserves pending releases when GitHub
replaces an older queued workflow run.

Manual workflow dispatch is dry-run only. It reports pending labels, target
commits, and calculated versions without creating a tag or GitHub Release.
