#!/usr/bin/env bash

set -euo pipefail

initial_version=${INITIAL_VERSION:-26.0.0}
label=${1:-}
current_version=${2:-}
version_pattern='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'

case "$label" in
    version:none)
        exit 0
        ;;
    version:major|version:minor|version:patch)
        ;;
    *)
        printf 'Unsupported version label: %s\n' "$label" >&2
        exit 1
        ;;
esac

if [[ ! "$initial_version" =~ $version_pattern ]]; then
    printf 'Invalid initial version: %s\n' "$initial_version" >&2
    exit 1
fi

if [[ -z "$current_version" ]]; then
    printf '%s\n' "$initial_version"
    exit 0
fi

if [[ ! "$current_version" =~ $version_pattern ]]; then
    printf 'Invalid current version: %s\n' "$current_version" >&2
    exit 1
fi

generation=${BASH_REMATCH[1]}
feature=${BASH_REMATCH[2]}
patch=${BASH_REMATCH[3]}

case "$label" in
    version:major)
        printf '%d.0.0\n' "$((generation + 1))"
        ;;
    version:minor)
        printf '%d.%d.0\n' "$generation" "$((feature + 1))"
        ;;
    version:patch)
        printf '%d.%d.%d\n' "$generation" "$feature" "$((patch + 1))"
        ;;
esac
