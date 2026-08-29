// V1.2 MEDIUM horizontal edge panel coupler true XY fit cross-section.
// Slice is taken just inboard of the horizontal edge arm, through the seam locator.
include <../config/project_config.scad>
use <../assemblies/coupler_fit_cross_sections.scad>

$coupler_design_profile = "medium";

horizontal_edge_panel_coupler_fit_cross_section(direction="top");

// Look perpendicular to the XY section (along Z).
$vpt = [0, -7, -13];
$vpr = [0, 0, 0];
$vpd = 185;
