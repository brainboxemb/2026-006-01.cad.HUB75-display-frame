// Shared geometry and interface dimensions for the HUB75 display case.
// Migrated from the original single-file model without intentional geometry changes.

$fn = 40;

/* [Panels] */
panel_width = 159.70;
panel_height = 319.71;
panel_thickness = 13.00;
panel_count = 5;
panel_hole_x = [7.85, 151.85];
panel_hole_z = [7.855, 159.855, 311.855];
panel_hole_diameter = 3.0;

/* [Frame] */
extrusion_size = 20;
horizontal_extrusion_length = 840;
vertical_extrusion_length = 320;
frame_height = 360;
inner_width = horizontal_extrusion_length - 2*extrusion_size;

/* [DIN rail TS35 x 7.5 and cable clips] */
din_width = 35.0;
din_height = 7.5;
din_thickness = 1.0;
din_center_web_width = 25.0; // flat section against the panel
din_lip_width = 5.0;        // formed outer lip on each side
din_clip_clearance = 0.35;
xclip_width = 43.0;
xclip_height = 24.0;
xclip_arm_width = 6.0;
xclip_thickness = 4.0;
xclip_hook_depth = 4.0;
xclip_hook_height = 4.0;
din_length = 270.0;
din_clearance = 0.35;
rail_panel_offset = 0.0; // rear web of the rail sits directly on the panel surface
rail_bolt_diameter = 5.5;             // M5 clearance hole through rail and bracket
rail_bolt_head_diameter = 10.0;

// HUB75 ribbon cables run horizontally from panel to panel.
ribbon_cable_width = 16.0;
ribbon_cable_thickness = 1.2;
ribbon_cable_clearance = 0.8;
ribbon_cable_connector_inset = 24.0;
data_connector_z_bottom = 82.0;
data_connector_z_top = panel_height - 82.0;

// Simplified 4-pin power connector on the rear of the panel.
// Vertical; around 42% height in the base orientation, close to OUT.
power_connector_x = panel_width/2;       // approximately horizontally centered
power_connector_z = panel_height * 0.42; // close to OUT in the base orientation; about 42% from the bottom edge
power_connector_width = 12.0;  // mounted vertically
power_connector_height = 24.0;
power_connector_depth = 7.0;

// Thicker X-shaped clips sit completely above the horizontal cable.
cable_clip_length = 18.0;
cable_clip_wall = 2.6;
cable_clip_hook = 2.2;
cable_clip_positions = [0.25, 0.50, 0.75];

/* [ESP32-S3 mount] */
// Dimensional basis: Adafruit Feather format, 50.8 x 22.86 mm.
esp_board_length = 65.0; // provisional MatrixPortal S3 dimensional model
esp_board_width = 32.0;
esp_board_thickness = 1.6;
esp_component_height = 5.5;
esp_clearance = 0.6;
esp_holder_base = 3.2;
esp_holder_wall = 3.0;
esp_arm_thickness = 6.0;
esp_arm_width = 22.0;
esp_din_clearance = 8.0;
esp_rail_index = panel_count - 2; // rightmost vertical DIN rail
esp_arm_length = 72.0;
esp_z_center = 300.0;
esp_simple_plate_width = 76;
esp_simple_plate_height = 58;
esp_simple_plate_thickness = 3;
esp_simple_edge = 3;
esp_simple_clip_width = 12;
esp_simple_top_clearance = 33; // 25 mm lower than the previous position

esp_antenna_clear_zone = 18.0;

/* [DC/DC power supply and metal carrier] */
// Bauer SPW-1224V0520: 74 x 74 x 32 mm, approximately 290 g.
power_supply_width = 74;
power_supply_height = 74;
power_supply_depth = 32;
power_supply_mount_hole_diameter = 5.3;

// Recommended metal plate: 2 mm aluminium.
// Lower-cost alternative: 1.5 mm galvanized steel.
power_supply_plate_width = 120;
power_supply_plate_height = 112;
power_supply_plate_thickness = 2;
power_supply_plate_bottom_z = extrusion_size + 8;
// Positioned visually left and centered on one DIN rail.
// Viewed from the rear: second DIN rail from the left.
// The plate center is exactly aligned with this rail.
power_supply_plate_rail_index = 2;
// Calculated directly; no call to a function defined later.
// Seam 2 lies in the free panel area between the two vertical extrusions.
power_supply_plate_x_center = extrusion_size + (power_supply_plate_rail_index + 1) * (inner_width / panel_count);
power_supply_bottom_clearance = 24; // power supply 12 mm higher on the plate
power_supply_plate_spacing = 4;
power_supply_frame_hole_spacing = 82;
power_supply_din_clip_width = 18;
power_supply_din_clip_height = 16;
power_supply_top_bracket_width = 26;
power_supply_top_bracket_height = 28;
power_supply_top_bracket_thickness = 4;
power_supply_bottom_bracket_width = 20;
power_supply_bottom_bracket_plate_height = 26;
power_supply_bottom_bracket_foot_depth = 14;
power_supply_bottom_bracket_thickness = 4;

// Indicative fasteners
m4_bolt_diameter = 4.0;
m4_head_diameter = 7.5;
m4_head_height = 3.0;
m5_bolt_diameter = 5.0;
m5_head_diameter = 9.0;
m5_head_height = 3.5;
washer_diameter_m4 = 9.0;
washer_diameter_m5 = 11.0;
washer_thickness = 1.0;
t_nut_width = 10.0;
t_nut_length = 16.0;
t_nut_thickness = 4.0;


/* [Brackets] */
bracket_thickness = 5.0;
m3_slot_length = 7.0;
m3_slot_width = 3.4;
m3_hole_diameter = 3.4;              // round M3 panel holes
m5_hole_diameter = 5.5;
m5_center_spacing_x = 20.0;
edge_radius = 4.0;
rail_m3_clearance = 17.0;
rail_clamp_length = 16.0;       // length of the integrated bridge along Z
rail_clamp_wall = 5.0;          // side walls next to the rail
rail_clamp_roof = 4.0;           // bridge above the rail
rail_clamp_clearance_x = 0.40;    // lateral assembly clearance
rail_clamp_clearance_y = 0.25;    // small preload / dimensional compensation
rail_end_stop_thickness = 3.5;     // end stop against the cut end of the rail
rail_end_stop_overlap = 1.0;   // overlap with mounting plate; avoids a zero-thickness face/gap
rail_transition_length = 12.0;   // sloped transition from the flat mounting plate
rear_clearance = 0.0; // main plate is flat; no spacers or recesses

/* [Internal calculations] */
panel_pitch = inner_width / panel_count;
panel_x_margin = (panel_pitch - panel_width) / 2;
panel_z_offset = extrusion_size + (vertical_extrusion_length - panel_height) / 2;

function px(i) = extrusion_size + i * panel_pitch + panel_x_margin;
function hole_x(i, right=false) = px(i) + (right ? panel_hole_x[1] : panel_hole_x[0]);
function seam_left(i) = hole_x(i, true);
function seam_right(i) = hole_x(i+1, false);
function seam_center(i) = (seam_left(i) + seam_right(i)) / 2;

seam_hole_spacing = seam_right(0) - seam_left(0);
seam_offset = seam_hole_spacing / 2;

hole_z_bottom = panel_z_offset + panel_hole_z[0];
hole_z_middle = panel_z_offset + panel_hole_z[1];
hole_z_top = panel_z_offset + panel_hole_z[2];

slot_z_bottom = extrusion_size / 2;
slot_z_top = frame_height - extrusion_size / 2;
extrusion_offset = hole_z_bottom - slot_z_bottom; // exactly 18 mm

assert(abs(hole_z_bottom - 28) < 0.001, "Lower CAD holes should be located at Z=28 mm.");
assert(abs(hole_z_top - 332) < 0.001, "Upper CAD holes should be located at Z=332 mm.");
assert(abs(extrusion_offset - 18) < 0.001, "Distance from panel hole to T-slot should be 18 mm.");
assert(abs(seam_hole_spacing - 16) < 0.001, "Holes around a panel seam should be 16 mm apart.");

// Frame-centric Y coordinate system.
// The front face of the 20 x 20 aluminium extrusion is the reference plane.
frame_front_y = 0;
frame_back_y = frame_front_y + extrusion_size;

// HUB75 front face is recessed 1 mm relative to the aluminium front face.
panel_recess_from_extrusion = 1;
panel_front_y = frame_front_y + panel_recess_from_extrusion;
panel_back_y = panel_front_y + panel_thickness;
panel_extrusion_y_offset = frame_back_y - panel_back_y;

// Rail back web lies directly on the rear face of the HUB75 panel.
din_z_start = hole_z_bottom + rail_m3_clearance;
din_z_end = din_z_start + din_length;
din_end_clearance_bottom = din_z_start - hole_z_bottom;
din_end_clearance_top = hole_z_top - din_z_end;
din_back_y = panel_back_y;
din_front_y = din_back_y + din_height;
ribbon_cable_y = din_back_y + din_height + ribbon_cable_clearance;

assert(din_end_clearance_bottom >= rail_m3_clearance-0.01,
    "DIN rail is too close to the lower M3 hole.");
assert(din_end_clearance_top >= rail_m3_clearance-0.01,
    "DIN rail is too close to the upper M3 hole.");
assert(abs(frame_front_y) < 0.001,
    "The aluminium front face is the Y=0 reference plane.");
assert(abs(panel_front_y-1) < 0.001,
    "Panel front face should be recessed by 1 mm.");
assert(abs(panel_extrusion_y_offset-6) < 0.001,
    "Bracket offset from panel to extrusion should be 6 mm.");

/* [Hidden] */
color_extrusion = [0.72,0.52,0.18,1];
color_panel = [0.08,0.10,0.09,1];
color_pcb = [0.02,0.20,0.07,1];
color_bracket = [0.86,0.22,0.05,1];
color_din = [0.55,0.57,0.60,1];
