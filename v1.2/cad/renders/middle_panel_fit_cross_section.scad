// V1.2 MEDIUM middle panel coupler transverse fit section.
include <../config/project_config.scad>
use <../assemblies/coupler_fit_cross_sections.scad>

$coupler_design_profile = "medium";

rotate([0,0,90])
    middle_panel_coupler_fit_cross_section();

// Rotate the Y/Z section plane into the normal documentation camera.
$vpt = [8, 0, 0];
$vpr = [90, 0, 180];
$vpd = 600;
