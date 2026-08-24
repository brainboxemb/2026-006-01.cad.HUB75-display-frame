// HUB75 Display Frame - V1.2
// STL export entry point: complete display assembly.
//
// The complete display is intentionally exported only in the canonical
// MEDIUM coupler profile. Individual printable couplers are exported for
// SMALL, MEDIUM and LARGE through their profile-specific entry points.

include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>

$coupler_design_profile = "medium";

display_assembly(
    panels_visible=true,
    couplers_visible=true,
    stiffening_tubes_visible=true,
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false,
    explode_distance=0
);
