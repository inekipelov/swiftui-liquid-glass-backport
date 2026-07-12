#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
current_version=${1:-}

while IFS=$'\t' read -r target_sha candidate_label extra; do
    if [[ -z "$target_sha" && -z "$candidate_label" ]]; then
        continue
    fi

    if [[ -z "$target_sha" || -z "$candidate_label" || -n "${extra:-}" ]]; then
        printf 'Invalid release candidate record\n' >&2
        exit 1
    fi

    selected_label=$("$script_dir/version-label.sh" "$candidate_label")
    next_version=$("$script_dir/next-calver.sh" "$selected_label" "$current_version")

    if [[ -z "$next_version" ]]; then
        continue
    fi

    printf '%s\t%s\t%s\n' "$target_sha" "$selected_label" "$next_version"
    current_version=$next_version
done
