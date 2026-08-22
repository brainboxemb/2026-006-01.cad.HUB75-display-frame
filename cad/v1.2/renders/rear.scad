// Official V1.2 README render - rear view.
// Camera values are deliberately stored in CAD so CI and local renders match.

include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>

$vpt = [display_nominal_width/2, 0, display_nominal_height/2];
$vpr = [90, 0, 180];
$vpd = 1200;

display_assembly(
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false
);
