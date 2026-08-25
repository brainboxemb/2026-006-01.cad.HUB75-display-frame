// Official V1.1 exploded render.
// Rear three-quarter view shows depth layers, tile interlocks and tube clips.

include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>

exploded_render_distance = 40;

// A stable rear three-quarter camera for documentation.
$vpt = [display_nominal_width/2, 0, display_nominal_height/2];
$vpr = [68, 0, 145];
$vpd = 1500;

display_assembly(
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false,
    explode_distance=exploded_render_distance
);
