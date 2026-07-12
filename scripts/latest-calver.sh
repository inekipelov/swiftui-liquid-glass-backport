#!/usr/bin/env bash

set -euo pipefail

version_pattern='^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
valid_tags=()
latest=''
latest_generation=0
latest_feature=0
latest_patch=0

for tag in "$@"; do
    if [[ ! "$tag" =~ $version_pattern ]]; then
        if [[ "$tag" =~ ^[0-9] ]]; then
            printf 'Malformed numeric tag: %s\n' "$tag" >&2
            exit 1
        fi
        continue
    fi

    if ((${#valid_tags[@]} > 0)); then
        for existing in "${valid_tags[@]}"; do
            if [[ "$existing" == "$tag" ]]; then
                printf 'Duplicate release tag: %s\n' "$tag" >&2
                exit 1
            fi
        done
    fi
    valid_tags+=("$tag")

    generation=${BASH_REMATCH[1]}
    feature=${BASH_REMATCH[2]}
    patch=${BASH_REMATCH[3]}

    if [[ -z "$latest" ]] \
        || ((generation > latest_generation)) \
        || ((generation == latest_generation && feature > latest_feature)) \
        || ((generation == latest_generation && feature == latest_feature && patch > latest_patch)); then
        latest=$tag
        latest_generation=$generation
        latest_feature=$feature
        latest_patch=$patch
    fi
done

if [[ -n "$latest" ]]; then
    printf '%s\n' "$latest"
fi
