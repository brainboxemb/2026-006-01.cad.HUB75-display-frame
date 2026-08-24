// Official V1.2 exploded render - rear three-quarter view.
// Uses exactly the same camera as rear_angled.scad so the normal and exploded views compare directly.

include <../config/project_config.scad>

$coupler_design_profile = "medium"; // Canonical V1.2 documentation profile.
use <../assemblies/display_assembly.scad>

exploded_render_distance = 40;

$vpt = [0, 0, 0];
$vpr = [265, 0, 320];
$vpd = 1050;

display_assembly(
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false,
    explode_distance=exploded_render_distance
);
