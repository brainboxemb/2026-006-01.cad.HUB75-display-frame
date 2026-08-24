// V1.2 LARGE left corner edge panel coupler.
include <../config/project_config.scad>
use <../components/hub75_panel.scad>
use <../assemblies/couplers_assembly.scad>

$coupler_design_profile = "large";
$vpt = [0, 0, 0];
$vpr = [90, 0, 180];
$vpd = 270;

project_corner_edge_panel_coupler(side="left", direction="top", screw_row_z=panel_hole_z_top());
