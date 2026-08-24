// V1.2 SMALL middle panel coupler.
include <../config/project_config.scad>
use <../assemblies/couplers_assembly.scad>

$coupler_design_profile = "small";
$vpt = [0, 0, 0];
$vpr = [90, 0, 180];
$vpd = 190;

project_middle_panel_coupler();
