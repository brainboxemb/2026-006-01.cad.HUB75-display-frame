// V1.2 MEDIUM coupler comparison - side by side.
include <../config/project_config.scad>
use <../assemblies/coupler_comparison_assembly.scad>

$coupler_design_profile = "medium";

$vpt = [0, 0, 0];
$vpr = [90, 0, 180];
$vpd = 640;

coupler_comparison_side_by_side(show_grid=true, grid_major=10, grid_half_step=true);
