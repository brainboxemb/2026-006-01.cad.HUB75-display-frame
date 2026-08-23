// HUB75 display frame - V1.2 project / assembly configuration
//
// IMPORTANT ARCHITECTURE RULE
// ---------------------------
// This file contains only choices that describe THIS display assembly or its
// presentation. Physical dimensions of a HUB75 panel, tube, clip or coupler
// belong to those components and are exposed through their public functions.

use <../components/hub75_panel.scad>
use <../components/tube_clip.scad>
use <../components/aluminium_tube.scad>

$fn = 48;

/* [Panel array] */
panel_count = 5;

// Data-chain order is defined from the REAR of the assembled display.
rear_chain_start_side = "left"; // [left,right]
first_panel_input_side = "top"; // [top,bottom]

// Assembly pitch defaults to the nominal panel width. This is an assembly
// choice rather than a physical property of the panel component.
panel_pitch = hub75_panel_nominal_width();

// Project coordinate system:
//   X = 0 : centre of the complete physical panel array
//   Y = 0 : rear mounting plane of the HUB75 panels
//   Z = 0 : centre of the HUB75 panels
// The reusable hub75_panel component keeps its own local front-face Y=0.
project_panel_rear_y = 0;

function panel_chain_number(global_index) =
    rear_chain_start_side == "left" ? panel_count - global_index : global_index + 1;

function panel_input_is_top(global_index) =
    let(chain_index = panel_chain_number(global_index) - 1)
        first_panel_input_side == "top" ? chain_index % 2 == 0 : chain_index % 2 == 1;

function panel_rotated(global_index) = !panel_input_is_top(global_index);

function display_nominal_width() = panel_count * panel_pitch;
function display_nominal_height() = hub75_panel_nominal_height();
function display_actual_width() = (panel_count - 1) * panel_pitch + hub75_panel_width();
function display_actual_height() = hub75_panel_height();

// The first panel's physical left edge is chosen so the complete physical
// panel array is centred exactly around X=0. The nominal pitch remains 160 mm.
function panel_x(index) = -display_actual_width()/2 + index * panel_pitch;
function panel_center_x(index) = panel_x(index) + hub75_panel_width()/2;
function panel_center_z() = 0;
function panel_front_y() = project_panel_rear_y - hub75_panel_mounting_plane_y();
function panel_drawing_z(global_drawing_z) = global_drawing_z - hub75_panel_height()/2;
function panel_hole_z_bottom() = panel_drawing_z(hub75_panel_hole_z_bottom());
function panel_hole_z_middle() = panel_drawing_z(hub75_panel_hole_z_middle());
function panel_hole_z_top() = panel_drawing_z(hub75_panel_hole_z_top());
function panel_hole_z_positions() = [panel_hole_z_bottom(), panel_hole_z_middle(), panel_hole_z_top()];
function seam_x(seam_index) = panel_x(seam_index) + panel_pitch;

/* [Project envelope and stiffening tubes] */
// These values describe how otherwise reusable components are combined in
// THIS display. They intentionally belong to project_config.scad because the
// project-specific couplers derive their tube-clip positions from them.
display_envelope_width = 840.0;
display_envelope_height = 360.0;
tube_center_spacing = 340.0;

// Distance from the HUB75 rear mounting plane (project Y=0) toward the front
// of the panel to the centre of the Ø10 tube. With the chosen project axis,
// this becomes Y=-7 mm. A Ø10 tube then leaves 2.0 mm to the rear plane and
// 2.5 mm to the panel front face.
tube_center_from_panel_rear = 7.0;

function display_envelope_x_min() = -display_envelope_width/2;
function display_envelope_x_max() =  display_envelope_width/2;
function display_envelope_z_min() = -display_envelope_height/2;
function display_envelope_z_max() =  display_envelope_height/2;

// Y depth lines of the visual project envelope use the panel front face and
// the Y=0 rear mounting plane as clear project references.
function display_envelope_y_min() = panel_front_y();
function display_envelope_y_max() = project_panel_rear_y;

function stiffening_tube_length() = display_envelope_width;
function stiffening_tube_x() = display_envelope_x_min();
function stiffening_tube_y() = project_panel_rear_y - tube_center_from_panel_rear;
function stiffening_tube_bottom_z() = -tube_center_spacing/2;
function stiffening_tube_top_z() =  tube_center_spacing/2;

/* [Exploded view] */
exploded_coupler_offset = 20.0;
exploded_tube_offset = 30.0;

/* [Presentation] */
color_panel = [0.72, 0.72, 0.72, 1];
color_pcb = [0.02,0.20,0.07,1];
color_coupler = [0.88,0.08,0.05,1];
color_middle_panel_coupler = [0.62,0.04,0.03,1];
color_corner_edge_panel_coupler = [0.95,0.20,0.08,1];
color_aluminium_tube = [0.72,0.74,0.76,1];
