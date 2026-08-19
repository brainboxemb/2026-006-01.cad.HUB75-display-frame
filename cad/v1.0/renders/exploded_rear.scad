// Official V1.0 exploded render - straight rear view.
include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>
exploded_render_distance = 45;
$vpt = [horizontal_extrusion_length/2, 0, frame_height/2];
$vpr = [90, 0, 180];
$vpd = 1650;
display_assembly(explode_distance=exploded_render_distance);
