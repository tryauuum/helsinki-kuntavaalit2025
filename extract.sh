#!/bin/bash

set -o errexit
set -o nounset

cat candidates.json | jq -c '.[]' | while read -r CANDIDATE; do
    FIRST_NAME=$( echo "$CANDIDATE" | jq -r '.first_name' )
    LAST_NAME=$( echo "$CANDIDATE" | jq -r '.last_name' )

    FILENAME="${FIRST_NAME}_${LAST_NAME}.json"
    FILENAME="$( echo "$FILENAME" | tr ' ' '_' )"

    echo "$CANDIDATE" | jq '.' > "$FILENAME"
done
