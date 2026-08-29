// V1.2 MEDIUM horizontal edge panel coupler local rear fit section.
// Cropped just inboard of the red edge arm so the seam rib remains visible.
include <../config/project_config.scad>
use <../assemblies/coupler_fit_cross_sections.scad>

$coupler_design_profile = "medium";

horizontal_edge_panel_coupler_fit_cross_section(direction="top");

$vpt = [0, 9.5, -13];
$vpr = [90, 0, 180];
$vpd = 230;
