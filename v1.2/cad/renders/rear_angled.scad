// Official V1.2 README render - rear three-quarter view.
// Exact mirrored counterpart of front_angled.scad.

include <../config/project_config.scad>

$coupler_design_profile = "medium"; // Canonical V1.2 documentation profile.
use <../assemblies/display_assembly.scad>

$vpt = [0, 0, 0];
// Same elevation as front_angled.scad; azimuth is rotated 180 degrees for the rear.
$vpr = [85, 0, 220];
$vpd = 1050;

display_assembly(
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false
);
