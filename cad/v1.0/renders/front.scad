// Official V1.0 README render - front view.
include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>
$vpt = [horizontal_extrusion_length/2, 0, frame_height/2];
$vpr = [90, 0, 0];
$vpd = 1500;
display_assembly();
