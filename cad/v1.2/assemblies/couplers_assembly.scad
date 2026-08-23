// HUB75 display frame - V1.2 coupler assembly
//
// Components are self-contained.
// This assembly maps project_config.scad values to component parameters.

include <../config/project_config.scad>

use <../components/middle_panel_coupler.scad>
use <../components/horizontal_edge_panel_coupler.scad>
use <../components/corner_edge_panel_coupler.scad>


module project_middle_panel_coupler() {
    middle_panel_coupler(
        width=middle_panel_coupler_width,
        height=middle_panel_coupler_height,
        horizontal_height=middle_panel_coupler_horizontal_arm_height,
        vertical_width=middle_panel_coupler_vertical_width,
        thickness=coupler_thickness,
        inside_radius=middle_panel_coupler_inside_corner_radius,
        outside_radius=middle_panel_coupler_outer_corner_radius,

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
        guide_end_rounding_value=middle_guide_end_rounding,

        centre_rib_width_value=middle_centre_rib_width,
        centre_rib_height_value=middle_centre_rib_height,
        centre_rib_length_value=middle_centre_rib_length,

        part_color=color_middle_panel_coupler
    );
}


module project_horizontal_edge_panel_coupler(
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

    horizontal_edge_panel_coupler(
        direction=direction,

        width=horizontal_edge_panel_coupler_plate_width,
        height=horizontal_edge_panel_coupler_plate_height,
        inward_reach_value=horizontal_edge_panel_coupler_inboard_reach,
        max_outside_projection_value=horizontal_edge_panel_coupler_max_outside_projection,
        horizontal_height=horizontal_edge_panel_coupler_horizontal_arm_height,
        vertical_width=horizontal_edge_panel_coupler_vertical_width,
        thickness=coupler_thickness,
        inside_radius=horizontal_edge_panel_coupler_inside_corner_radius,
        outside_radius=horizontal_edge_panel_coupler_outer_corner_radius,
        rib_clearance_value=horizontal_edge_panel_coupler_guide_clearance,
        guide_height_value=horizontal_edge_panel_coupler_guide_height,
        guide_end_rounding_value=horizontal_edge_panel_coupler_guide_end_rounding,

        show_perforation_holes_value=true,
        perforation_hole_diameter_value=horizontal_edge_panel_coupler_perforation_diameter,
        perforation_depth_value=horizontal_edge_panel_coupler_perforation_depth,
        perforation_spacing_value=horizontal_edge_panel_coupler_perforation_spacing,
        perforation_edge_margin_value=horizontal_edge_panel_coupler_perforation_edge_margin,
        perforation_centre_keepout_value=horizontal_edge_panel_coupler_perforation_centre_keepout,

        left_hole_x_value=
            seam_left_screw_x,

        right_hole_x_value=
            seam_right_screw_x,

        hole_diameter_value=
            coupler_screw_hole_diameter,

        clip_x_positions_value=
            horizontal_edge_clip_x_positions,

        seam_wedge_width_value=
            horizontal_edge_panel_coupler_wedge_width,

        seam_wedge_height_value=
            horizontal_edge_panel_coupler_wedge_height,

        seam_wedge_length_value=
            horizontal_edge_panel_coupler_wedge_length,

        bushing_clearance_value=
            horizontal_edge_panel_coupler_bushing_clearance,

        local_tube_y=local_tube_y,
        local_tube_z=local_tube_z,

        clip_length_value=
            horizontal_edge_tube_clip_length,

        clip_wall_value=
            tube_clip_wall,

        clip_inner_diameter_value=
            tube_clip_inner_diameter,

        clip_opening_value=
            tube_clip_opening,

        clip_vertical_overlap_value=
            tube_clip_vertical_overlap,

        clip_root_height_value=horizontal_edge_panel_coupler_clip_root_height,
        clip_root_depth_value=horizontal_edge_panel_coupler_clip_root_depth,
        outer_ridge_height_value=horizontal_edge_panel_coupler_outer_ridge_height,
        outer_ridge_taper_inset_value=horizontal_edge_panel_coupler_outer_ridge_taper_inset,

        part_color=
            color_coupler
    );
}


module project_corner_edge_panel_coupler(
    side="left",
    direction="top",
    screw_row_z=0
) {
    tube_z = direction == "top" ? stiffening_tube_top_z() : stiffening_tube_bottom_z();
    local_tube_z = tube_z - screw_row_z;
    local_tube_y = stiffening_tube_y() - coupler_y;

    corner_edge_panel_coupler(
        side=side,
        direction=direction,
        size=coupler_profile_size,
        horizontal_height=corner_edge_panel_coupler_profile_horizontal_arm_height,
        vertical_width=corner_edge_panel_coupler_profile_vertical_arm_width,
        thickness=coupler_thickness,
        inside_radius=coupler_profile_inside_corner_radius,
        outside_radius=coupler_profile_outer_corner_radius,
        max_outside_projection_value=corner_edge_panel_coupler_max_outside_projection,
        hole_diameter_value=coupler_screw_hole_diameter,
        rib_clearance_value=corner_edge_panel_coupler_guide_clearance,
        guide_height_value=corner_edge_panel_coupler_guide_height,
        guide_end_rounding_value=corner_edge_panel_coupler_guide_end_rounding,
        bushing_clearance_value=corner_edge_panel_coupler_bushing_clearance,
        show_perforation_holes_value=true,
        perforation_hole_diameter_value=corner_edge_panel_coupler_perforation_diameter,
        perforation_depth_value=corner_edge_panel_coupler_perforation_depth,
        clip_inboard_positions_value=corner_edge_panel_coupler_clip_inboard_positions,
        local_tube_y=local_tube_y,
        local_tube_z=local_tube_z,
        clip_length_value=corner_edge_tube_clip_length,
        clip_wall_value=tube_clip_wall,
        clip_inner_diameter_value=tube_clip_inner_diameter,
        clip_opening_value=tube_clip_opening,
        clip_root_height_value=corner_edge_panel_coupler_clip_root_height,
        clip_root_depth_value=corner_edge_panel_coupler_clip_root_depth,
        outer_ridge_height_value=corner_edge_panel_coupler_outer_ridge_height,
        outer_ridge_taper_inset_value=corner_edge_panel_coupler_outer_ridge_taper_inset,
        clip_ridge_clearance_value=corner_edge_panel_coupler_clip_ridge_clearance,
        part_color=color_corner_edge_panel_coupler
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
            project_horizontal_edge_panel_coupler(
                direction="bottom",
                screw_row_z=panel_hole_z[0]
            );

        translate([
            x,
            coupler_y + y_offset,
            panel_hole_z[1]
        ])
            project_middle_panel_coupler();

        translate([
            x,
            coupler_y + y_offset,
            panel_hole_z[2]
        ])
            project_horizontal_edge_panel_coupler(
                direction="top",
                screw_row_z=panel_hole_z[2]
            );
    }

    // Four outer corner edge panel couplers.
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
            project_corner_edge_panel_coupler(
                side="left",
                direction=direction,
                screw_row_z=z
            );

        translate([
            right_x,
            coupler_y + y_offset,
            z
        ])
            project_corner_edge_panel_coupler(
                side="right",
                direction=direction,
                screw_row_z=z
            );
    }
}
