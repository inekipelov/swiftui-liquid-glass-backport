#!/usr/bin/env bash

set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
failures=0

assert_output() {
    local expected=$1
    shift

    local actual
    if ! actual=$("$@" 2>&1); then
        printf 'Expected success from %s, got:\n%s\n' "$*" "$actual" >&2
        failures=$((failures + 1))
        return
    fi

    if [[ "$actual" != "$expected" ]]; then
        printf 'Expected %q, got %q from %s\n' "$expected" "$actual" "$*" >&2
        failures=$((failures + 1))
    fi
}

assert_failure() {
    if "$@" >/dev/null 2>&1; then
        printf 'Expected failure from %s\n' "$*" >&2
        failures=$((failures + 1))
    fi
}

label_script="$root_dir/scripts/version-label.sh"
next_script="$root_dir/scripts/next-calver.sh"
latest_script="$root_dir/scripts/latest-calver.sh"

assert_failure "$label_script"
assert_failure "$label_script" version:major version:minor
assert_failure "$label_script" version:patch version:patch
assert_output version:major "$label_script" bug version:major documentation
assert_output version:minor "$label_script" version:minor
assert_output version:patch "$label_script" version:patch
assert_output version:none "$label_script" version:none

assert_output 26.0.0 "$next_script" version:major
assert_output 26.0.0 "$next_script" version:minor
assert_output 26.0.0 "$next_script" version:patch
assert_output '' "$next_script" version:none
assert_output 27.0.0 "$next_script" version:major 26.4.3
assert_output 26.5.0 "$next_script" version:minor 26.4.3
assert_output 26.4.4 "$next_script" version:patch 26.4.3
assert_output '' "$next_script" version:none 26.4.3
assert_failure "$next_script" version:unknown 26.4.3
assert_failure "$next_script" version:patch 26.4

assert_output '' "$latest_script"
assert_output 26.10.2 "$latest_script" notes 26.2.9 26.10.2
assert_output 27.0.0 "$latest_script" 26.10.2 27.0.0 26.9.9
assert_failure "$latest_script" 26.0
assert_failure "$latest_script" 26.0.0 26.0.0

if ((failures > 0)); then
    printf 'Release script tests failed: %d\n' "$failures" >&2
    exit 1
fi

printf 'Release script tests passed\n'
