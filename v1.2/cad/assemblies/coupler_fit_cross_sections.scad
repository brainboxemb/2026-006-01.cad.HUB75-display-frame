// HUB75 display frame - V1.2 local rear fit sections
//
// Rear-facing local sections through the actual panel/coupler interface.
// These deliberately use the same Y-depth cut as the full rear fit section,
// but crop the Z window just INBOARD of the red horizontal arm so the seam
// locator rib is visible instead of being hidden by the outer ridge/arm.

include <../config/project_config.scad>
use <../components/hub75_panel.scad>
use <../project_components/_lib/coupler_dimensions.scad>
use <panels_assembly.scad>
use <couplers_assembly.scad>

/* [Fit section] */
fit_section_depth = 5.0;
fit_section_crop_width = 145.0;
fit_section_crop_height = 34.0;
fit_section_inboard_offset = 6.0;

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

module local_rear_section_keep_volume(
    depth,
    crop_width,
    crop_height,
    crop_center_z
) {
    section_y = coupler_mounting_y() - depth;

    translate([
        -crop_width/2,
        panel_front_y() - 1.0,
        crop_center_z - crop_height/2
    ])
        cube([
            crop_width,
            section_y - (panel_front_y() - 1.0),
            crop_height
        ]);
}

// The middle PLUS is symmetric.  Put the section window immediately below
// its horizontal arm, into the vertical stem where the seam locator rib must
// still be visible.
function middle_fit_section_center_z() =
    -coupler_project_horizontal_arm_height()/2
    - fit_section_inboard_offset
    - fit_section_crop_height/2 + fit_section_crop_height/2;

// Horizontal edge local coordinates are centred on the mounting screw row.
// For the top edge the nominal 320 mm edge is +8 mm from that row.  The real
// rear end rail is centred lower than that.  Crop just inboard/below the arm.
function horizontal_edge_fit_section_center_z(direction="top") =
    let(
        edge_sign = direction == "top" ? 1 : -1,
        rail_center_z = edge_sign * (hub75_panel_hole_z_bottom() - hub75_rear_end_rail_width()/2),
        arm_half = coupler_project_horizontal_arm_height()/2
    )
    rail_center_z - edge_sign*(arm_half + fit_section_inboard_offset);

module middle_panel_coupler_fit_cross_section(
    depth=fit_section_depth,
    crop_width=fit_section_crop_width,
    crop_height=fit_section_crop_height
) {
    row_z = panel_hole_z_middle();
    crop_z = middle_fit_section_center_z();

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            fit_pair_at_local_seam(row_z);
            local_rear_section_keep_volume(depth, crop_width, crop_height, crop_z);
        }

    color(color_middle_panel_coupler)
        intersection() {
            translate([0, coupler_mounting_y(), 0])
                project_middle_panel_coupler();
            local_rear_section_keep_volume(depth, crop_width, crop_height, crop_z);
        }
}

module horizontal_edge_panel_coupler_fit_cross_section(
    direction="top",
    depth=fit_section_depth,
    crop_width=fit_section_crop_width,
    crop_height=fit_section_crop_height
) {
    row_z = direction == "top" ? panel_hole_z_top() : panel_hole_z_bottom();
    crop_z = horizontal_edge_fit_section_center_z(direction);

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            fit_pair_at_local_seam(row_z);
            local_rear_section_keep_volume(depth, crop_width, crop_height, crop_z);
        }

    color(color_coupler)
        intersection() {
            translate([0, coupler_mounting_y(), 0])
                project_horizontal_edge_panel_coupler(
                    direction=direction,
                    screw_row_z=row_z
                );
            local_rear_section_keep_volume(depth, crop_width, crop_height, crop_z);
        }
}
