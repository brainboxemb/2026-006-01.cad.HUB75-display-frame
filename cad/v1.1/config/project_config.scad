// HUB75 display frame - V1.1 shared project configuration
//
// V1.1 uses the nominal HUB75 panel pitch as the structural grid. The actual
// panel PCB is slightly smaller than this nominal grid, leaving a small amount
// of mechanical clearance between adjacent panels.

$fn = 40;

/* [Panels] */
panel_nominal_width = 160.00;
panel_nominal_height = 320.00;

panel_width = 159.70;
panel_height = 319.71;
panel_thickness = 13.00;
panel_count = 5;

panel_hole_x = [7.85, 151.85];
panel_hole_z = [7.855, 159.855, 311.855];
panel_hole_diameter = 3.0;

// Simplified rear connector positions on the HUB75 panel reference model.
data_connector_z_bottom = 82.0;
data_connector_z_top = panel_height - 82.0;

power_connector_x = panel_width / 2;
power_connector_z = panel_height * 0.42;
power_connector_width = 12.0;
power_connector_height = 24.0;
power_connector_depth = 7.0;

/* [Panel array] */
panel_pitch = panel_nominal_width;
display_nominal_width = panel_count * panel_nominal_width;
display_nominal_height = panel_nominal_height;
display_actual_width = (panel_count - 1) * panel_pitch + panel_width;
display_actual_height = panel_height;

// V1.1 reference coordinate system:
// X = left edge of panel 1 nominal cell / panel array
// Y = front face of the HUB75 panels
// Z = bottom edge of the nominal 320 mm panel cell
panel_front_y = 0;
panel_z_offset = 0;

function panel_x(index) = index * panel_pitch;
function panel_hole_x_global(index, right=false) =
    panel_x(index) + (right ? panel_hole_x[1] : panel_hole_x[0]);

/* [Printed frame modules] */
frame_module_size = 160.0;
frame_module_thickness = 4.0;
frame_module_opening_size = 132.0;
frame_module_opening_radius = 8.0;
frame_module_mount_hole_diameter = 3.4;

// Adjacent printed modules do not meet exactly on the nominal 160 mm grid
// line. The female/pocket module owns a 5 mm strip across the nominal boundary,
// while the male module is cut back 5 mm. A puzzle key spans 10 mm in total:
// from 5 mm before the nominal line to 5 mm beyond it. This deliberately
// offsets the structural seam from the HUB75 panel seam.
frame_interlock_overlap = 5.0;

// The module lies directly behind the nominal rear face of the HUB75 panel.
frame_module_y = panel_thickness;

// Two puzzle-style keys per joined edge. The side containing the pockets owns
// the continuous 5 mm overlap strip. Male keys cross that strip and span a
// 10 mm total joint region. Outer display edges remain plain for the later
// visible border.
frame_interlock_positions = [50, 110];
frame_interlock_depth = 10.0;
// Dovetail profile. The flanks start directly at the 11 mm root and run at
// 45 degrees. The last 1.5 mm is straight, so the wide end is derived from
// depth, root width and tip-flat length instead of being tuned independently.
frame_interlock_neck_width = 11.0;
frame_interlock_tip_flat = 1.5;
frame_interlock_clearance = 0.30;

function frame_interlock_head_width() =
    frame_interlock_neck_width + 2*(frame_interlock_depth-frame_interlock_tip_flat);

frame_grid_columns = panel_count;
frame_grid_rows = 2;

/* [Panel seam joiners] */
// A small printed bridge is placed over each vertical panel seam at every
// existing HUB75 screw row. The two panel screws then clamp both neighbouring
// panels and both underlying frame modules through one common part.
seam_joiner_thickness = 3.0;
seam_joiner_width = 28.0;
seam_joiner_height = 24.0;
seam_joiner_corner_chamfer = 2.0;
seam_joiner_screw_hole_diameter = 3.4;

// Existing panel screw positions relative to the nominal 160 mm panel seam.
seam_joiner_left_screw_x = panel_hole_x[1] - panel_nominal_width;
seam_joiner_right_screw_x = panel_hole_x[0];

// Four small locating pins register the joiner to the printed frame modules.
// At the middle screw row these naturally locate into all four modules around
// the 160 x 160 mm grid intersection.
seam_joiner_pin_x_offset = 11.0;
seam_joiner_pin_z_offset = 4.0;
seam_joiner_middle_pin_z_offset = 8.0;
seam_joiner_pin_diameter = 2.4;
seam_joiner_pin_hole_diameter = 2.8;
seam_joiner_pin_length = 2.2;

// Joiners sit on the rear face of the 4 mm frame modules.
seam_joiner_y = frame_module_y + frame_module_thickness;


/* [Aluminium stiffening tubes] */
// Two continuous tubes run along the top and bottom of the display. In side
// view the printed frame plate continues straight past the panel edge and the
// C-shaped tube clamp sits beside that extension. The tube axis is therefore
// perpendicular to the plate extension, matching the intended simple T-like
// construction.
stiffening_tube_outer_diameter = 10.0;
stiffening_tube_wall_thickness = 1.0;
stiffening_tube_inner_diameter = stiffening_tube_outer_diameter - 2*stiffening_tube_wall_thickness;
stiffening_tube_length = display_nominal_width;

// Snap-clip geometry. Two short clips per 160 mm module distribute the load
// along the full 800 mm tube.
tube_clip_positions = [40, 120];
tube_clip_length = 20.0;
tube_clip_wall = 2.6;
tube_clip_inner_diameter = 10.4;
tube_clip_opening = 8.2;

// In side view the clamp sits beside the straight plate extension. Its rear
// outer wall overlaps the plate by this amount. The C opening is on the
// opposite side, i.e. rotated 90 degrees from the old upward-facing clamp.
tube_clip_plate_overlap = 1.4;

// Vertical overlap of the straight extension into the closed side of the
// C-shaped ring.
tube_clip_vertical_overlap = 2.0;

function tube_clip_outer_diameter() = tube_clip_inner_diameter + 2*tube_clip_wall;
function tube_clip_outer_radius() = tube_clip_outer_diameter()/2;

// The frame module occupies Y = frame_module_y .. frame_module_y + thickness.
// Place the ring mostly in front of it, with only the configured overlap into
// the module's front face. The aluminium tube itself remains above/below the
// screen panel and is accessible from the opposite side for future border
// clips.
function stiffening_tube_y() = frame_module_y + tube_clip_plate_overlap - tube_clip_outer_radius();
function stiffening_tube_bottom_z() = -tube_clip_outer_radius();
function stiffening_tube_top_z() = display_nominal_height + tube_clip_outer_radius();

/* [Hidden] */
color_panel = [0.08,0.10,0.09,1];
color_pcb = [0.02,0.20,0.07,1];
// Four related red shades are used in the normal assembly as a repeating
// 2 x 2 visual pattern. This makes neighbouring printed modules easier to
// distinguish without changing the intended material family.
color_frame_module_r1 = [0.90, 0.05, 0.04, 1];   // red
color_frame_module_r2 = [1.00, 0.30, 0.26, 1];   // light red
color_frame_module_r3 = [0.38, 0.015, 0.012, 1]; // dark red
color_frame_module_r4 = [0.55, 0.14, 0.09, 1];   // chestnut red
color_seam_joiner = [0.96,0.18,0.08,1];
color_aluminium_tube = [0.72,0.74,0.76,1];
