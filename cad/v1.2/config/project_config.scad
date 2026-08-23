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

// Rear-frame geometry used by both the panel model and the couplers.
// Keep these in sync with the HUB75 component reference geometry:
//   side rail       12.5 mm
//   end rail        10.75 mm
//   middle crossbar 20.0 mm
// The previous V30 config still contained the older simplified 8 mm
// crossbar / 12.5 mm end-rail values, which made the derived coupler
// profile wrong even though hub75_panel.scad itself exposed the correct
// dimensions.
rear_frame_side_width = panel_ref_x(12.5);
rear_frame_end_width = panel_ref_z(10.75);
rear_frame_crossbar_width = panel_ref_z(20.0);

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

// Shared coupler design rules.
//
// The profile envelope is exactly 100 mm. The middle PLUS therefore reaches
// 50 mm from the screw-row centre in both Z directions. The upper/lower T
// likewise reaches 50 mm inward from the screw-row centre.
//
// Arm thickness is derived from the REAL HUB75 rib width, not from one fixed
// visual width. We keep the same printed material on both sides of each rib.
coupler_profile_size = 100.0;
coupler_wall_thickness = 5.0;
coupler_fit_clearance = 0.50;
coupler_profile_rib_side_material = coupler_wall_thickness + coupler_fit_clearance;
coupler_profile_inside_corner_radius = 10.0;
coupler_profile_outer_corner_radius = 6.0;

// At an internal panel seam, two side rails meet.
coupler_seam_rib_width = 2 * rear_frame_side_width;

// Middle PLUS: thickness follows the real middle crossbar and seam rib.
middle_profile_horizontal_arm_height =
    rear_frame_crossbar_width + 2 * coupler_profile_rib_side_material;
middle_profile_vertical_arm_width =
    coupler_seam_rib_width + 2 * coupler_profile_rib_side_material;

// Upper/lower T: thickness follows the real top/bottom end rail and seam rib.
horizontal_edge_panel_coupler_profile_horizontal_arm_height =
    rear_frame_end_width + 2 * coupler_profile_rib_side_material;
horizontal_edge_panel_coupler_profile_vertical_arm_width =
    coupler_seam_rib_width + 2 * coupler_profile_rib_side_material;

// Shared visual treatment for the exposed ends of the raised fit guides.
// This is safe to share: it only rounds the printed guide termination; the
// actual rib keep-outs remain derived independently from hub75_panel.scad.
coupler_guide_end_rounding = 1.5;

middle_panel_coupler_width = coupler_profile_size;
middle_panel_coupler_height = coupler_profile_size;
middle_panel_coupler_horizontal_arm_height = middle_profile_horizontal_arm_height;
middle_panel_coupler_vertical_width = middle_profile_vertical_arm_width;
middle_panel_coupler_inside_corner_radius = coupler_profile_inside_corner_radius;
middle_panel_coupler_outer_corner_radius = coupler_profile_outer_corner_radius;

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
middle_guide_wall_thickness = coupler_fit_clearance;
middle_guide_wall_height = 10.0;
middle_guide_wall_straight = 0.0;
middle_guide_end_rounding = coupler_guide_end_rounding;

// Tapered centre rib enters the small gap between adjacent panels.
middle_centre_rib_width = 3.0;
middle_centre_rib_height = 4.0;
middle_centre_rib_length = 30.0;

// Horizontal edge panel couplers use the same profile generator as the
// middle PLUS, but their arm thickness follows the actual end-rail width.
horizontal_edge_panel_coupler_plate_width = coupler_profile_size;
horizontal_edge_panel_coupler_plate_height = coupler_profile_size;
// Retained for API compatibility; silhouette is now controlled by the shared profile.
horizontal_edge_panel_coupler_inboard_reach = coupler_profile_size / 2;
horizontal_edge_panel_coupler_max_outside_projection = 20.0;
horizontal_edge_panel_coupler_horizontal_arm_height = horizontal_edge_panel_coupler_profile_horizontal_arm_height;
horizontal_edge_panel_coupler_vertical_width = horizontal_edge_panel_coupler_profile_vertical_arm_width;
horizontal_edge_panel_coupler_inside_corner_radius = coupler_profile_inside_corner_radius;
horizontal_edge_panel_coupler_outer_corner_radius = coupler_profile_outer_corner_radius;
horizontal_edge_panel_coupler_guide_clearance = coupler_fit_clearance;
horizontal_edge_panel_coupler_guide_height = 10.0;
horizontal_edge_panel_coupler_guide_end_rounding = coupler_guide_end_rounding;

// STEP-inspired blind Ø3 mm pockets on the visible rear face.
horizontal_edge_panel_coupler_perforation_diameter = 3.0;
horizontal_edge_panel_coupler_perforation_depth = 2.5;
horizontal_edge_panel_coupler_perforation_spacing = 10.0;
horizontal_edge_panel_coupler_perforation_edge_margin = 7.0;
horizontal_edge_panel_coupler_perforation_centre_keepout = 20.0;

// Each of the four short tube clips has its own local support foot.
// The foot deliberately extends toward the ring so the clip is not attached
// by an almost tangential contact point.
horizontal_edge_panel_coupler_clip_root_height = 6.0;
horizontal_edge_panel_coupler_clip_root_depth = 5.0;

// Tapered locating wedge in the vertical gap between adjacent panels.
horizontal_edge_panel_coupler_wedge_width = 3.0;
horizontal_edge_panel_coupler_wedge_height = 4.0;
horizontal_edge_panel_coupler_wedge_length = 30.0;

// Outer display-edge ridge follows the same low tapered build-up as the
// centre seam wedge, rather than the full 10 mm panel-fit guide height.
horizontal_edge_panel_coupler_outer_ridge_height = horizontal_edge_panel_coupler_wedge_height;
horizontal_edge_panel_coupler_outer_ridge_taper_inset =
    horizontal_edge_panel_coupler_wedge_width * (1.0 - 0.73) / 2;

// Clearance around the STEP-derived Ø14 reinforcement bushings.
horizontal_edge_panel_coupler_bushing_clearance = 0.45;

// Clearance around the panel's Ø3 x 3 mm locator pin.  The corresponding
// hole is cut fully through the horizontal edge coupler base plate.
horizontal_edge_panel_coupler_locator_pin_clearance = 0.40;

// Corner edge panel coupler. All four corners use one mirrored/oriented
// printable component. The profile is derived from the REAL single side rail
// and top/bottom end rail, with the same shared wall-thickness rule.
corner_edge_panel_coupler_profile_horizontal_arm_height =
    rear_frame_end_width + 2 * coupler_profile_rib_side_material;
corner_edge_panel_coupler_profile_vertical_arm_width =
    rear_frame_side_width + 2 * coupler_profile_rib_side_material;
corner_edge_panel_coupler_max_outside_projection = 19.5;
corner_edge_panel_coupler_guide_clearance = coupler_fit_clearance;
corner_edge_panel_coupler_guide_height = 10.0;
corner_edge_panel_coupler_guide_end_rounding = coupler_guide_end_rounding;
corner_edge_panel_coupler_perforation_diameter = 3.0;
corner_edge_panel_coupler_perforation_depth = 2.5;
corner_edge_panel_coupler_clip_inboard_positions = [20.0];
corner_edge_panel_coupler_clip_root_height = 6.0;
corner_edge_panel_coupler_clip_root_depth = 7.0;
corner_edge_panel_coupler_bushing_clearance = 0.45;
// Full through-clearance for the diagonal Ø3 x 3 mm panel locator pin.
corner_edge_panel_coupler_locator_pin_clearance = horizontal_edge_panel_coupler_locator_pin_clearance;
corner_edge_panel_coupler_outer_ridge_height = horizontal_edge_panel_coupler_outer_ridge_height;
corner_edge_panel_coupler_outer_ridge_taper_inset = horizontal_edge_panel_coupler_outer_ridge_taper_inset;
corner_edge_panel_coupler_clip_ridge_clearance = 2.5;

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

// Internal horizontal edge couplers use two short snap clips.
// Keeping the clips short limits the force needed to snap over the Ø10 tube,
// while two well-spaced clips keep the edge coupler visually and mechanically simple.
horizontal_edge_clip_x_positions = [-25.0, 25.0];
horizontal_edge_tube_clip_length = 16.0;
corner_edge_tube_clip_length = 16.0;

/* [Exploded view] */
exploded_coupler_offset = 20.0;
exploded_tube_offset = 30.0;

/* [Hidden] */
color_panel = [0.72, 0.72, 0.72, 1];
color_pcb = [0.02,0.20,0.07,1];
color_coupler = [0.88,0.08,0.05,1];
color_middle_panel_coupler = [0.62,0.04,0.03,1];
color_corner_edge_panel_coupler = [0.95,0.20,0.08,1];
color_aluminium_tube = [0.72,0.74,0.76,1];
