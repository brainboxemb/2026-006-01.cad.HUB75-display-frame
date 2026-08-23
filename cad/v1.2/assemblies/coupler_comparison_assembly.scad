// HUB75 display frame - V1.2 coupler comparison assembly V94
//
// This assembly is directly viewable: open this file in OpenSCAD and use the
// Customizer below.  When imported with `use`, the standalone invocation is
// ignored and only the modules/functions are made available.

include <../config/project_config.scad>
use <couplers_assembly.scad>
use <../components/hub75_panel.scad>
use <../components/_lib/reference_grid.scad>
use <../project_components/horizontal_edge_panel_coupler.scad>
use <../project_components/corner_edge_panel_coupler.scad>

/* [Coupler profile] */
coupler_design_profile = "default"; // [default,lightweight]
use_custom_coupler_dimensions = false;
coupler_custom_profile_size = 100;
coupler_custom_wall_thickness = 6;
coupler_custom_guide_height = 10;
coupler_custom_base_thickness = 4;

$coupler_design_profile = coupler_design_profile;
$coupler_use_custom_dimensions = use_custom_coupler_dimensions;
$coupler_custom_profile_size = coupler_custom_profile_size;
$coupler_custom_wall_thickness = coupler_custom_wall_thickness;
$coupler_custom_guide_height = coupler_custom_guide_height;
$coupler_custom_base_thickness = coupler_custom_base_thickness;


