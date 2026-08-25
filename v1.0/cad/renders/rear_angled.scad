// Official V1.0 README render - rear three-quarter view.
// Mirrored counterpart of front_angled.scad.
include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>
$vpt = [horizontal_extrusion_length/2, 0, frame_height/2];
$vpr = [108, 0, 158];
$vpd = 1550;
display_assembly();
