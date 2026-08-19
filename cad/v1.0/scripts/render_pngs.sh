#!/usr/bin/env bash
set -euo pipefail

# Render the official V1.0 documentation images.
# Usage from repository root:
#   bash cad/v1.0/scripts/render_pngs.sh out/v1.0/png
# Camera definitions live in renders/*.scad.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_DIR="${1:-${PROJECT_DIR}/out/png}"
mkdir -p "${OUTPUT_DIR}"

OPENSCAD_BIN="${OPENSCAD_BIN:-openscad}"
OPENSCAD_RUN=("${OPENSCAD_BIN}")
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
render_png front_angled.scad hub75-display-frame-front-angled.png
render_png rear.scad hub75-display-frame-rear.png
render_png rear_angled.scad hub75-display-frame-rear-angled.png
render_png exploded_rear.scad hub75-display-frame-exploded-rear.png
render_png exploded_rear_angled.scad hub75-display-frame-exploded-rear-angled.png
