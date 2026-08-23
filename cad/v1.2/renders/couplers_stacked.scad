// V1.2 diagnostic coupler width comparison - stacked.
// One real mounting screw of every part is aligned on X = 0.
// The standard 10 mm / half-step reference grid is enabled for fixed renders.
include <../config/project_config.scad>
use <../assemblies/coupler_comparison_assembly.scad>

$vpt = [0, 0, 0];
$vpr = [90, 0, 180];
$vpd = 1600;

coupler_comparison_stacked(
    show_grid=true,
    grid_major=10,
    grid_half_step=true
);
