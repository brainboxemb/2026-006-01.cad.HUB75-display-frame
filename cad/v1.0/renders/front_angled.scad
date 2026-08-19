// Official V1.0 README render - front three-quarter view.
include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>
$vpt = [horizontal_extrusion_length/2, 0, frame_height/2];
$vpr = [72, 0, 22];
$vpd = 1550;
display_assembly();
