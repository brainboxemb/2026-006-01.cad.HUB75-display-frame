// HUB75 display frame - V1.2 shared project configuration
//
// V1.2 keeps the established V1.1 HUB75 panel reference and the two
// continuous aluminium stiffening tubes. Only the printed support structure
// is simplified: direct panel-to-panel couplers replace the 160 x 160 mm
// modular frame grid.

$fn = 48;

/* [Panels] */
// Dimensional authority for the basic panel envelope and mounting pattern:
//
//   2277_P5_320x160mm_64x32 pixel drawing
//
// The project uses portrait coordinates:
// X = 159.70 mm
// Z = 319.71 mm
//
// The STEP reference remains useful for approximate rear-frame and connector
// geometry, but it does NOT override these datasheet dimensions.

panel_width = 159.70;
panel_height = 319.71;
panel_depth = 14.50;
panel_count = 5;

// Data-chain order is defined from the REAR of the assembled display.
// Default: panel 1 is the rear-left panel and its HUB75 input is at the top.
// Adjacent panels alternate 180 degrees so the chain snakes across the rear.
rear_chain_start_side = "left"; // [left,right]
first_panel_input_side = "top"; // [top,bottom]

function panel_chain_number(global_index) =
    rear_chain_start_side == "left"
        ? panel_count - global_index
        : global_index + 1;

function panel_input_is_top(global_index) =
    let(chain_index = panel_chain_number(global_index) - 1)
        first_panel_input_side == "top"
            ? chain_index % 2 == 0
            : chain_index % 2 == 1;

function panel_rotated(global_index) =
    !panel_input_is_top(global_index);

// Nominal array pitch remains 160 x 320 mm.
panel_nominal_width = 160.00;
panel_nominal_height = 320.00;

// Keep separate STEP-reference dimensions for non-critical visual details.
panel_reference_nominal_width = 160.00;
panel_reference_nominal_height = 320.00;

function panel_ref_x(value) =
    value * panel_width / panel_reference_nominal_width;

function panel_ref_z(value) =
    value * panel_height / panel_reference_nominal_height;

// STEP-derived front layer approximation retained for visual modelling.
panel_front_mask_depth = 1.00;
panel_pcb_thickness = 1.00;
panel_pcb_back_y =
    panel_front_mask_depth
    + panel_pcb_thickness;

// Current physical/modelled depth. The 2D drawing remains authoritative for
// width, height and mounting-hole pattern.
panel_mounting_plane_y = panel_depth;
panel_max_depth = panel_depth;

// Backwards-compatible name used by the V1.2 support code.
panel_thickness = panel_depth;

// Datasheet-derived mounting-hole pattern in portrait coordinates.
panel_hole_x = [
    7.85,
    151.85
];

panel_hole_z = [
    7.855,
    159.855,
    311.855
];

panel_hole_diameter = 3.00;

// Mounting-boss outer shape is not dimensioned in the supplied drawing.
// Keep the STEP-derived value as a visual approximation until measured.
panel_boss_outer_diameter = 14.0;

// STEP-derived HUB75 connector geometry remains a visual reference only.
data_connector_x = panel_ref_x(80.0135);
data_connector_z_bottom = panel_ref_z(44.10);
data_connector_z_top = panel_ref_z(264.60);
data_connector_width = panel_ref_x(27.94);
data_connector_height = panel_ref_z(9.50);
data_connector_depth = 10.64;
data_connector_front_y = 2.63;

// Simplified STEP-inspired open rear-frame geometry.
rear_frame_side_width = panel_ref_x(12.5);
rear_frame_end_width = panel_ref_z(12.5);
rear_frame_crossbar_width = panel_ref_z(8.0);

rear_frame_crossbar_z = [
    panel_ref_z(80),
    panel_ref_z(160),
    panel_ref_z(240)
];

rear_frame_start_y = panel_pcb_back_y;
rear_frame_depth =
    panel_mounting_plane_y
    - rear_frame_start_y;

// Datasheet envelope is authoritative, so no STEP geometry may extend beyond
// the 13 mm panel depth.
rear_rib_extra_depth = 0;

// Power connector remains a simplified visual placeholder until measured.
power_connector_x = panel_width / 2;
power_connector_z = panel_height / 2;
power_connector_width = 12.0;
power_connector_height = 24.0;
power_connector_depth = 7.0;

/* [Panel array] */
panel_pitch = panel_nominal_width;
display_nominal_width = panel_count * panel_nominal_width;
display_nominal_height = panel_nominal_height;
display_actual_width = (panel_count - 1) * panel_pitch + panel_width;
display_actual_height = panel_height;

// Global array coordinates remain lower-left based, while the panel component
// itself is centred around X=0 and Z=0. Assemblies place each panel by centre.
panel_front_y = 0;
panel_z_offset = 0;

function panel_x(index) = index * panel_pitch;
function panel_center_x(index) = panel_x(index) + panel_width/2;
function panel_center_z() = panel_z_offset + panel_height/2;
function panel_hole_x_global(index, right=false) =
    panel_x(index) + (right ? panel_hole_x[1] : panel_hole_x[0]);
function seam_x(seam_index) = (seam_index + 1) * panel_pitch;

/* [Printed couplers] */
// Existing HUB75 screw positions around a nominal 160 mm vertical seam.
seam_left_screw_x = panel_hole_x[1] - panel_nominal_width; // -8.15 mm
seam_right_screw_x = panel_hole_x[0];                      // +7.85 mm

coupler_thickness = 4.0;
coupler_screw_hole_diameter = 3.4;
coupler_corner_radius = 3.0;
coupler_y = panel_mounting_plane_y;

// Middle seam bracket V13 - larger, softer PLUS base.
// First get the footprint around the panel ribs right; reinforcement is added later.
middle_coupler_width = 104.0;
middle_coupler_height = 100.0;
middle_coupler_horizontal_arm_height = 36.0;
middle_coupler_vertical_width = 38.0;
middle_coupler_inside_corner_radius = 18.0;
middle_coupler_outer_corner_radius = 12.0;

// Only the smaller Ø8.5 mounting tubes protrude.
middle_mounting_tube_outer_diameter = 8.50;
middle_mounting_tube_clearance = 0.45;
middle_mounting_tube_pocket_depth = 0.90;

// Passive centre locator.
middle_centre_locator_x = 0.0;
middle_centre_locator_z = 0.0;
middle_centre_locator_diameter = 2.10;
middle_centre_locator_height = 2.0;

// V13: 10 mm rib-following guide on the panel side of the base plate.
// The middle coupler reads the rib widths directly from hub75_panel.scad.
// This value is the fitting clearance on EACH side of those ribs.
middle_guide_wall_thickness = 0.50;
middle_guide_wall_height = 10.0;
middle_guide_wall_straight = 0.0;

// Tapered centre rib enters the small gap between adjacent panels.
middle_centre_rib_width = 3.0;
middle_centre_rib_height = 4.0;
middle_centre_rib_length = 30.0;

tube_seam_plate_width = 56.0;
tube_seam_plate_height = 24.0;

// Single-screw end plate. The plate is intentionally asymmetric because the
// existing HUB75 mounting hole is only 7.85 mm from the outside panel edge.
end_coupler_plate_width = 34.0;
end_coupler_plate_height = 24.0;
end_coupler_outer_margin = 6.0;

// Shift the clip slightly inward so its full 20 mm width remains inside the
// panel outline while staying close to the screw/load path.
end_clip_inward_offset = 6.0;

/* [Aluminium stiffening tubes] */
// Exact V1.1 tube geometry and placement.
stiffening_tube_outer_diameter = 10.0;
stiffening_tube_wall_thickness = 1.0;
stiffening_tube_inner_diameter =
    stiffening_tube_outer_diameter - 2*stiffening_tube_wall_thickness;
stiffening_tube_length = display_nominal_width;

// Exact V1.1 snap-clip geometry.
tube_clip_length = 20.0;
tube_clip_wall = 2.6;
tube_clip_inner_diameter = 10.4;
tube_clip_opening = 8.2;
tube_clip_plate_overlap = 1.4;
tube_clip_vertical_overlap = 2.0;

function tube_clip_outer_diameter() =
    tube_clip_inner_diameter + 2*tube_clip_wall;

function tube_clip_outer_radius() =
    tube_clip_outer_diameter()/2;

// Exact V1.1 Y placement. The coupler occupies the same rear plane as the old
// V1.1 frame module, so the same expression can be used directly.
function stiffening_tube_y() =
    coupler_y + tube_clip_plate_overlap - tube_clip_outer_radius();

function stiffening_tube_bottom_z() =
    -tube_clip_outer_radius();

function stiffening_tube_top_z() =
    display_nominal_height + tube_clip_outer_radius();

// Compact V1.2 distribution:
// two clips close to the seam connection instead of spreading them across
// the complete 160 mm module width.
seam_clip_x_left = -14.0;
seam_clip_x_right = 14.0;

// End parts are mirrored. Positive X is inward on the left end; negative X
// is inward on the right end.
function end_plate_center_x(side="left") =
    side == "left"
        ? (-end_coupler_outer_margin + end_coupler_plate_width/2)
        : ( end_coupler_outer_margin - end_coupler_plate_width/2);

function end_clip_x(side="left") =
    side == "left" ? end_clip_inward_offset : -end_clip_inward_offset;

/* [Exploded view] */
exploded_coupler_offset = 20.0;
exploded_tube_offset = 30.0;

/* [Hidden] */
color_panel = [0.72, 0.72, 0.72, 1];
color_pcb = [0.02,0.20,0.07,1];
color_coupler = [0.88,0.08,0.05,1];
color_middle_coupler = [0.62,0.04,0.03,1];
color_end_coupler = [0.95,0.20,0.08,1];
color_aluminium_tube = [0.72,0.74,0.76,1];
