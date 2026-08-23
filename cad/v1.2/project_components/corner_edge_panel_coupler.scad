// HUB75 display frame - V1.2 corner edge panel coupler
//
// One printable component is mirrored/oriented for all four display corners.
// It shares the same 100 mm rounded profile language as the middle PLUS and
// horizontal-edge T couplers, but is cropped around one outside panel corner.
// The body follows the real HUB75 side/end rails and uses short local tube
// clips so each snap requires less force.

use <../components/tube_clip.scad>
use <../components/hub75_panel.scad>
use <_lib/coupler_profile.scad>

/* [Profile] */
profile_size = coupler_profile_size_default();
wall_thickness = coupler_wall_thickness_default();
fit_clearance = coupler_fit_clearance_default();
profile_side_material = wall_thickness + fit_clearance;
horizontal_arm_height = hub75_rear_end_rail_width() + 2*profile_side_material;
vertical_arm_width = hub75_rear_side_rail_width() + 2*profile_side_material;
inside_corner_radius = coupler_profile_inside_radius_default();
outside_corner_radius = coupler_profile_outside_radius_default();
base_thickness = coupler_base_thickness_default();
max_outside_projection = 19.5;

/* [Mounting] */
hole_diameter = coupler_screw_hole_diameter_default();
screw_relief_depth = coupler_screw_relief_depth_default();
screw_relief_radial = coupler_screw_relief_radial_default();
screw_to_side_edge = hub75_panel_hole_x_left();
screw_to_horizontal_edge = hub75_panel_hole_z_bottom();

/* [Panel fit] */
rib_clearance = coupler_fit_clearance_default();
guide_height = coupler_guide_height_default();
guide_end_rounding = coupler_guide_end_rounding_default();
bushing_clearance = coupler_bushing_clearance_default();
locator_pin_clearance = coupler_locator_pin_clearance_default();

/* [Decorative pockets] */
show_perforation_holes = true;
perforation_hole_diameter = coupler_reference_pocket_diameter_default();
perforation_depth = coupler_reference_pocket_depth_default();

/* [Centre reference marks] */
show_center_marks = true;
center_mark_depth = coupler_center_mark_depth_default();
center_mark_pitch = coupler_center_mark_pitch_default();
center_mark_dash_length = coupler_center_mark_dash_length_default();
center_mark_dash_width = coupler_center_mark_dash_width_default();
center_mark_cross_length = coupler_center_mark_cross_length_default();
center_mark_edge_margin = coupler_center_mark_edge_margin_default();
perforation_spacing = 10.0;

/* [Tube clips] */
clip_inboard_positions = [20.0];
clip_length = 16.0;
clip_wall = tube_clip_wall();
clip_inner_diameter = tube_clip_inner_diameter();
clip_opening = tube_clip_opening();
clip_root_height = 6.0;
clip_root_depth = 7.0;

/* [Outer display-edge ridge] */
// Low tapered ridge around the physical outside panel corner, matching the
// horizontal edge coupler.  The horizontal section is interrupted at the clip.
outer_ridge_height = 4.0;
outer_ridge_taper_inset = 0.405;
clip_ridge_clearance = 2.5;

/* [Standalone preview] */
preview_side = "left"; // [left, right]
preview_direction = "top"; // [top, bottom]
preview_tube_y = -5.0;
preview_tube_z = 18.0;
preview_color = [0.95, 0.20, 0.08, 1];

$fn = 64;

// The two physical Ø3 locator pins are diagonal on the HUB75 panel.
// Relative to the corner screw positions they occur only at:
//   - top-left
//   - bottom-right
// The opposite two corners therefore need no locator clearance.
function corner_has_locator_pin(side, direction) =
    (side == "left" && direction == "top")
    || (side == "right" && direction == "bottom");

function corner_locator_pin_x(side) =
    -(side == "left" ? 1 : -1)
    * hub75_locator_pin_near_edge_screw_x_delta();

function corner_locator_pin_z(direction) =
    (direction == "top" ? -1 : 1)
    * hub75_locator_pin_edge_screw_z_delta();

module corner_panel_keepout_2d(side, direction, total_size) {
    ix = side == "left" ? 1 : -1;
    iz = direction == "top" ? -1 : 1;
    edge_x = -ix * screw_to_side_edge;
    edge_z = -iz * screw_to_horizontal_edge;
    side_w = hub75_rear_side_rail_width();
    end_w = hub75_rear_end_rail_width();
    corner_r = hub75_rear_opening_corner_radius();
    span = total_size + 30;

    // Build the actual panel material at the outside corner as the panel
    // quadrant minus its rounded rear opening.  The earlier implementation
    // rounded an L-shaped union of the side/end rails; that did not reproduce
    // the small radius in the *opening* corner and therefore left the corner
    // coupler too square in the rear fit section.
    //
    // Work in local +X/+Z coordinates pointing inward from the physical panel
    // corner, then mirror that same geometry for the other three corners.
    translate([edge_x, edge_z])
        scale([ix, iz])
            difference() {
                square([span, span], center=false);

                // Rear opening starts after the real side/end rails.  Rounding
                // this rectangle gives the same corner radius as hub75_panel.
                offset(r=corner_r)
                    offset(delta=-corner_r)
                        translate([side_w, end_w])
                            square([
                                span - side_w + corner_r,
                                span - end_w + corner_r
                            ], center=false);
            }
}

module corner_inside_panel_2d(side, direction, total_size) {
    ix = side == "left" ? 1 : -1;
    iz = direction == "top" ? -1 : 1;
    edge_x = -ix * screw_to_side_edge;
    edge_z = -iz * screw_to_horizontal_edge;
    span = total_size + 30;

    xmin = ix > 0 ? edge_x : -span;
    xmax = ix > 0 ? span : edge_x;
    zmin = iz > 0 ? edge_z : -span;
    zmax = iz > 0 ? span : edge_z;

    translate([xmin,zmin]) square([xmax-xmin,zmax-zmin], center=false);
}

module corner_reference_perforations_2d(
    side, direction, hole_d, spacing,
    horizontal_height, vertical_width,
    reference_steps = coupler_reference_pocket_steps_default(),
    reference_pitch = coupler_reference_pocket_pitch_default(),
    reference_lane_offset = coupler_reference_pocket_lane_offset_default()
) {
    // A corner exposes one inward X arm and one inward Z arm. Use the same
    // 20/30/40 mm stations as the other couplers. Wide arms use two lanes;
    // narrow arms use one centred lane.
    inward_x = side == "left" ? 1 : -1;
    inward_z = direction == "top" ? -1 : 1;
    x_arm_lane = is_undef(reference_lane_offset)
        ? coupler_reference_lane_offset_for_arm(horizontal_height)
        : reference_lane_offset;
    z_arm_lane = is_undef(reference_lane_offset)
        ? coupler_reference_lane_offset_for_arm(vertical_width)
        : reference_lane_offset;

    x_lane_signs = coupler_reference_lane_signs_for_arm(horizontal_height);
    z_lane_signs = coupler_reference_lane_signs_for_arm(vertical_width);

    coupler_reference_pocket_strip_2d(
        axis="x", direction_sign=inward_x, lane_signs=x_lane_signs,
        steps=reference_steps, pitch=reference_pitch, hole_d=hole_d,
        lane_offset=x_arm_lane
    );
    coupler_reference_pocket_strip_2d(
        axis="z", direction_sign=inward_z, lane_signs=z_lane_signs,
        steps=reference_steps, pitch=reference_pitch, hole_d=hole_d,
        lane_offset=z_arm_lane
    );
}

module corner_fitted_guides_2d(
    side, direction, size,
    horizontal_height, vertical_width,
    inside_radius, outside_radius,
    outward_x, outward_z,
    clearance, end_rounding
) {
    if(end_rounding > 0)
        offset(r=end_rounding)
            offset(delta=-end_rounding)
                difference() {
                    coupler_corner_profile_2d(
                        side=side,direction=direction,
                        width=size,height=size,
                        horizontal_arm_height=horizontal_height,
                        vertical_arm_width=vertical_width,
                        inside_radius=inside_radius,
                        outside_radius=outside_radius,
                        outward_x=outward_x,
                        outward_z=outward_z
                    );
                    offset(delta=clearance)
                        corner_panel_keepout_2d(side,direction,size);
                }
    else
        difference() {
            coupler_corner_profile_2d(
                side=side,direction=direction,
                width=size,height=size,
                horizontal_arm_height=horizontal_height,
                vertical_arm_width=vertical_width,
                inside_radius=inside_radius,
                outside_radius=outside_radius,
                outward_x=outward_x,
                outward_z=outward_z
            );
            offset(delta=clearance)
                corner_panel_keepout_2d(side,direction,size);
        }
}

module corner_outside_edge_zone_2d(side, direction, size, clearance) {
    ix = side == "left" ? 1 : -1;
    iz = direction == "top" ? -1 : 1;
    edge_x = -ix * screw_to_side_edge;
    edge_z = -iz * screw_to_horizontal_edge;
    span = size + 40;

    // Union of the two regions outside the physical panel edges.  Intersecting
    // this with the fitted guide leaves an L-shaped ridge around the corner.
    union() {
        if(ix > 0)
            translate([edge_x-clearance-span/2,0]) square([span,span],center=true);
        else
            translate([edge_x+clearance+span/2,0]) square([span,span],center=true);

        if(iz < 0)
            translate([0,edge_z+clearance+span/2]) square([span,span],center=true);
        else
            translate([0,edge_z-clearance-span/2]) square([span,span],center=true);
    }
}

module corner_outer_ridge_2d(
    side, direction, size,
    horizontal_height, vertical_width,
    inside_radius, outside_radius,
    outward_x, outward_z,
    clearance, end_rounding,
    clip_positions, clip_length, clip_clearance
) {
    ix = side == "left" ? 1 : -1;
    iz = direction == "top" ? -1 : 1;
    edge_z = -iz * screw_to_horizontal_edge;

    difference() {
        intersection() {
            corner_fitted_guides_2d(
                side,direction,size,
                horizontal_height,vertical_width,
                inside_radius,outside_radius,
                outward_x,outward_z,
                clearance,end_rounding
            );
            corner_outside_edge_zone_2d(side,direction,size,clearance);
        }

        // Keep the tube snap clip completely free of the horizontal ridge.
        for(d=clip_positions)
            translate([ix*d, edge_z])
                square([clip_length + 2*clip_clearance, size+30], center=true);
    }
}

// Taper one connected ridge patch at a time.  Do NOT hull the complete
// interrupted ridge: hull() would bridge the gaps around the clip and create
// a large diagonal sheet between otherwise separate pieces.
module tapered_corner_ridge_patch_3d(shape_bottom, shape_top, ridge_height) {
    // Kept as a documentation placeholder; OpenSCAD cannot pass child geometry
    // as values, so the actual patch taper is implemented with children below.
}

module corner_ridge_patch_taper_3d(ridge_height, taper_inset) {
    hull() {
        rotate([90,0,0])
            linear_extrude(height=0.02)
                children();
        translate([0,-ridge_height+0.02,0])
            rotate([90,0,0])
                linear_extrude(height=0.02)
                    offset(delta=-taper_inset)
                        children();
    }
}

module tapered_corner_outer_ridge_3d(
    side, direction, size,
    horizontal_height, vertical_width,
    inside_radius, outside_radius,
    outward_x, outward_z,
    clearance, end_rounding,
    clip_positions, clip_length, clip_clearance,
    ridge_height, taper_inset
) {
    ix = side == "left" ? 1 : -1;
    iz = direction == "top" ? -1 : 1;
    edge_x = -ix * screw_to_side_edge;
    edge_z = -iz * screw_to_horizontal_edge;
    span = size + 40;

    // Horizontal outside-edge ridge, split into separate patches around the
    // single tube clip.  Each patch is tapered independently so no hull can
    // bridge across the clip opening.
    clip_x = ix*clip_positions[0];
    gap_half = clip_length/2 + clip_clearance;

    // Patch on one side of the clip.
    intersection() {
        corner_ridge_patch_taper_3d(ridge_height,taper_inset)
            intersection() {
                corner_fitted_guides_2d(
                    side,direction,size,
                    horizontal_height,vertical_width,
                    inside_radius,outside_radius,
                    outward_x,outward_z,
                    clearance,end_rounding
                );
                // Outside of the horizontal panel edge only.
                if(iz < 0)
                    translate([0,edge_z+clearance+span/2]) square([span,span],center=true);
                else
                    translate([0,edge_z-clearance-span/2]) square([span,span],center=true);
                // First side of clip gap.
                if(ix > 0)
                    translate([clip_x-gap_half-span/2,0]) square([span,span*2],center=true);
                else
                    translate([clip_x+gap_half+span/2,0]) square([span,span*2],center=true);
            }
    }

    // Patch on the other side of the clip.
    intersection() {
        corner_ridge_patch_taper_3d(ridge_height,taper_inset)
            intersection() {
                corner_fitted_guides_2d(
                    side,direction,size,
                    horizontal_height,vertical_width,
                    inside_radius,outside_radius,
                    outward_x,outward_z,
                    clearance,end_rounding
                );
                if(iz < 0)
                    translate([0,edge_z+clearance+span/2]) square([span,span],center=true);
                else
                    translate([0,edge_z-clearance-span/2]) square([span,span],center=true);
                if(ix > 0)
                    translate([clip_x+gap_half+span/2,0]) square([span,span*2],center=true);
                else
                    translate([clip_x-gap_half-span/2,0]) square([span,span*2],center=true);
            }
    }

    // Vertical outside-edge ridge.  This is a separate connected patch and is
    // therefore tapered on its own as well.
    corner_ridge_patch_taper_3d(ridge_height,taper_inset)
        intersection() {
            corner_fitted_guides_2d(
                side,direction,size,
                horizontal_height,vertical_width,
                inside_radius,outside_radius,
                outward_x,outward_z,
                clearance,end_rounding
            );
            if(ix > 0)
                translate([edge_x-clearance-span/2,0]) square([span,span],center=true);
            else
                translate([edge_x+clearance+span/2,0]) square([span,span],center=true);
        }
}

module corner_edge_panel_coupler(
    side="left",
    direction="top",
    size=profile_size,
    horizontal_height=horizontal_arm_height,
    vertical_width=vertical_arm_width,
    thickness=base_thickness,
    inside_radius=inside_corner_radius,
    outside_radius=outside_corner_radius,
    max_outside_projection_value=max_outside_projection,
    hole_diameter_value=hole_diameter,
    screw_relief_depth_value=screw_relief_depth,
    screw_relief_radial_value=screw_relief_radial,
    rib_clearance_value=rib_clearance,
    guide_height_value=guide_height,
    guide_end_rounding_value=guide_end_rounding,
    bushing_clearance_value=bushing_clearance,
    locator_pin_clearance_value=locator_pin_clearance,
    show_perforation_holes_value=show_perforation_holes,
    perforation_hole_diameter_value=perforation_hole_diameter,
    perforation_depth_value=perforation_depth,
    reference_pocket_steps_value=coupler_reference_pocket_steps_default(),
    reference_pocket_pitch_value=coupler_reference_pocket_pitch_default(),
    reference_pocket_lane_offset_value=coupler_reference_pocket_lane_offset_default(),
    show_center_marks_value=show_center_marks,
    center_mark_depth_value=center_mark_depth,
    center_mark_pitch_value=center_mark_pitch,
    center_mark_dash_length_value=center_mark_dash_length,
    center_mark_dash_width_value=center_mark_dash_width,
    center_mark_cross_length_value=center_mark_cross_length,
    center_mark_edge_margin_value=center_mark_edge_margin,
    clip_inboard_positions_value=clip_inboard_positions,
    local_tube_y=preview_tube_y,
    local_tube_z=preview_tube_z,
    clip_length_value=clip_length,
    clip_wall_value=clip_wall,
    clip_inner_diameter_value=clip_inner_diameter,
    clip_opening_value=clip_opening,
    clip_root_height_value=clip_root_height,
    clip_root_depth_value=clip_root_depth,
    outer_ridge_height_value=outer_ridge_height,
    outer_ridge_taper_inset_value=outer_ridge_taper_inset,
    clip_ridge_clearance_value=clip_ridge_clearance,
    part_color=preview_color
) {
    ix = side == "left" ? 1 : -1;
    iz = direction == "top" ? -1 : 1;
    outward_x = screw_to_side_edge + max_outside_projection_value;
    outward_z = screw_to_horizontal_edge + max_outside_projection_value;
    panel_edge_z = -iz * screw_to_horizontal_edge;

    // Final X/Z envelope of the printable corner plate.  All local body
    // features (base, panel-fit wall and outer ridge) are built first and are
    // clipped by this envelope as the last operation.  This prevents helper
    // rectangles used to construct ridges/reliefs from protruding below or
    // beyond the rounded corner profile.  Tube clips and their support webs
    // are added afterwards because they intentionally extend outside it.
    module final_corner_body_envelope() {
        translate([0, guide_height_value + thickness + 2, 0])
            rotate([90,0,0])
                linear_extrude(height=guide_height_value + thickness + outer_ridge_height_value + 4)
                    coupler_corner_profile_2d(
                        side=side,
                        direction=direction,
                        width=size,
                        height=size,
                        horizontal_arm_height=horizontal_height,
                        vertical_arm_width=vertical_width,
                        inside_radius=inside_radius,
                        outside_radius=outside_radius,
                        outward_x=outward_x,
                        outward_z=outward_z
                    );
    }

    module raw_corner_body() {
        union() {
            difference() {
                translate([0, thickness, 0])
                    rotate([90,0,0])
                        linear_extrude(height=thickness)
                            coupler_corner_profile_2d(
                                side=side,
                                direction=direction,
                                width=size,
                                height=size,
                                horizontal_arm_height=horizontal_height,
                                vertical_arm_width=vertical_width,
                                inside_radius=inside_radius,
                                outside_radius=outside_radius,
                                outward_x=outward_x,
                                outward_z=outward_z
                            );

                coupler_screw_hole_y(
                    hole_diameter=hole_diameter_value,
                    plate_thickness=thickness,
                    relief_depth=screw_relief_depth_value,
                    relief_radial=screw_relief_radial_value,
                    fn=48
                );

                if(show_perforation_holes_value && perforation_depth_value > 0)
                    translate([0, thickness+0.15, 0])
                        rotate([90,0,0])
                            linear_extrude(height=min(perforation_depth_value,thickness-0.2)+0.15)
                                intersection() {
                                    offset(delta=-4)
                                        coupler_corner_profile_2d(
                                            side=side,direction=direction,
                                            width=size,height=size,
                                            horizontal_arm_height=horizontal_height,
                                            vertical_arm_width=vertical_width,
                                            inside_radius=inside_radius,
                                            outside_radius=outside_radius,
                                            outward_x=outward_x,
                                            outward_z=outward_z
                                        );
                                    corner_reference_perforations_2d(
                                        side,direction,
                                        perforation_hole_diameter_value,
                                        perforation_spacing,
                                        horizontal_height,
                                        vertical_width,
                                        reference_pocket_steps_value,
                                        reference_pocket_pitch_value,
                                        reference_pocket_lane_offset_value
                                    );
                                }

                if(show_center_marks_value && center_mark_depth_value > 0)
                    translate([0, thickness+0.15, 0])
                        rotate([90,0,0])
                            linear_extrude(height=min(center_mark_depth_value,thickness-0.2)+0.15)
                                intersection() {
                                    offset(delta=-center_mark_edge_margin_value)
                                        coupler_corner_profile_2d(
                                            side=side,direction=direction,
                                            width=size,height=size,
                                            horizontal_arm_height=horizontal_height,
                                            vertical_arm_width=vertical_width,
                                            inside_radius=inside_radius,
                                            outside_radius=outside_radius,
                                            outward_x=outward_x,
                                            outward_z=outward_z
                                        );
                                    coupler_center_marks_2d(
                                        span_x=size, span_z=size,
                                        pitch=center_mark_pitch_value,
                                        dash_length=center_mark_dash_length_value,
                                        dash_width=center_mark_dash_width_value,
                                        cross_length=center_mark_cross_length_value,
                                        keepout_points=[[0,0]],
                                        keepout_radius=hole_diameter_value/2 + coupler_center_mark_screw_keepout_default()
                                    );
                                }
            }

            if(guide_height_value > 0)
                rotate([90,0,0])
                    linear_extrude(height=guide_height_value)
                        difference() {
                            intersection() {
                                corner_fitted_guides_2d(
                                    side,direction,size,
                                    horizontal_height,vertical_width,
                                    inside_radius,outside_radius,
                                    outward_x,outward_z,
                                    rib_clearance_value,guide_end_rounding_value
                                );
                                corner_inside_panel_2d(side,direction,size);
                            }

                            // Clear the STEP-derived reinforcement bushing
                            // through the guide wall only; keep the base intact.
                            translate([0, iz*hub75_reinforcement_bushing_offset()])
                                circle(
                                    d=hub75_reinforcement_bushing_outer_diameter()
                                      + 2*bushing_clearance_value,
                                    $fn=64
                                );
                        }

            // Positive locator for the single reinforcement bushing at this
            // panel corner. The surrounding guide already has the Ø14 wall
            // relief; the pad and pin use the panel recess/hole dimensions.
            translate([0, 0, iz*hub75_reinforcement_bushing_offset()])
                coupler_reinforcement_locator_y(
                    recess_diameter=hub75_reinforcement_bushing_recess_diameter(),
                    recess_depth=hub75_reinforcement_bushing_recess_depth(),
                    hole_diameter=hub75_reinforcement_bushing_hole_diameter()
                );

            if(outer_ridge_height_value > 0)
                difference() {
                    tapered_corner_outer_ridge_3d(
                        side,direction,size,
                        horizontal_height,vertical_width,
                        inside_radius,outside_radius,
                        outward_x,outward_z,
                        rib_clearance_value,guide_end_rounding_value,
                        clip_inboard_positions_value,clip_length_value,
                        clip_ridge_clearance_value,
                        outer_ridge_height_value,outer_ridge_taper_inset_value
                    );

                    tube_axis_keepout(
                        center_x=0,
                        local_tube_y=local_tube_y,
                        local_tube_z=local_tube_z,
                        length=size + 40,
                        diameter=clip_inner_diameter_value
                    );

                    for(d=clip_inboard_positions_value) {
                        clip_x = ix*d;
                        tube_clip_outer_keepout(
                            center_x=clip_x,
                            local_tube_y=local_tube_y,
                            local_tube_z=local_tube_z,
                            length=clip_length_value,
                            wall=clip_wall_value,
                            inner_diameter=clip_inner_diameter_value,
                            axial_clearance=clip_ridge_clearance_value,
                            radial_clearance=0.6
                        );
                    }
                }
        }
    }

    color(part_color)
        difference() {
            intersection() {
                raw_corner_body();
                final_corner_body_envelope();
            }

            // The panel has two diagonal Ø3 x 3 mm locator pins. Only the
            // top-left and bottom-right corner positions overlap one. Cut a
            // true through-clearance through the complete corner body at those
            // positions; do not create a shallow pocket.
            if(corner_has_locator_pin(side,direction))
                translate([
                    corner_locator_pin_x(side),
                    0,
                    corner_locator_pin_z(direction)
                ])
                    coupler_through_hole_y_with_relief(
                        hole_diameter=hub75_locator_pin_diameter()
                          + 2*locator_pin_clearance_value,
                        y_max=thickness,
                        y_min=-(guide_height_value + outer_ridge_height_value + 2),
                        relief_depth=screw_relief_depth_value,
                        relief_radial=screw_relief_radial_value,
                        fn=48
                    );
        }

    // Clip geometry intentionally sits outside the clipped corner-body
    // envelope. Each clip keeps its own local support only.
    for(d=clip_inboard_positions_value) {
        clip_x = ix*d;
        tube_snap_clip(
            center_x=clip_x,
            local_tube_y=local_tube_y,
            local_tube_z=local_tube_z,
            length=clip_length_value,
            wall=clip_wall_value,
            inner_diameter=clip_inner_diameter_value,
            opening=clip_opening_value,
            part_color=part_color
        );

        tube_clip_support_web(
            center_x=clip_x,
            edge=direction,
            panel_edge_z=panel_edge_z,
            local_tube_y=local_tube_y,
            local_tube_z=local_tube_z,
            length=clip_length_value,
            wall=clip_wall_value,
            inner_diameter=clip_inner_diameter_value,
            root_depth=clip_root_depth_value,
            root_height=clip_root_height_value,
            neck_height=2.8,
            part_color=part_color
        );
    }
}


corner_edge_panel_coupler(side=preview_side,direction=preview_direction);
