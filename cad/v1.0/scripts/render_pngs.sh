#!/usr/bin/env bash
set -euo pipefail

# Render the official V1.0 documentation images.
# Usage from repository root:
#   bash cad/v1.0/scripts/render_pngs.sh out/v1.0/png
#
# Camera definitions live in renders/*.scad, not in this script.
# OpenSCAD is deliberately started from the renders directory so relative
# include/use paths behave consistently across local and CI OpenSCAD versions.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

OUTPUT_ARG="${1:-${PROJECT_DIR}/out/png}"
if [[ "${OUTPUT_ARG}" = /* ]]; then
    OUTPUT_DIR="${OUTPUT_ARG}"
else
    OUTPUT_DIR="$(pwd)/${OUTPUT_ARG}"
fi
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
    (
        cd "${PROJECT_DIR}/renders"
        "${OPENSCAD_RUN[@]}" \
            --preview \
            --projection=o \
            --imgsize=1600,900 \
            -o "${OUTPUT_DIR}/${output}" \
            "${source}"
    )
}

render_png front.scad hub75-display-frame-front.png
render_png front_angled.scad hub75-display-frame-front-angled.png
render_png rear.scad hub75-display-frame-rear.png
render_png rear_angled.scad hub75-display-frame-rear-angled.png
render_png exploded_rear.scad hub75-display-frame-exploded-rear.png
render_png exploded_rear_angled.scad hub75-display-frame-exploded-rear-angled.png
