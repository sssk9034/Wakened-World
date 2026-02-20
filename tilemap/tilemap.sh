#!/usr/bin/env bash

set -e

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 image1.png image2.png ..."
    exit 1
fi

# Output file
OUTPUT="tilemap.png"

# Number of input images
COUNT=$#

# Calculate grid size (near-square layout)
COLS=$(printf "%.0f" "$(echo "sqrt($COUNT)" | bc -l)")
ROWS=$(( (COUNT + COLS - 1) / COLS ))

# Create tilemap
montage "$@" \
    -tile ${COLS}x${ROWS} \
    -geometry +0+0 \
    -background none \
    "$OUTPUT"

echo "Created $OUTPUT (${COLS}x${ROWS} grid)"
