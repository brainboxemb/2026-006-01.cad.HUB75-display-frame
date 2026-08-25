// Official V1.0 exploded render - rear three-quarter view.
// Uses the same camera angle as rear_angled.scad.
include <../config/project_config.scad>
use <../assemblies/display_assembly.scad>
exploded_render_distance = 45;
$vpt = [horizontal_extrusion_length/2, 0, frame_height/2];
$vpr = [108, 0, 158];
$vpd = 1650;
display_assembly(explode_distance=exploded_render_distance);
