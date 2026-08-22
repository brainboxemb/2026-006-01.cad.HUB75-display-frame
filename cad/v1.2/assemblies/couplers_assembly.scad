// HUB75 display frame - V1.2 coupler assembly
//
// Components are self-contained.
// This assembly maps project_config.scad values to component parameters.

include <../config/project_config.scad>

use <../components/middle_seam_coupler.scad>
use <../components/tube_seam_coupler.scad>
use <../components/end_tube_coupler.scad>


module project_middle_coupler() {
    middle_seam_coupler(
        width=middle_coupler_width,
        height=middle_coupler_height,
        horizontal_height=middle_coupler_horizontal_arm_height,
        vertical_width=middle_coupler_vertical_width,
        thickness=coupler_thickness,
        inside_radius=middle_coupler_inside_corner_radius,
        outside_radius=middle_coupler_outer_corner_radius,

        left_hole_x_value=seam_left_screw_x,
        right_hole_x_value=seam_right_screw_x,
        hole_diameter_value=coupler_screw_hole_diameter,

        mounting_tube_outer_diameter_value=
            middle_mounting_tube_outer_diameter,
        mounting_tube_clearance_value=
            middle_mounting_tube_clearance,
        mounting_tube_pocket_depth_value=
            middle_mounting_tube_pocket_depth,

        centre_locator_x_value=middle_centre_locator_x,
        centre_locator_z_value=middle_centre_locator_z,
        centre_locator_diameter_value=middle_centre_locator_diameter,
        centre_locator_height_value=middle_centre_locator_height,

        guide_wall_thickness_value=middle_guide_wall_thickness,
        guide_wall_height_value=middle_guide_wall_height,
        guide_wall_straight_value=middle_guide_wall_straight,

        centre_rib_width_value=middle_centre_rib_width,
        centre_rib_height_value=middle_centre_rib_height,
        centre_rib_length_value=middle_centre_rib_length,

        part_color=color_middle_coupler
    );
}


module project_tube_seam_coupler(
    direction="top",
    screw_row_z=0
) {
    tube_z =
        direction == "top"
            ? stiffening_tube_top_z()
            : stiffening_tube_bottom_z();

    local_tube_z =
        tube_z - screw_row_z;

    local_tube_y =
        stiffening_tube_y()
        - coupler_y;

    tube_seam_coupler(
        direction=direction,

        width=tube_seam_plate_width,
        height=tube_seam_plate_height,
        thickness=coupler_thickness,
        radius=coupler_corner_radius,

        left_hole_x_value=
            seam_left_screw_x,

        right_hole_x_value=
            seam_right_screw_x,

        hole_diameter_value=
            coupler_screw_hole_diameter,

        left_clip_x_value=
            seam_clip_x_left,

        right_clip_x_value=
            seam_clip_x_right,

        local_tube_y=local_tube_y,
        local_tube_z=local_tube_z,

        clip_length_value=
            tube_clip_length,

        clip_wall_value=
            tube_clip_wall,

        clip_inner_diameter_value=
            tube_clip_inner_diameter,

        clip_opening_value=
            tube_clip_opening,

        clip_vertical_overlap_value=
            tube_clip_vertical_overlap,

        part_color=
            color_coupler
    );
}


module project_end_tube_coupler(
    side="left",
    direction="top",
    screw_row_z=0
) {
    tube_z =
        direction == "top"
            ? stiffening_tube_top_z()
            : stiffening_tube_bottom_z();

    local_tube_z =
        tube_z - screw_row_z;

    local_tube_y =
        stiffening_tube_y()
        - coupler_y;

    end_tube_coupler(
        side=side,
        direction=direction,

        width=end_coupler_plate_width,
        height=end_coupler_plate_height,
        thickness=coupler_thickness,
        radius=coupler_corner_radius,

        hole_diameter_value=
            coupler_screw_hole_diameter,

        outside_material_value=6.0,
        clip_inward_offset_value=6.0,

        local_tube_y=local_tube_y,
        local_tube_z=local_tube_z,

        clip_length_value=
            tube_clip_length,

        clip_wall_value=
            tube_clip_wall,

        clip_inner_diameter_value=
            tube_clip_inner_diameter,

        clip_opening_value=
            tube_clip_opening,

        clip_vertical_overlap_value=
            tube_clip_vertical_overlap,

        part_color=
            color_end_coupler
    );
}


module couplers_assembly(
    yshift=0,
    exploded=false
) {
    y_offset =
        yshift
        + (
            exploded
                ? exploded_coupler_offset
                : 0
        );

    // Four internal seams.
    for(seam=[0:panel_count-2]) {
        x = seam_x(seam);

        translate([
            x,
            coupler_y + y_offset,
            panel_hole_z[0]
        ])
            project_tube_seam_coupler(
                direction="bottom",
                screw_row_z=panel_hole_z[0]
            );

        translate([
            x,
            coupler_y + y_offset,
            panel_hole_z[1]
        ])
            project_middle_coupler();

        translate([
            x,
            coupler_y + y_offset,
            panel_hole_z[2]
        ])
            project_tube_seam_coupler(
                direction="top",
                screw_row_z=panel_hole_z[2]
            );
    }

    // Left and right outer end couplers.
    left_x =
        panel_x(0)
        + panel_hole_x[0];

    right_x =
        panel_x(panel_count-1)
        + panel_hole_x[1];

    for(direction=["bottom", "top"]) {
        z =
            direction == "top"
                ? panel_hole_z[2]
                : panel_hole_z[0];

        translate([
            left_x,
            coupler_y + y_offset,
            z
        ])
            project_end_tube_coupler(
                side="left",
                direction=direction,
                screw_row_z=z
            );

        translate([
            right_x,
            coupler_y + y_offset,
            z
        ])
            project_end_tube_coupler(
                side="right",
                direction=direction,
                screw_row_z=z
            );
    }
}
