#!/usr/bin/env bash

set -euo pipefail

matches=()

for label in "$@"; do
    case "$label" in
        version:major|version:minor|version:patch|version:none)
            matches+=("$label")
            ;;
    esac
done

if ((${#matches[@]} != 1)); then
    printf 'Expected exactly one version label, found %d\n' "${#matches[@]}" >&2
    exit 1
fi

printf '%s\n' "${matches[0]}"
