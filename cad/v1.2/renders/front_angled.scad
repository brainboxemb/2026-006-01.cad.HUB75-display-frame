// Official V1.1 README render - front three-quarter view.
// A small angle makes frame depth, panel thickness and tube clamps easier to read.

include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>

$vpt = [display_nominal_width/2, 0, display_nominal_height/2];
$vpr = [85, 0, 40];
$vpd = 1050;

display_assembly(
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false
);
