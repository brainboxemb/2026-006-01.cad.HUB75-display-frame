#!/usr/bin/env bash
set -euo pipefail

# Render the official V1.1 documentation images.
# Usage from repository root:
#   bash cad/v1.1/scripts/render_pngs.sh out/v1.1/png
#
# The camera definitions live in renders/*.scad, not in this script.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_DIR="${1:-${PROJECT_DIR}/out/png}"

mkdir -p "${OUTPUT_DIR}"

OPENSCAD_BIN="${OPENSCAD_BIN:-openscad}"
OPENSCAD_RUN=("${OPENSCAD_BIN}")

# Linux CI is headless. Use xvfb-run automatically when it is available.
if command -v xvfb-run >/dev/null 2>&1; then
    OPENSCAD_RUN=(xvfb-run -a "${OPENSCAD_BIN}")
fi

render_png() {
    local source="$1"
    local output="$2"

    echo "Rendering ${output}"
    "${OPENSCAD_RUN[@]}" \
        --preview \
        --projection=o \
        --imgsize=1600,900 \
        -o "${OUTPUT_DIR}/${output}" \
        "${PROJECT_DIR}/renders/${source}"
}

render_png front.scad hub75-display-frame-front.png
render_png rear.scad hub75-display-frame-rear.png
render_png exploded.scad hub75-display-frame-exploded.png
