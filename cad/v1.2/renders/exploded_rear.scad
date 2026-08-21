// Official V1.1 exploded render - straight rear view.
// This view keeps all exploded offsets easy to compare against the normal rear view.

include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>

exploded_render_distance = 40;

$vpt = [display_nominal_width/2, 0, display_nominal_height/2];
$vpr = [90, 0, 180];
$vpd = 1200;

display_assembly(
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false,
    explode_distance=exploded_render_distance
);
