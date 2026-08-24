// V1.2 diagnostic coupler proportion comparison - side by side.
// All engraved geometric reference crosses are aligned at Z = 0.
// The standard 10 mm / half-step reference grid is enabled for fixed renders.
include <../config/project_config.scad>

$coupler_design_profile = "medium"; // Canonical V1.2 documentation profile.
use <../assemblies/coupler_comparison_assembly.scad>

$vpt = [0, 0, 0];
$vpr = [90, 0, 180];
$vpd = 720;

coupler_comparison_side_by_side(
    show_grid=true,
    grid_major=10,
    grid_half_step=true
);
