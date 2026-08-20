#!/usr/bin/env bash
set -euo pipefail

# Render the standard documentation views for one OpenSCAD project.
#
# Usage from repository root:
#   bash scripts/render_openscad_pngs.sh cad/v1.0 out/v1.0/png
#   bash scripts/render_openscad_pngs.sh cad/v1.1 out/v1.1/png
#
# Camera definitions live in <project>/renders/*.scad.

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <project-dir> <output-dir>"
    echo "Example: $0 cad/v1.1 out/v1.1/png"
    exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if git -C "${SCRIPT_DIR}" rev-parse --show-toplevel >/dev/null 2>&1; then
    REPO_ROOT="$(git -C "${SCRIPT_DIR}" rev-parse --show-toplevel)"
else
    REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
fi

PROJECT_ARG="$1"
OUTPUT_ARG="$2"

if [[ "${PROJECT_ARG}" = /* ]]; then
    PROJECT_DIR="${PROJECT_ARG}"
else
    PROJECT_DIR="${REPO_ROOT}/${PROJECT_ARG}"
fi

if [[ "${OUTPUT_ARG}" = /* ]]; then
    OUTPUT_DIR="${OUTPUT_ARG}"
else
    OUTPUT_DIR="${REPO_ROOT}/${OUTPUT_ARG}"
fi

if [[ ! -d "${PROJECT_DIR}" ]]; then
    echo "ERROR: Project directory does not exist: ${PROJECT_DIR}"
    exit 1
fi

PROJECT_DIR="$(cd "${PROJECT_DIR}" && pwd)"
RENDERS_DIR="${PROJECT_DIR}/renders"

if [[ ! -d "${RENDERS_DIR}" ]]; then
    echo "ERROR: Render directory does not exist: ${RENDERS_DIR}"
    exit 1
fi

# All current documentation views use the display assembly.
# Fail here with a useful message instead of letting OpenSCAD create blank PNGs.
if [[ ! -f "${PROJECT_DIR}/assemblies/display_assembly.scad" ]]; then
    echo "ERROR: Missing required assembly:"
    echo "  ${PROJECT_DIR}/assemblies/display_assembly.scad"
    exit 1
fi

mkdir -p "${OUTPUT_DIR}"

OPENSCAD_BIN="${OPENSCAD_BIN:-openscad}"
OPENSCAD_IMG_SIZE="${OPENSCAD_IMG_SIZE:-2560,1440}"
OPENSCAD_RUN=("${OPENSCAD_BIN}")

if [[ ! "${OPENSCAD_IMG_SIZE}" =~ ^[0-9]+,[0-9]+$ ]]; then
    echo "ERROR: OPENSCAD_IMG_SIZE must use WIDTH,HEIGHT format, e.g. 2560,1440."
    exit 2
fi

if command -v xvfb-run >/dev/null 2>&1; then
    OPENSCAD_RUN=(xvfb-run -a "${OPENSCAD_BIN}")
fi

render_png() {
    local source="$1"
    local output="$2"
    local source_path="${RENDERS_DIR}/${source}"
    local output_path="${OUTPUT_DIR}/${output}"
    local render_log

    if [[ ! -f "${source_path}" ]]; then
        echo "ERROR: Missing render definition: ${source_path}"
        return 1
    fi

    render_log="$(mktemp)"
    trap 'rm -f "${render_log}"' RETURN

    echo
    echo "Rendering ${source_path}"
    echo "       -> ${output_path}"
    echo "       size: ${OPENSCAD_IMG_SIZE}"

    # OpenSCAD's include/use path behaviour is most predictable when the
    # working directory is the directory containing the render entry point.
    set +e
    (
        cd "${RENDERS_DIR}"
        "${OPENSCAD_RUN[@]}" \
            --preview \
            --projection=o \
            --imgsize="${OPENSCAD_IMG_SIZE}" \
            -o "${output_path}" \
            "./${source}"
    ) >"${render_log}" 2>&1
    local status=$?
    set -e

    cat "${render_log}"

    if [[ ${status} -ne 0 ]]; then
        echo "ERROR: OpenSCAD exited with status ${status}."
        return "${status}"
    fi

    # OpenSCAD 2021.01 can return success even when a library/module is
    # missing. Treat those diagnostics as build failures.
    if grep -Eq \
        "WARNING: Can't open library|WARNING: Ignoring unknown module|Parser error|ERROR:" \
        "${render_log}"; then
        echo
        echo "ERROR: OpenSCAD reported a missing dependency or invalid model."
        echo "The generated image will not be accepted."
        rm -f "${output_path}"
        return 1
    fi

    if [[ ! -s "${output_path}" ]]; then
        echo "ERROR: OpenSCAD did not create a non-empty PNG: ${output_path}"
        return 1
    fi
}

render_png front.scad                  hub75-display-frame-front.png
render_png front_angled.scad           hub75-display-frame-front-angled.png
render_png rear.scad                   hub75-display-frame-rear.png
render_png rear_angled.scad            hub75-display-frame-rear-angled.png
render_png exploded_rear.scad          hub75-display-frame-exploded-rear.png
render_png exploded_rear_angled.scad   hub75-display-frame-exploded-rear-angled.png
