// Official V1.1 README render - rear three-quarter view.
// Exact mirrored counterpart of front_angled.scad.

include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>

$vpt = [display_nominal_width/2, 0, display_nominal_height/2];
// Mirror front [72, 0, 22] to the rear: X -> 180-X, Z -> 180-Z.
$vpr = [108, 0, 158];
$vpd = 1450;

display_assembly(
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false
);
