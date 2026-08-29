// V1.2 MEDIUM middle panel coupler local rear fit section.
// Cropped below the horizontal PLUS arm to expose the seam rib in the stem.
include <../config/project_config.scad>
use <../assemblies/coupler_fit_cross_sections.scad>

$coupler_design_profile = "medium";

middle_panel_coupler_fit_cross_section();

$vpt = [0, 9.5, -16];
$vpr = [90, 0, 180];
$vpd = 230;
