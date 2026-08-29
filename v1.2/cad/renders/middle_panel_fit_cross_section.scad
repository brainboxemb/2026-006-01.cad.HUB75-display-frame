// V1.2 MEDIUM middle panel coupler true XY fit cross-section.
// Slice is taken just below the horizontal PLUS arm, through the seam locator.
include <../config/project_config.scad>
use <../assemblies/coupler_fit_cross_sections.scad>

$coupler_design_profile = "medium";

middle_panel_coupler_fit_cross_section();

// Look perpendicular to the XY section (along Z).
$vpt = [0, -7, -16];
$vpr = [0, 0, 0];
$vpd = 185;
