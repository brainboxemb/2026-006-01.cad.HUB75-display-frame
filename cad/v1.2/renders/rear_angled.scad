// Official V1.2 README render - rear three-quarter view.
// Exact mirrored counterpart of front_angled.scad.

include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>

$vpt = [0, 0, 0];
// Mirror front [72, 0, 22] to the rear: X -> 180-X, Z -> 180-Z.
$vpr = [265, 0, 320];
$vpd = 1050;

display_assembly(
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false
);
