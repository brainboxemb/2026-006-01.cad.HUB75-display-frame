// Official V1.1 exploded render - rear three-quarter view.
// Uses exactly the same camera as rear_angled.scad so the normal and exploded views compare directly.

include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>

exploded_render_distance = 40;

$vpt = [display_nominal_width/2, 0, display_nominal_height/2];
$vpr = [108, 0, 158];
$vpd = 1550;

display_assembly(
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false,
    explode_distance=exploded_render_distance
);
