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

// Exact placement grid.  The supplied panel is nominally 320 x 160 mm in
// landscape orientation; this project uses it portrait, so X pitch is 160 mm
// and Z pitch is 320 mm.  The physical body is slightly smaller and is centred
// inside this nominal cell.  Coupler references MUST follow this grid, never
// the physical panel edge.
panel_grid_pitch_x = hub75_panel_nominal_width();
panel_grid_pitch_z = hub75_panel_nominal_height();
panel_pitch = panel_grid_pitch_x; // backwards-compatible assembly alias

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

function display_nominal_width() = panel_count * panel_grid_pitch_x;
function display_nominal_height() = panel_grid_pitch_z;
function display_actual_width() = display_nominal_width() - hub75_panel_grid_gap_x();
function display_actual_height() = hub75_panel_height();

// Nominal grid is authoritative.  Every physical panel is centred in its
// 160 x 320 mm cell; its 0.30 x 0.29 mm undersize therefore appears as equal
// margins on both sides instead of shifting seams/couplers by half the gap.
function panel_nominal_left_x(index) = -display_nominal_width()/2 + index * panel_grid_pitch_x;
function panel_center_x(index) = panel_nominal_left_x(index) + panel_grid_pitch_x/2;
function panel_x(index) = panel_center_x(index) - hub75_panel_width()/2;
function panel_center_z() = 0;
function panel_nominal_bottom_z() = -panel_grid_pitch_z/2;
function panel_nominal_top_z() = panel_grid_pitch_z/2;
function panel_front_y() = project_panel_rear_y - hub75_panel_mounting_plane_y();
function panel_drawing_z(global_drawing_z) = global_drawing_z - hub75_panel_height()/2;
function panel_hole_z_bottom() = panel_drawing_z(hub75_panel_hole_z_bottom());
function panel_hole_z_middle() = panel_drawing_z(hub75_panel_hole_z_middle());
function panel_hole_z_top() = panel_drawing_z(hub75_panel_hole_z_top());
function panel_hole_z_positions() = [panel_hole_z_bottom(), panel_hole_z_middle(), panel_hole_z_top()];
// Internal coupler centres sit exactly on the nominal grid boundaries.
function seam_x(seam_index) = -display_nominal_width()/2 + (seam_index + 1) * panel_grid_pitch_x;

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

// Coupler design profiles are project-level presets. The selected profile is
// the single source of truth for all effective coupler dimensions. Three
// named presets are fixed and reproducible; selecting "custom" switches the
// model to the user-entered custom dimensions.
//
//   small  =  60 mm, 2 mm wall,  4 mm guide, 2 mm base
//   medium =  80 mm, 4 mm wall,  6 mm guide, 3 mm base
//   large  = 100 mm, 6 mm wall, 10 mm guide, 4 mm base
function coupler_profile_size_for(name) =
    name == "small" ?  60.0 :
    name == "large" ? 100.0 :
                       80.0;
function coupler_wall_thickness_for(name) =
    name == "small" ? 2.0 :
    name == "large" ? 6.0 :
                      4.0;
function coupler_guide_height_for(name) =
    name == "small" ?  4.0 :
    name == "large" ? 10.0 :
                       6.0;
function coupler_base_thickness_for(name) =
    name == "small" ? 2.0 :
    name == "large" ? 4.0 :
                      3.0;

// Shape/placement presets. These describe printable coupler geometry, not
// HUB75 panel geometry. Names are intentionally visual:
//   corner_radius = concave transition where an arm meets the centre/body
//   edge_radius   = convex rounding at the free outside end of an arm
//
// Keep the named profiles systematic rather than maintaining unrelated magic
// numbers. The formulas below are evaluated from the preset profile envelope:
//   corner radius    = profile size / 10
//   edge radius      = wall thickness - 1 mm (minimum 0.5 mm)
//                      This is deliberate: at a free arm end the remaining
//                      guide thickness per side is wall_thickness-edge_radius.
//                      Keeping 1 mm prevents the rounded plate end from
//                      consuming the guide completely.
//   guide length     = half profile size - max(1.5 mm, edge radius/2)
//                      so the guide reaches close to the free end while still
//                      leaving room for a rounded termination.
//   tube clip offset = as far out as practical, but never closer than 12 mm
//                      from the nominal free edge (8 mm half clip + 4 mm margin)
//                      and capped at the established 25 mm position.
// Custom mode may override all four values explicitly.
function coupler_corner_radius_for(name) =
    coupler_profile_size_for(name) / 10;
function coupler_edge_radius_for(name) =
    max(0.5, coupler_wall_thickness_for(name) - 1.0);
function coupler_guide_length_for(name) =
    max(0, coupler_profile_size_for(name)/2 - max(1.5, coupler_edge_radius_for(name)/2));
function coupler_tube_clip_offset_for(name) =
    min(25, max(0, coupler_profile_size_for(name)/2 - 12));

function project_coupler_design_profile() =
    is_undef($coupler_design_profile) ? "medium" : $coupler_design_profile;

// Custom fields default to the medium preset.  They are deliberately ignored
// unless the profile itself is set to "custom"; no extra enable checkbox and
// no magic sentinel values are required.
function project_coupler_custom_profile_size() =
    is_undef($coupler_custom_profile_size) ? coupler_profile_size_for("medium") : $coupler_custom_profile_size;
function project_coupler_custom_wall_thickness() =
    is_undef($coupler_custom_wall_thickness) ? coupler_wall_thickness_for("medium") : $coupler_custom_wall_thickness;
function project_coupler_custom_guide_height() =
    is_undef($coupler_custom_guide_height) ? coupler_guide_height_for("medium") : $coupler_custom_guide_height;
function project_coupler_custom_base_thickness() =
    is_undef($coupler_custom_base_thickness) ? coupler_base_thickness_for("medium") : $coupler_custom_base_thickness;
function project_coupler_custom_corner_radius() =
    is_undef($coupler_custom_corner_radius) ? coupler_corner_radius_for("medium") : $coupler_custom_corner_radius;
function project_coupler_custom_edge_radius() =
    is_undef($coupler_custom_edge_radius) ? coupler_edge_radius_for("medium") : $coupler_custom_edge_radius;
function project_coupler_custom_guide_length() =
    is_undef($coupler_custom_guide_length) ? coupler_guide_length_for("medium") : $coupler_custom_guide_length;
function project_coupler_custom_tube_clip_offset() =
    is_undef($coupler_custom_tube_clip_offset) ? coupler_tube_clip_offset_for("medium") : $coupler_custom_tube_clip_offset;

function project_coupler_profile_size() =
    project_coupler_design_profile() == "custom"
        ? project_coupler_custom_profile_size()
        : coupler_profile_size_for(project_coupler_design_profile());
function project_coupler_wall_thickness() =
    project_coupler_design_profile() == "custom"
        ? project_coupler_custom_wall_thickness()
        : coupler_wall_thickness_for(project_coupler_design_profile());
function project_coupler_guide_height() =
    project_coupler_design_profile() == "custom"
        ? project_coupler_custom_guide_height()
        : coupler_guide_height_for(project_coupler_design_profile());
function project_coupler_base_thickness() =
    project_coupler_design_profile() == "custom"
        ? project_coupler_custom_base_thickness()
        : coupler_base_thickness_for(project_coupler_design_profile());
function project_coupler_corner_radius() =
    project_coupler_design_profile() == "custom"
        ? project_coupler_custom_corner_radius()
        : coupler_corner_radius_for(project_coupler_design_profile());
function project_coupler_edge_radius() =
    project_coupler_design_profile() == "custom"
        ? project_coupler_custom_edge_radius()
        : coupler_edge_radius_for(project_coupler_design_profile());
function project_coupler_guide_length() =
    project_coupler_design_profile() == "custom"
        ? project_coupler_custom_guide_length()
        : coupler_guide_length_for(project_coupler_design_profile());
function project_coupler_tube_clip_offset() =
    project_coupler_design_profile() == "custom"
        ? project_coupler_custom_tube_clip_offset()
        : coupler_tube_clip_offset_for(project_coupler_design_profile());

// Decorative Ø3 pockets scale with the selected/overridden profile size.
// The available decorative stations scale automatically with the active profile size.
function project_coupler_reference_max_step() =
    max(2, floor((project_coupler_profile_size()/2 - 10.0) / 10.0));
function project_coupler_reference_steps() =
    [for(step=[2:project_coupler_reference_max_step()]) step];

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
