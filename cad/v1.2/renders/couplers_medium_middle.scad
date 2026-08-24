// V1.2 MEDIUM middle panel coupler.
include <../config/project_config.scad>
use <../assemblies/couplers_assembly.scad>

$coupler_design_profile = "medium";
$vpt = [0, 0, 0];
$vpr = [90, 0, 180];
$vpd = 230;

project_middle_panel_coupler();
