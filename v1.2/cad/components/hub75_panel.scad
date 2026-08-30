// HUB75 P5 64 x 32 panel reference component
//
// Geometry references:
// - Supplied STEP model: Hub75 P5 Matrix Panel.step
// - Supplied dimensional drawing: 2277_P5_320x160mm_64x32+pixel.pdf
// - Supplied rear-panel photograph (secondary visual reference)
//
// This component is intentionally self-contained.
// It does NOT include the project configuration.
//
// The project assembly can override all relevant dimensions explicitly,
// while opening this file directly provides usable defaults in the Customizer.
//
// Coordinate system:
// X = panel width, centred around X = 0
// Y = front to rear; the front face remains at Y = 0
// Z = panel height, centred around Z = 0
//
// Internally the measured drawing coordinates are still expressed from the
// lower-left corner. The complete panel geometry is translated by -width/2
// and -height/2 at the module boundary so the panel centre is X=0, Z=0.
//
// Note:
// The project uses the panel in portrait orientation. The physical panel is
// commonly shown as 319.71 x 159.70 mm landscape. Therefore the four rear
// electronics bays appear stacked vertically in this component.


/* [Panel size] */

// Drawing dimensions - authoritative basic front envelope.
// STEP supplies the taper relation and the measured physical panel confirms the overall depth.
panel_width = 159.70;
panel_height = 319.71;
panel_depth = 14.50;

// STEP nominal dimensions are retained for scaling visual rear details.
reference_width = 160.00;
reference_height = 320.00;


/* [Panel depth] */

// STEP reference: the front envelope stays at the full nominal 320 x 160 mm
// through x = 2.0 mm. The PCB occupies x = 1.0 .. 2.0 mm, so the rear
// structural housing starts at 2.0 mm. In this portrait model that maps to Y.
front_mask_depth = 1.00;
pcb_thickness = 1.00;

// Physical measurement and STEP model are authoritative for the overall depth.
mounting_plane_y = panel_depth;
max_depth = panel_depth;

// The STEP reference shows a mostly smooth rear frame. The main rails extend
// to the rear mounting plane, with a shallow recessed strip inside the raised
// border. The recess is kept deliberately simple; no decorative lattice is
// added unless it is mechanically useful later.
rear_recess_depth = 0.80;

// STEP-derived outer housing taper.
//
// Exact STEP side-plane vertices show:
//   front of rear housing : x =  2.00 mm, full 320.0 x 160.0 mm envelope
//   rear perimeter face   : x = 14.50 mm, inset 1.25 mm on every side
//                          -> 317.5 x 157.5 mm
//
// The physical panel measures 14.50 mm overall, matching the STEP rear perimeter
// face at x = 14.50 mm. The taper therefore runs directly from 2.00 mm to
// 14.50 mm, while keeping the STEP-derived 1.25 mm inset per side exactly.
// The four bay edges and separator rails are not scaled with this taper.
rear_outer_inset = 1.25;


/* [Mounting holes] */

// Drawing mounting-hole positions in this project's portrait orientation.
hole_x_left = 7.85;
hole_x_right = 151.85;

hole_z_bottom = 7.855;
hole_z_middle = 159.855;
hole_z_top = 311.855;

hole_diameter = 3.00;

// Mounting geometry.
// Each mounting point consists only of a Ø3.00 mm screw hole inside a
// cylindrical Ø8.50 mm tube. The larger circular reinforcement discs visible
// in the STEP model are separate features at different positions and are NOT
// concentric with these screw holes. They are therefore intentionally not
// modelled as part of the mounting tube.
mounting_tube_outer_diameter = 8.50;
mounting_tube_protrusion = 0.50;

// Keep the rear end of the mounting tube visibly circular. The surrounding
// frame is recessed locally by this radial clearance; this is only a relief
// around the Ø8.50 mm tube, not a separate reinforcement disc.
mounting_tube_relief_clearance = 0.75;
mounting_tube_relief_depth = 0.80;

// Separate circular reinforcement bushings visible on the rear frame.
// These are NOT concentric with the Ø3 / Ø8.5 mounting tubes.
// They sit beside each mounting point along the long side rails.
//
// Geometry is modelled as a flush circular reinforcement feature:
//   1. Ø14 outer face remains flush with the nominal rear mounting plane
//   2. the Ø14 cylindrical bushing continues inward into the panel/bay
//   3. the Ø10 centre is recessed 2.50 mm below the outside plane
//   4. a Ø2.50 hole continues 10 mm inward from the recess floor
//
// The Ø14 and Ø2.5 values are based on the current physical estimate.
reinforcement_bushing_outer_diameter = 14.0;
reinforcement_bushing_inner_diameter = 10.0;
reinforcement_bushing_protrusion = 0.00;
reinforcement_bushing_inner_recess = 2.50;
reinforcement_bushing_hole_diameter = 2.50;
reinforcement_bushing_hole_depth = 10.00;
// The Ø14 bushing is flush on the rear/outside face, but continues inward
// through the rear housing.  Its inner depth is derived from the recess +
// hole depth so the cylindrical boss remains present inside the bay instead
// of being clipped by the bay opening.
reinforcement_bushing_inner_depth =
    reinforcement_bushing_inner_recess + reinforcement_bushing_hole_depth;
reinforcement_disc_offset = 11.0;


/* [Locator pins] */

// Two diagonal locating pins dimensioned in the supplied PDF.
// In the original landscape drawing their centres are 110 mm horizontally
// and 75 mm vertically from panel centre. In this portrait model the
// landscape X axis maps to -Z and landscape Y maps to +X.
locator_pin_diameter = 3.00;
locator_pin_protrusion = 3.00;
locator_pin_landscape_x_offset = 110.00;
locator_pin_landscape_y_offset = 75.00;


/* [Rear frame] */

// Main frame widths. These remain STEP/photo approximations rather than
// dimensions claimed from the 2D drawing.
rear_frame_side_width_reference = 12.5;
// STEP-derived bay-edge widths. The normal top/bottom bay rail is 10.75 mm
// wide; through the central relief it narrows to 7.75 mm.
rear_frame_end_width_reference = 10.75;
rear_frame_end_narrow_width_reference = 7.75;

// Length of the narrow central section along the bay edge. The 3 mm
// transitions are 45 degrees because the rail narrows by exactly 3 mm.
rear_frame_end_narrow_length_reference = 30.0;
// The three middle ribs are 20 mm at their full width. Because the
// 3 mm bay-edge relief is cut from both adjacent bays, the central
// stepped section becomes 14 mm wide (20 - 3 - 3).
rear_frame_crossbar_width_reference = 20.0;

// Three separators create the four large electronics bays.
rear_crossbar_1_reference = 80.0;
rear_crossbar_2_reference = 160.0;
rear_crossbar_3_reference = 240.0;

// Rounded inner corners visible in both STEP render and real rear photo.
rear_opening_corner_radius_reference = 5.0;

// Shallow recessed strips inside the otherwise smooth rails. These are visual
// STEP-based approximations rather than dimensions taken from the 2D drawing.
rear_side_recess_margin_reference = 2.0;
rear_end_recess_margin_reference = 2.0;
rear_crossbar_recess_margin_reference = 1.5;
rear_recess_corner_radius_reference = 0.8;

// No separate widening/pad is added to the three middle ribs.
// Their stepped contour is produced only by the adjacent bay-edge reliefs,
// matching the STEP profile without an invented octagonal reinforcement.



/* [HUB75 connectors] */

// IDC connector centres are defined symmetrically from the physical panel
// centre.  The reference-space offset below is chosen so the default
// 319.71 mm panel resolves to exactly +/-113.5 mm from its centre.
data_connector_x_reference = reference_width / 2;
data_connector_center_offset_reference = 113.5 * reference_height / panel_height;
data_connector_z_bottom_reference = reference_height/2 - data_connector_center_offset_reference;
data_connector_z_top_reference = reference_height/2 + data_connector_center_offset_reference;

data_connector_width_reference = 27.90 * reference_width / panel_width;
data_connector_height_reference = 9.50 * reference_height / panel_height;

data_connector_depth = 10.64;
data_connector_front_y = 2.63;


/* [Power connector] */

// Visual approximation. In the rear-view portrait orientation used here,
// the source photo places POWER in bay 3 (counted from top to bottom).
// The drawing does not dimension the connector itself.
power_connector_x_reference = 53.0;
power_connector_z_reference = 128.0;
power_connector_width = 13.0;
power_connector_height = 20.0;
power_connector_depth = 7.0;


/* [Standalone preview] */

preview_show_orientation = true;
preview_show_connectors = true;
preview_show_rear_recess = true;

// Red dimensional verification overlay based on the supplied PDF drawing.
// Turn this on only while checking the model; it is disabled by default.
preview_show_pdf_verification_grid = false;

// Light grey is easier to inspect than the original black housing.
preview_color_scheme = "light_gray"; // [light_gray, original]

preview_body_light_gray = [0.72, 0.72, 0.72, 1];
preview_web_light_gray = [0.48, 0.48, 0.48, 1];
preview_front_light_gray = [0.52, 0.52, 0.52, 1];

preview_body_original = [0.08, 0.10, 0.09, 1];
preview_web_original = [0.045, 0.055, 0.050, 1];
preview_front_original = [0.015, 0.015, 0.015, 1];

preview_pcb_color = [0.02, 0.20, 0.07, 1];
preview_connector_color = [0.06, 0.06, 0.06, 1];


/* [Resolution] */

$fn = 48;


// -----------------------------------------------------------------------------
// Helper functions
// -----------------------------------------------------------------------------

function scale_x(value, width, reference_width) =
    value * width / reference_width;

function scale_z(value, height, reference_height) =
    value * height / reference_height;

function preview_body_color(scheme) =
    scheme == "light_gray"
        ? preview_body_light_gray
        : preview_body_original;

function preview_web_color(scheme) =
    scheme == "light_gray"
        ? preview_web_light_gray
        : preview_web_original;

function preview_front_color(scheme) =
    scheme == "light_gray"
        ? preview_front_light_gray
        : preview_front_original;


// -----------------------------------------------------------------------------
// Shared rear-frame dimensions for mating components
// -----------------------------------------------------------------------------
// Keep couplers and other printed parts tied to the actual HUB75 panel model
// instead of duplicating these dimensions in their own source files.
// Public component specification API.
// Assemblies and other components must use these functions instead of
// duplicating physical HUB75 dimensions in project_config.scad.
function hub75_panel_width() = panel_width;
function hub75_panel_height() = panel_height;
function hub75_panel_depth() = panel_depth;
function hub75_panel_nominal_width() = reference_width;
function hub75_panel_nominal_height() = reference_height;
function hub75_panel_mounting_plane_y() = mounting_plane_y;
function hub75_panel_hole_diameter() = hole_diameter;
function hub75_panel_hole_x_left() = hole_x_left;
function hub75_panel_hole_x_right() = hole_x_right;
function hub75_panel_hole_z_bottom() = hole_z_bottom;
function hub75_panel_hole_z_middle() = hole_z_middle;
function hub75_panel_hole_z_top() = hole_z_top;
function hub75_panel_hole_x_positions() = [hole_x_left, hole_x_right];
function hub75_panel_hole_z_positions() = [hole_z_bottom, hole_z_middle, hole_z_top];

// Centred physical mounting coordinates.  Use these whenever project geometry
// is referenced to the nominal 160 x 320 mm placement grid.  The drawing
// coordinates above are measured from the physical panel edge and therefore
// must not be mixed directly with nominal-grid coordinates.
function hub75_panel_hole_x_left_centered() = hole_x_left - panel_width/2;
function hub75_panel_hole_x_right_centered() = hole_x_right - panel_width/2;
function hub75_panel_hole_z_bottom_centered() = hole_z_bottom - panel_height/2;
function hub75_panel_hole_z_middle_centered() = hole_z_middle - panel_height/2;
function hub75_panel_hole_z_top_centered() = hole_z_top - panel_height/2;

// Physical panel undersize relative to the exact nominal placement cell.
// In this portrait model the original 320 x 160 landscape grid becomes
// X = 160 mm and Z = 320 mm.
function hub75_panel_grid_gap_x() = reference_width - panel_width;
function hub75_panel_grid_gap_z() = reference_height - panel_height;
function hub75_panel_grid_margin_x() = hub75_panel_grid_gap_x()/2;
function hub75_panel_grid_margin_z() = hub75_panel_grid_gap_z()/2;

// The rear housing is tapered inward by the STEP-derived 1.25 mm reference
// inset on every side.  Coupler seam locators sit at the REAR mounting plane,
// so their available gap is larger than the 0.30 mm front/body grid gap.
function hub75_rear_outer_inset_x() = rear_outer_inset * panel_width / reference_width;
function hub75_rear_outer_inset_z() = rear_outer_inset * panel_height / reference_height;
function hub75_panel_rear_grid_gap_x() =
    reference_width - (panel_width - 2*hub75_rear_outer_inset_x());
function hub75_panel_rear_grid_gap_z() =
    reference_height - (panel_height - 2*hub75_rear_outer_inset_z());
function hub75_panel_mounting_tube_outer_diameter() = mounting_tube_outer_diameter;
function hub75_panel_data_connector_x() = panel_width/2;
function hub75_panel_data_connector_center_offset() = 113.5;
function hub75_panel_data_connector_z_bottom() = panel_height/2 - hub75_panel_data_connector_center_offset();
function hub75_panel_data_connector_z_top() = panel_height/2 + hub75_panel_data_connector_center_offset();
function hub75_panel_data_connector_width() = 27.90;
function hub75_panel_data_connector_height() = 9.50;
function hub75_panel_data_connector_depth() = data_connector_depth;
function hub75_panel_data_connector_front_y() = data_connector_front_y;
function hub75_panel_boss_outer_diameter() = reinforcement_bushing_outer_diameter;

function hub75_rear_side_rail_width() = rear_frame_side_width_reference;
function hub75_rear_end_rail_width() = rear_frame_end_width_reference;
function hub75_rear_middle_rib_width() = rear_frame_crossbar_width_reference;
function hub75_rear_opening_corner_radius() = rear_opening_corner_radius_reference;

// Effective dimensions at the actual rear mounting plane. The outside housing
// tapers inward while the electronics-bay openings remain vertical. Therefore
// the mating side/end rails are narrower at the rear face than their nominal
// STEP reference widths. Coupler fit geometry must use these dimensions.
function hub75_rear_side_rail_width_at_mounting_plane() =
    max(0, rear_frame_side_width_reference - hub75_rear_outer_inset_x());
function hub75_rear_end_rail_width_at_mounting_plane() =
    max(0, rear_frame_end_width_reference - hub75_rear_outer_inset_z());
function hub75_rear_end_narrow_width_at_mounting_plane() =
    max(0, rear_frame_end_narrow_width_reference - hub75_rear_outer_inset_z());
function hub75_reinforcement_bushing_outer_diameter() = reinforcement_bushing_outer_diameter;
function hub75_reinforcement_bushing_recess_diameter() = reinforcement_bushing_inner_diameter;
function hub75_reinforcement_bushing_hole_diameter() = reinforcement_bushing_hole_diameter;
function hub75_reinforcement_bushing_protrusion() = reinforcement_bushing_protrusion;
function hub75_reinforcement_bushing_recess_depth() = reinforcement_bushing_inner_recess;
function hub75_reinforcement_bushing_hole_depth() = reinforcement_bushing_hole_depth;
function hub75_reinforcement_bushing_inner_depth() = reinforcement_bushing_inner_depth;
function hub75_reinforcement_bushing_offset() = reinforcement_disc_offset;

// Locator-pin dimensions exposed for couplers that must clear the two
// PDF-dimensioned Ø3 mm locating pins.  Keep the positional relationships
// derived here so couplers do not duplicate panel geometry.
function hub75_locator_pin_diameter() = locator_pin_diameter;
function hub75_locator_pin_near_edge_screw_x_delta() =
    hole_x_left - (panel_width/2 - locator_pin_landscape_y_offset);
function hub75_locator_pin_edge_screw_z_delta() =
    panel_height/2 - locator_pin_landscape_x_offset - hole_z_bottom;

// -----------------------------------------------------------------------------
// Geometry
// -----------------------------------------------------------------------------

module hub75_panel(
    width = panel_width,
    height = panel_height,

    reference_width_value = reference_width,
    reference_height_value = reference_height,

    front_mask_depth_value = front_mask_depth,
    pcb_thickness_value = pcb_thickness,
    mounting_plane_y_value = mounting_plane_y,
    max_depth_value = max_depth,
    rear_recess_depth_value = rear_recess_depth,
    rear_outer_inset_value = rear_outer_inset,

    hole_x_left_value = hole_x_left,
    hole_x_right_value = hole_x_right,

    hole_z_bottom_value = hole_z_bottom,
    hole_z_middle_value = hole_z_middle,
    hole_z_top_value = hole_z_top,

    hole_diameter_value = hole_diameter,
    mounting_tube_outer_diameter_value = mounting_tube_outer_diameter,
    mounting_tube_protrusion_value = mounting_tube_protrusion,
    mounting_tube_relief_clearance_value = mounting_tube_relief_clearance,
    mounting_tube_relief_depth_value = mounting_tube_relief_depth,
    reinforcement_bushing_outer_diameter_value = reinforcement_bushing_outer_diameter,
    reinforcement_bushing_inner_diameter_value = reinforcement_bushing_inner_diameter,
    reinforcement_bushing_protrusion_value = reinforcement_bushing_protrusion,
    reinforcement_bushing_inner_recess_value = reinforcement_bushing_inner_recess,
    reinforcement_bushing_hole_diameter_value = reinforcement_bushing_hole_diameter,
    reinforcement_bushing_hole_depth_value = reinforcement_bushing_hole_depth,
    reinforcement_disc_offset_value = reinforcement_disc_offset,

    locator_pin_diameter_value = locator_pin_diameter,
    locator_pin_protrusion_value = locator_pin_protrusion,
    locator_pin_landscape_x_offset_value = locator_pin_landscape_x_offset,
    locator_pin_landscape_y_offset_value = locator_pin_landscape_y_offset,

    rear_frame_side_width_ref = rear_frame_side_width_reference,
    rear_frame_end_width_ref = rear_frame_end_width_reference,
    rear_frame_crossbar_width_ref = rear_frame_crossbar_width_reference,
    rear_frame_end_narrow_width_ref = rear_frame_end_narrow_width_reference,
    rear_frame_end_narrow_length_ref = rear_frame_end_narrow_length_reference,

    rear_crossbar_1_ref = rear_crossbar_1_reference,
    rear_crossbar_2_ref = rear_crossbar_2_reference,
    rear_crossbar_3_ref = rear_crossbar_3_reference,

    rear_opening_corner_radius_ref = rear_opening_corner_radius_reference,
    rear_side_recess_margin_ref = rear_side_recess_margin_reference,
    rear_end_recess_margin_ref = rear_end_recess_margin_reference,
    rear_crossbar_recess_margin_ref = rear_crossbar_recess_margin_reference,
    rear_recess_corner_radius_ref = rear_recess_corner_radius_reference,

    data_connector_x_ref = data_connector_x_reference,
    data_connector_z_bottom_ref = data_connector_z_bottom_reference,
    data_connector_z_top_ref = data_connector_z_top_reference,
    data_connector_width_ref = data_connector_width_reference,
    data_connector_height_ref = data_connector_height_reference,
    data_connector_depth_value = data_connector_depth,
    data_connector_front_y_value = data_connector_front_y,

    power_connector_x_ref = power_connector_x_reference,
    power_connector_z_ref = power_connector_z_reference,
    power_connector_width_value = power_connector_width,
    power_connector_height_value = power_connector_height,
    power_connector_depth_value = power_connector_depth,

    show_orientation = true,
    show_connectors = true,
    show_front_layers = true,
    show_rear_recess = true,
    show_pdf_verification_grid = false,

    body_color = preview_body_original,
    web_color = preview_web_original,
    front_color = preview_front_original,
    pcb_color = preview_pcb_color,
    connector_color = preview_connector_color
) {
    // Mounting-hole positions are direct drawing dimensions.
    // They are intentionally NOT scaled from the STEP reference.
    hole_x_positions = [
        hole_x_left_value,
        hole_x_right_value
    ];

    hole_z_positions = [
        hole_z_bottom_value,
        hole_z_middle_value,
        hole_z_top_value
    ];

    // Separate reinforcement bushings beside the mounting tubes.
    // Portrait orientation is taken from the real rear-panel photo: landscape
    // X maps to decreasing portrait Z. This fixes the asymmetric middle pair:
    // the left middle bushing is above its mounting tube and the right middle
    // bushing is below it. The corner pairs remain inward along the long rail.
    reinforcement_bushing_positions = [
        [hole_x_left_value,  hole_z_bottom_value + reinforcement_disc_offset_value],
        [hole_x_right_value, hole_z_bottom_value + reinforcement_disc_offset_value],

        [hole_x_left_value,  hole_z_middle_value + reinforcement_disc_offset_value],
        [hole_x_right_value, hole_z_middle_value - reinforcement_disc_offset_value],

        [hole_x_left_value,  hole_z_top_value - reinforcement_disc_offset_value],
        [hole_x_right_value, hole_z_top_value - reinforcement_disc_offset_value]
    ];

    // PDF locating-pin centres. In this portrait rear-view orientation the
    // diagonal pair is upper-left and lower-right relative to panel centre.
    locator_pin_positions = [
        [width/2 - locator_pin_landscape_y_offset_value,
         height/2 + locator_pin_landscape_x_offset_value],
        [width/2 + locator_pin_landscape_y_offset_value,
         height/2 - locator_pin_landscape_x_offset_value]
    ];

    pcb_back_y =
        front_mask_depth_value
        + pcb_thickness_value;

    rear_frame_start_y = pcb_back_y;

    rear_frame_depth =
        mounting_plane_y_value
        - rear_frame_start_y;

    rear_recess_depth_actual =
        min(
            rear_recess_depth_value,
            rear_frame_depth
        );

    rear_outer_inset_actual =
        min(
            rear_outer_inset_value,
            min(width, height)/2 - 0.1
        );

    rear_frame_side_width =
        scale_x(
            rear_frame_side_width_ref,
            width,
            reference_width_value
        );

    rear_frame_end_width =
        scale_z(
            rear_frame_end_width_ref,
            height,
            reference_height_value
        );

    rear_frame_crossbar_width =
        scale_z(
            rear_frame_crossbar_width_ref,
            height,
            reference_height_value
        );

    rear_frame_end_narrow_width =
        scale_z(
            rear_frame_end_narrow_width_ref,
            height,
            reference_height_value
        );

    rear_frame_end_narrow_length =
        scale_x(
            rear_frame_end_narrow_length_ref,
            width,
            reference_width_value
        );

    rear_frame_end_step_depth =
        max(0, rear_frame_end_width - rear_frame_end_narrow_width);

    rear_opening_corner_radius =
        min(
            scale_x(
                rear_opening_corner_radius_ref,
                width,
                reference_width_value
            ),
            scale_z(
                rear_opening_corner_radius_ref,
                height,
                reference_height_value
            )
        );

    rear_side_recess_margin =
        scale_x(
            rear_side_recess_margin_ref,
            width,
            reference_width_value
        );

    rear_end_recess_margin =
        scale_z(
            rear_end_recess_margin_ref,
            height,
            reference_height_value
        );

    rear_crossbar_recess_margin =
        scale_z(
            rear_crossbar_recess_margin_ref,
            height,
            reference_height_value
        );

    rear_recess_corner_radius =
        min(
            scale_x(
                rear_recess_corner_radius_ref,
                width,
                reference_width_value
            ),
            scale_z(
                rear_recess_corner_radius_ref,
                height,
                reference_height_value
            )
        );

    rear_crossbar_z = [
        scale_z(
            rear_crossbar_1_ref,
            height,
            reference_height_value
        ),
        scale_z(
            rear_crossbar_2_ref,
            height,
            reference_height_value
        ),
        scale_z(
            rear_crossbar_3_ref,
            height,
            reference_height_value
        )
    ];

    // Four rear bay limits in portrait orientation.
    opening_z_min = [
        rear_frame_end_width,
        rear_crossbar_z[0] + rear_frame_crossbar_width/2,
        rear_crossbar_z[1] + rear_frame_crossbar_width/2,
        rear_crossbar_z[2] + rear_frame_crossbar_width/2
    ];

    opening_z_max = [
        rear_crossbar_z[0] - rear_frame_crossbar_width/2,
        rear_crossbar_z[1] - rear_frame_crossbar_width/2,
        rear_crossbar_z[2] - rear_frame_crossbar_width/2,
        height - rear_frame_end_width
    ];

    data_connector_x =
        scale_x(
            data_connector_x_ref,
            width,
            reference_width_value
        );

    data_connector_z_bottom =
        scale_z(
            data_connector_z_bottom_ref,
            height,
            reference_height_value
        );

    data_connector_z_top =
        scale_z(
            data_connector_z_top_ref,
            height,
            reference_height_value
        );

    data_connector_width =
        scale_x(
            data_connector_width_ref,
            width,
            reference_width_value
        );

    data_connector_height =
        scale_z(
            data_connector_height_ref,
            height,
            reference_height_value
        );

    // Approximate position from the supplied rear photograph: third bay in
    // landscape orientation. It is intentionally kept as a reference value
    // because the dimensional drawing does not locate this connector.
    power_connector_x =
        scale_x(
            power_connector_x_ref,
            width,
            reference_width_value
        );

    power_connector_z =
        scale_z(
            power_connector_z_ref,
            height,
            reference_height_value
        );


    // -------------------------------------------------------------------------
    // 2D helpers for the X/Z rear-frame profile
    // -------------------------------------------------------------------------

    module rounded_rect_2d(x, z, w, h, r) {
        rr = min(r, min(w, h)/2 - 0.01);

        translate([x + rr, z + rr])
            offset(r=rr)
                square([
                    max(0.02, w - 2*rr),
                    max(0.02, h - 2*rr)
                ]);
    }


    // Central relief in the top and bottom edge of each electronics bay.
    // The STEP does not use a constant straight rail here: the normal rail
    // width is 10.75 mm and locally narrows to 7.75 mm.  The 3 mm change is
    // connected with 45-degree transitions.
    module bay_end_relief_2d(z_edge, direction=1) {
        d = rear_frame_end_step_depth;
        half_narrow = rear_frame_end_narrow_length/2;
        cx = width/2;

        if(d > 0)
            polygon([
                [cx-half_narrow-d, z_edge],
                [cx-half_narrow,   z_edge + direction*d],
                [cx+half_narrow,   z_edge + direction*d],
                [cx+half_narrow+d, z_edge]
            ]);
    }


    module rear_openings_2d() {
        for(i=[0:3])
            let(
                z0 = opening_z_min[i],
                z1 = opening_z_max[i],
                opening_h = z1 - z0
            )
                union() {
                    rounded_rect_2d(
                        rear_frame_side_width,
                        z0,
                        width - 2*rear_frame_side_width,
                        opening_h,
                        rear_opening_corner_radius
                    );

                    // Extend the opening locally into both adjacent rails.
                    bay_end_relief_2d(z0, -1);
                    bay_end_relief_2d(z1,  1);
                }
    }


    module rear_frame_web_2d(outer_inset=0) {
        difference() {
            translate([outer_inset, outer_inset])
                square([
                    width - 2*outer_inset,
                    height - 2*outer_inset
                ]);

            rear_openings_2d();
        }
    }

    module rear_frame_body_2d() {
        rear_frame_web_2d();
    }


    module reinforcement_bushing_footprints_2d() {
        // Footprints of the six separate Ø14 mm reinforcement bushings.
        // These are used only to prevent the shallow rail recess from cutting
        // through the bushing base. The 3D stepped bushing is added later.
        for(pos=reinforcement_bushing_positions)
            translate([pos[0], pos[1]])
                circle(d=reinforcement_bushing_outer_diameter_value, $fn=64);
    }


    module rear_recess_2d() {
        side_margin = rear_side_recess_margin;
        end_margin = rear_end_recess_margin;
        cross_margin = rear_crossbar_recess_margin;
        r = rear_recess_corner_radius;
        outer_inset = rear_outer_inset_actual;

        // Build the recessed strips, then keep the reinforcement circles at
        // the original rear-face level by excluding them from the recess cut.
        difference() {
            union() {
                // On the rear face the outer rail starts at the STEP-derived inset.
                side_recess_w =
                    rear_frame_side_width
                    - outer_inset
                    - 2*side_margin;

                side_recess_h =
                    height
                    - 2*(rear_frame_end_width);

                if(side_recess_w > 0 && side_recess_h > 0) {
                    rounded_rect_2d(
                        outer_inset + side_margin,
                        rear_frame_end_width,
                        side_recess_w,
                        side_recess_h,
                        r
                    );

                    rounded_rect_2d(
                        width
                            - rear_frame_side_width
                            + side_margin,
                        rear_frame_end_width,
                        side_recess_w,
                        side_recess_h,
                        r
                    );
                }

                end_recess_h =
                    rear_frame_end_width
                    - outer_inset
                    - 2*end_margin;

                end_recess_w =
                    width
                    - 2*rear_frame_side_width;

                if(end_recess_w > 0 && end_recess_h > 0) {
                    rounded_rect_2d(
                        rear_frame_side_width,
                        outer_inset + end_margin,
                        end_recess_w,
                        end_recess_h,
                        r
                    );

                    rounded_rect_2d(
                        rear_frame_side_width,
                        height
                            - rear_frame_end_width
                            + end_margin,
                        end_recess_w,
                        end_recess_h,
                        r
                    );
                }

                // Middle-rib recesses must follow the stepped rail contour.
                // Build each recess from the ACTUAL rib profile and inset that
                // profile by cross_margin. This keeps a constant raised border
                // around the 20 -> 14 -> 20 mm transitions instead of cutting a
                // straight rectangular strip through the narrowed section.
                if(end_recess_w > 0 && cross_margin > 0)
                    for(zc=rear_crossbar_z)
                        offset(delta=-cross_margin)
                            intersection() {
                                rear_frame_web_2d();
                                translate([
                                    rear_frame_side_width,
                                    zc - rear_frame_crossbar_width/2
                                ])
                                    square([
                                        width - 2*rear_frame_side_width,
                                        rear_frame_crossbar_width
                                    ]);
                            }
            }

            reinforcement_bushing_footprints_2d();
        }
    }

    module rear_extrude_from_to(y0, y1) {
        depth = max(0, y1 - y0);

        if(depth > 0)
            translate([0, y1, 0])
                rotate([90, 0, 0])
                    linear_extrude(
                        height=depth,
                        convexity=8
                    )
                        children();
    }


    // Tapered outer envelope in X/Z, extruded along Y.
    // STEP relation: 1.25 mm inset per side between the full-size front of
    // the rear housing and its rear perimeter face (2.50 mm smaller overall).
    // Only the external perimeter changes. The four rear bay openings are
    // subtracted separately, so their edges and the three separator rails do
    // not get scaled or shifted by the taper.
    module tapered_outer_blank(y0, y1, inset0, inset1) {
        x0a = inset0;
        x1a = width - inset0;
        z0a = inset0;
        z1a = height - inset0;

        x0b = inset1;
        x1b = width - inset1;
        z0b = inset1;
        z1b = height - inset1;

        polyhedron(
            points=[
                [x0a, y0, z0a],
                [x1a, y0, z0a],
                [x1a, y0, z1a],
                [x0a, y0, z1a],
                [x0b, y1, z0b],
                [x1b, y1, z0b],
                [x1b, y1, z1b],
                [x0b, y1, z1b]
            ],
            faces=[
                [0,3,2,1],
                [4,5,6,7],
                [0,1,5,4],
                [1,2,6,5],
                [2,3,7,6],
                [3,0,4,7]
            ],
            convexity=8
        );
    }


    module rear_frame_core_3d() {
        difference() {
            // The full outside wall tapers continuously from the 2.0 mm
            // rear-housing start to the rear mounting plane. There is no
            // artificial short chamfer followed by a straight wall.
            tapered_outer_blank(
                rear_frame_start_y,
                mounting_plane_y_value,
                0,
                rear_outer_inset_actual
            );

            // Keep the bay walls vertical, as in the STEP model.
            rear_extrude_from_to(
                rear_frame_start_y - 0.05,
                mounting_plane_y_value + 0.05
            )
                rear_openings_2d();
        }
    }


    module reinforcement_bushing_solids() {
        // True Ø14 cylindrical bushings.  Their rear/outside face ends exactly
        // at the nominal mounting plane, while the cylinder continues inward
        // into the panel.  Adding these before the recess/hole cuts prevents
        // the bay-opening subtraction from clipping away the inner half of the
        // bushing.
        for(pos=reinforcement_bushing_positions)
            translate([
                pos[0],
                mounting_plane_y_value - reinforcement_bushing_inner_depth,
                pos[1]
            ])
                rotate([-90, 0, 0])
                    cylinder(
                        h=reinforcement_bushing_inner_depth,
                        d=reinforcement_bushing_outer_diameter_value,
                        $fn=64
                    );
    }


    module reinforcement_bushing_cuts() {
        // The Ø14 reinforcement feature is NOT an added boss. The rear rail
        // itself remains flush at the nominal mounting plane because its Ø14
        // footprint is excluded from rear_recess_2d(). Only the inner recess
        // and blind hole are cut from that retained rail material here.
        for(pos=reinforcement_bushing_positions) {
            // Ø10 recess, 2.5 mm deep from the rear mounting plane.
            translate([
                pos[0],
                mounting_plane_y_value - reinforcement_bushing_inner_recess_value,
                pos[1]
            ])
                rotate([-90, 0, 0])
                    cylinder(
                        h=reinforcement_bushing_inner_recess_value + 0.02,
                        d=reinforcement_bushing_inner_diameter_value,
                        $fn=64
                    );

            // Ø2.5 blind hole, 10 mm deeper from the recess floor.
            translate([
                pos[0],
                mounting_plane_y_value
                    - reinforcement_bushing_inner_recess_value
                    - reinforcement_bushing_hole_depth_value,
                pos[1]
            ])
                rotate([-90, 0, 0])
                    cylinder(
                        h=reinforcement_bushing_hole_depth_value + 0.02,
                        d=reinforcement_bushing_hole_diameter_value,
                        $fn=48
                    );
        }
    }


    module locator_pin(x, z) {
        // Solid Ø3 mm locating pin standing 3 mm proud of the nominal rear
        // mounting plane. Diameter and X/Z location come from the PDF; the
        // 3 mm protrusion is the measured physical value.
        color(body_color)
            translate([x, mounting_plane_y_value, z])
                rotate([-90, 0, 0])
                    cylinder(
                        h=locator_pin_protrusion_value,
                        d=locator_pin_diameter_value,
                        $fn=48
                    );
    }


    module mounting_tube(x, z) {
        // A mounting point is a simple cylindrical tube around the Ø3 mm
        // screw hole. Do not merge the separate STEP reinforcement discs into
        // this feature.
        difference() {
            color(body_color)
                translate([
                    x,
                    rear_frame_start_y,
                    z
                ])
                    rotate([-90, 0, 0])
                        cylinder(
                            h=
                                mounting_plane_y_value
                                - rear_frame_start_y
                                + mounting_tube_protrusion_value,
                            d=mounting_tube_outer_diameter_value,
                            $fn=64
                        );

            translate([
                x,
                -0.2,
                z
            ])
                rotate([-90, 0, 0])
                    cylinder(
                        h=mounting_plane_y_value + mounting_tube_protrusion_value + 0.5,
                        d=hole_diameter_value,
                        $fn=40
                    );
        }
    }


    module rear_frame_structure() {
        // Smooth frame body up to the mounting plane. The rear-facing strips
        // are recessed slightly, leaving a raised border around each rail.
        //
        // A shallow circular relief is ALWAYS cut around each mounting tube.
        // Without this, the Ø8.50 mm cylinder merges flush into the rectangular
        // frame and its rear outline appears square. The tube itself remains a
        // true cylinder.
        color(body_color)
            difference() {
                union() {
                    rear_frame_core_3d();
                    reinforcement_bushing_solids();
                }

                if(show_rear_recess && rear_recess_depth_actual > 0)
                    rear_extrude_from_to(
                        mounting_plane_y_value
                            - rear_recess_depth_actual,
                        mounting_plane_y_value + 0.05
                    )
                        rear_recess_2d();

                if(mounting_tube_relief_depth_value > 0
                   && mounting_tube_relief_clearance_value > 0)
                    rear_extrude_from_to(
                        mounting_plane_y_value
                            - mounting_tube_relief_depth_value,
                        mounting_plane_y_value + 0.05
                    )
                        for(x=hole_x_positions)
                            for(z=hole_z_positions)
                                translate([x, z])
                                    circle(
                                        d=mounting_tube_outer_diameter_value
                                            + 2*mounting_tube_relief_clearance_value,
                                        $fn=64
                                    );

                // Recess and blind-hole cuts for the flush reinforcement rings.
                reinforcement_bushing_cuts();
            }

        // Add the Ø8.50 mm cylindrical tubes back after the relief cut. Their
        // rear faces therefore stand proud of the local recess and read as
        // round, including at the corner mounting positions.
        for(x=hole_x_positions)
            for(z=hole_z_positions)
                mounting_tube(x, z);

        // Two PDF-dimensioned locating pins are added last so they remain
        // fully proud of the recessed rail surface.
        for(pos=locator_pin_positions)
            locator_pin(pos[0], pos[1]);
    }


    module hub75_data_connector(z) {
        color(connector_color)
            translate([
                data_connector_x
                    - data_connector_width/2,
                data_connector_front_y_value,
                z
                    - data_connector_height/2
            ])
                cube([
                    data_connector_width,
                    data_connector_depth_value,
                    data_connector_height
                ]);

        // Visual opening on the rear-facing side.
        color([0.015, 0.015, 0.015, 1])
            translate([
                data_connector_x
                    - data_connector_width*0.39,
                data_connector_front_y_value
                    + data_connector_depth_value
                    - 0.4,
                z
                    - data_connector_height*0.31
            ])
                cube([
                    data_connector_width*0.78,
                    0.8,
                    data_connector_height*0.62
                ]);
    }


    module pcb_arrow(x, z, direction = "down", arrow_scale = 0.55) {
        // Simple rear-PCB orientation marker. These arrows are included because
        // they make the portrait rotation of the real panel unambiguous.
        // They are visual reference features, not dimensional geometry.
        rot_y =
            direction == "down"  ? 0 :
            direction == "up"    ? 180 :
            direction == "left"  ? -90 :
            direction == "right" ? 90 : 0;

        color([0.85, 0.85, 0.85, 1])
            translate([
                x,
                mounting_plane_y_value + 0.01,
                z
            ])
                rotate([90, rot_y, 0])
                    linear_extrude(height=0.35)
                        scale([arrow_scale, arrow_scale])
                            polygon([
                                [-4, 18],
                                [ 4, 18],
                                [ 4, -5],
                                [10, -5],
                                [ 0, -18],
                                [-10, -5],
                                [-4, -5]
                            ]);
    }


    module orientation_arrows() {
        // Rear-view portrait orientation, bays counted from top to bottom:
        // bay 1: downward arrow beside the connector
        // bay 2: right-pointing arrow at the right side
        // bay 3: no arrow
        // bay 4: downward arrow toward the power connector + right-pointing arrow

        // Bay 1 (top): down arrow beside the HUB75 connector.
        pcb_arrow(
            min(width - 28, data_connector_x + 38),
            data_connector_z_top,
            "down",
            0.42
        );

        // Bay 2: right arrow close to the VISUAL right side in rear view.
        // Rear viewing reverses the X direction on screen, so this uses the low-X side.
        pcb_arrow(
            20,
            (opening_z_min[2] + opening_z_max[2]) / 2,
            "right",
            0.50
        );

        // Bay 3 intentionally has no orientation arrow. The POWER connector
        // itself is in this bay.

        // Bay 4 (bottom): down arrow aligned in X with the bay-1 down arrow.
        pcb_arrow(
            min(width - 28, data_connector_x + 38),
            (opening_z_min[0] + opening_z_max[0]) / 2,
            "down",
            0.42
        );

        // Bay 4: right arrow close to the VISUAL right side, like the bay-2 marker.
        pcb_arrow(
            20,
            (opening_z_min[0] + opening_z_max[0]) / 2,
            "right",
            0.50
        );
    }


    module power_connector_model() {
        color([0.05, 0.05, 0.05, 1])
            translate([
                power_connector_x
                    - power_connector_width_value/2,
                pcb_back_y + 1.0,
                power_connector_z
                    - power_connector_height_value/2
            ])
                cube([
                    power_connector_width_value,
                    power_connector_depth_value,
                    power_connector_height_value
                ]);

        for(pz=[-7.5, -2.5, 2.5, 7.5])
            color([0.45, 0.45, 0.42, 1])
                translate([
                    power_connector_x - 2.75,
                    pcb_back_y
                        + power_connector_depth_value
                        + 1.1,
                    power_connector_z
                        + pz
                        - 1.2
                ])
                    cube([
                        5.5,
                        0.7,
                        2.4
                    ]);
    }


    // -------------------------------------------------------------------------
    // PDF verification overlay
    // -------------------------------------------------------------------------

    module pdf_verification_grid() {
        // Red construction raster derived only from dimensions that are explicit
        // in the supplied PDF / mounting-hole layout:
        //   overall envelope : 159.70 x 319.71 mm in this portrait orientation
        //   mounting columns : 72 mm either side of panel centre
        //   mounting rows    : 152 mm either side of centre, plus centre row
        //
        // The overlay deliberately does not encode STEP-only rear-frame details.
        // It sits just behind the rearmost physical features so it remains
        // visible as a pure visual verification aid.
        grid_y = max(
            max(
                mounting_plane_y_value + mounting_tube_protrusion_value,
                mounting_plane_y_value + reinforcement_bushing_protrusion_value
            ),
            mounting_plane_y_value + locator_pin_protrusion_value
        ) + 0.35;
        line_w = 0.35;
        line_d = 0.12;
        target_d = 2.0;
        target_ring = 0.30;

        module hline(z, w=width) {
            translate([0, grid_y, z-line_w/2])
                color([1,0,0,0.85])
                    cube([w, line_d, line_w]);
        }

        module vline(x, h=height) {
            translate([x-line_w/2, grid_y, 0])
                color([1,0,0,0.85])
                    cube([line_w, line_d, h]);
        }

        module target(x,z) {
            color([1,0,0,0.95])
                translate([x, grid_y + line_d/2, z])
                    rotate([-90,0,0])
                        difference() {
                            cylinder(h=line_d, d=target_d, $fn=48);
                            translate([0,0,-0.01])
                                cylinder(h=line_d+0.02, d=max(0.1,target_d-2*target_ring), $fn=48);
                        }
        }

        // Overall PDF envelope.
        hline(0);
        hline(height);
        vline(0);
        vline(width);

        // Panel centre axes.
        hline(height/2);
        vline(width/2);

        // PDF mounting-hole centre lines. These resolve, after centring, to
        // approximately X = +/-72 mm and Z = -152 / 0 / +152 mm.
        for(x=hole_x_positions)
            vline(x);

        for(z=hole_z_positions)
            hline(z);

        // Explicit targets at the six PDF mounting centres.
        for(x=hole_x_positions)
            for(z=hole_z_positions)
                target(x,z);

        // The two Ø3 locating-pin centres are also explicitly dimensioned in
        // the PDF: ±110 mm horizontally and ±75 mm vertically in landscape.
        for(pos=locator_pin_positions)
            target(pos[0], pos[1]);
    }


    // Keep all drawing / STEP dimensions above in their convenient
    // lower-left reference system, but expose the complete component centred
    // on X=0 and Z=0. The front face intentionally stays on Y=0.
    translate([-width/2, 0, -height/2])
    union() {
        difference() {
            union() {
            // Front pixel housing and PCB. These can be hidden in diagnostic
            // fit renders so only the rear structural frame remains visible.
            if(show_front_layers) {
                color(front_color)
                    cube([
                        width,
                        front_mask_depth_value,
                        height
                    ]);

                color(pcb_color)
                    translate([
                        0,
                        front_mask_depth_value,
                        0
                    ])
                        cube([
                            width,
                            pcb_thickness_value,
                            height
                        ]);
            }

            // Rear structural housing.
            rear_frame_structure();

            if(show_connectors) {
                hub75_data_connector(
                    data_connector_z_bottom
                );

                hub75_data_connector(
                    data_connector_z_top
                );

                power_connector_model();
            }

            if(show_orientation)
                orientation_arrows();
        }

            // Six mounting holes through the complete model.
            for(x=hole_x_positions)
                for(z=hole_z_positions)
                    translate([
                        x,
                        -0.5,
                        z
                    ])
                        rotate([-90, 0, 0])
                            cylinder(
                                h=max_depth_value + 1.0,
                                d=hole_diameter_value,
                                $fn=30
                            );
        }

        if(show_pdf_verification_grid)
            pdf_verification_grid();
    }
}


// -----------------------------------------------------------------------------
// Standalone preview
// -----------------------------------------------------------------------------

hub75_panel(
    show_orientation=preview_show_orientation,
    show_connectors=preview_show_connectors,
    show_rear_recess=preview_show_rear_recess,
    show_pdf_verification_grid=preview_show_pdf_verification_grid,

    body_color=
        preview_body_color(
            preview_color_scheme
        ),

    web_color=
        preview_web_color(
            preview_color_scheme
        ),

    front_color=
        preview_front_color(
            preview_color_scheme
        ),

    pcb_color=preview_pcb_color,
    connector_color=preview_connector_color
);
