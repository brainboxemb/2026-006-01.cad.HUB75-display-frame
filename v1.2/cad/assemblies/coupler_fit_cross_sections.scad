// HUB75 display frame - V1.2 local XY fit cross-sections
//
// Diagnostic slices through the actual panel/coupler interface.  Unlike the
// older rear-facing crop, these are true XY sections at a fixed Z.  This lets
// us inspect the physical panel edge, seam gap, locator rib and print clearance
// in depth without the horizontal coupler arm hiding the fit.

include <../config/project_config.scad>
use <../components/hub75_panel.scad>
use <../project_components/_lib/coupler_dimensions.scad>
use <panels_assembly.scad>
use <couplers_assembly.scad>

/* [XY fit section] */
fit_xy_slice_thickness = 0.40;
fit_xy_crop_width = 90.0;
fit_xy_y_margin_front = 1.0;
fit_xy_y_margin_rear = 12.0;
fit_xy_inboard_offset = 6.0;

module fit_pair_at_local_seam(screw_row_z=0) {
    translate([
        panel_center_x(0) - seam_x(0),
        panel_front_y(),
        -screw_row_z
    ])
        project_hub75_panel(
            orientation_visible=false,
            show_connectors=false
        );

    translate([
        panel_center_x(1) - seam_x(0),
        panel_front_y(),
        -screw_row_z
    ])
        rotate([0,180,0])
            project_hub75_panel(
                orientation_visible=false,
                show_connectors=false
            );
}

// Thin horizontal slab: intersection with this volume is an XY section at Z.
module local_xy_slice_keep_volume(
    slice_z,
    thickness=fit_xy_slice_thickness,
    crop_width=fit_xy_crop_width
) {
    y_min = panel_front_y() - fit_xy_y_margin_front;
    y_max = coupler_mounting_y() + fit_xy_y_margin_rear;

    translate([
        -crop_width/2,
        y_min,
        slice_z - thickness/2
    ])
        cube([
            crop_width,
            y_max - y_min,
            thickness
        ]);
}

// Middle PLUS: choose a Z station just below the horizontal arm so the section
// passes through the vertical stem and the full seam locator rib.
function middle_fit_xy_slice_z() =
    -coupler_project_horizontal_arm_height()/2 - fit_xy_inboard_offset;

// Horizontal edge: local Z=0 is the mounting screw row. The nominal panel edge
// is offset from it. Move inboard far enough to clear the horizontal edge arm,
// while remaining inside the seam locator wedge/vertical leg.
function horizontal_edge_fit_xy_slice_z(direction="top") =
    let(
        edge_sign = direction == "top" ? 1 : -1,
        nominal_edge_z = edge_sign * (panel_grid_pitch_z/2 - abs(direction == "top" ? panel_hole_z_top() : panel_hole_z_bottom())),
        arm_half = coupler_project_horizontal_arm_height()/2
    )
    nominal_edge_z - edge_sign*(arm_half + fit_xy_inboard_offset);

module middle_panel_coupler_fit_cross_section(
    thickness=fit_xy_slice_thickness,
    crop_width=fit_xy_crop_width
) {
    row_z = panel_hole_z_middle();
    slice_z = middle_fit_xy_slice_z();

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            fit_pair_at_local_seam(row_z);
            local_xy_slice_keep_volume(slice_z, thickness, crop_width);
        }

    color(color_middle_panel_coupler)
        intersection() {
            translate([0, coupler_mounting_y(), 0])
                project_middle_panel_coupler();
            local_xy_slice_keep_volume(slice_z, thickness, crop_width);
        }
}

module horizontal_edge_panel_coupler_fit_cross_section(
    direction="top",
    thickness=fit_xy_slice_thickness,
    crop_width=fit_xy_crop_width
) {
    row_z = direction == "top" ? panel_hole_z_top() : panel_hole_z_bottom();
    slice_z = horizontal_edge_fit_xy_slice_z(direction);

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            fit_pair_at_local_seam(row_z);
            local_xy_slice_keep_volume(slice_z, thickness, crop_width);
        }

    color(color_coupler)
        intersection() {
            translate([0, coupler_mounting_y(), 0])
                project_horizontal_edge_panel_coupler(
                    direction=direction,
                    screw_row_z=row_z
                );
            local_xy_slice_keep_volume(slice_z, thickness, crop_width);
        }
}
