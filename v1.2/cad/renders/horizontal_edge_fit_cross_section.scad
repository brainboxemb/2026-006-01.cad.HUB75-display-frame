// V1.2 MEDIUM horizontal edge panel coupler transverse fit section.
include <../config/project_config.scad>
use <../assemblies/coupler_fit_cross_sections.scad>

$coupler_design_profile = "medium";

rotate([0,0,90])
    horizontal_edge_panel_coupler_fit_cross_section(direction="top");

// Rotate the Y/Z section plane into the normal documentation camera.
$vpt = [8, 0, 18];
$vpr = [90, 0, 180];
$vpd = 600;
