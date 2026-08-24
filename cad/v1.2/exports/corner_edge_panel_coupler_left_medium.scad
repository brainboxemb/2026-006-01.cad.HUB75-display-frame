// STL export entry - V1.2 MEDIUM left corner edge panel coupler.
include <../config/project_config.scad>
use <../components/hub75_panel.scad>
use <../assemblies/couplers_assembly.scad>

$coupler_design_profile = "medium";
project_corner_edge_panel_coupler(side="left", direction="top", screw_row_z=panel_hole_z_top());
