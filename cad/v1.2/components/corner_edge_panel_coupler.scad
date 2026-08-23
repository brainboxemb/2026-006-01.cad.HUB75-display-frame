// HUB75 display frame - V1.2 corner edge panel coupler
//
// One printable component is mirrored/oriented for all four display corners.
// It shares the same 100 mm rounded profile language as the middle PLUS and
// horizontal-edge T couplers, but is cropped around one outside panel corner.
// The body follows the real HUB75 side/end rails and uses short local tube
// clips so each snap requires less force.

use <tube_clip.scad>
use <hub75_panel.scad>
use <_lib/coupler_profile.scad>

/* [Profile] */
profile_size = 100.0;
wall_thickness = 5.0;
fit_clearance = 0.50;
profile_side_material = wall_thickness + fit_clearance;
horizontal_arm_height = hub75_rear_end_rail_width() + 2*profile_side_material;
vertical_arm_width = hub75_rear_side_rail_width() + 2*profile_side_material;
inside_corner_radius = 10.0;
outside_corner_radius = 6.0;
base_thickness = 4.0;
max_outside_projection = 19.5;

/* [Mounting] */
hole_diameter = 3.4;
screw_to_side_edge = 7.85;
screw_to_horizontal_edge = 7.855;

/* [Panel fit] */
rib_clearance = 0.50;
guide_height = 10.0;
guide_end_rounding = 1.5;
bushing_clearance = 0.45;
locator_pin_clearance = 0.40;

/* [Decorative pockets] */
show_perforation_holes = true;
perforation_hole_diameter = 3.0;
perforation_depth = 2.5;
perforation_spacing = 10.0;

/* [Tube clips] */
clip_inboard_positions = [20.0];
clip_length = 16.0;
clip_wall = 2.6;
clip_inner_diameter = 10.4;
clip_opening = 8.2;
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

    // Rounded union of the real outer side rail and top/bottom end rail.
    offset(r=corner_r)
        offset(delta=-corner_r)
            union() {
                translate([edge_x + ix*side_w/2, 0])
                    square([side_w, total_size+20], center=true);
                translate([0, edge_z + iz*end_w/2])
                    square([total_size+20, end_w], center=true);
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

module corner_reference_perforations_2d(side, direction, hole_d, spacing) {
    ix = side == "left" ? 1 : -1;
    iz = direction == "top" ? -1 : 1;

    // Same 10 mm rhythm as the other couplers, but only where the corner body
    // has useful material. Two pockets in each inward arm.
    for (d=[22,32])
        translate([ix*d, 0]) circle(d=hole_d);
    for (d=[22,32])
        translate([0, iz*d]) circle(d=hole_d);
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
    rib_clearance_value=rib_clearance,
    guide_height_value=guide_height,
    guide_end_rounding_value=guide_end_rounding,
    bushing_clearance_value=bushing_clearance,
    locator_pin_clearance_value=locator_pin_clearance,
    show_perforation_holes_value=show_perforation_holes,
    perforation_hole_diameter_value=perforation_hole_diameter,
    perforation_depth_value=perforation_depth,
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

                translate([0, thickness+0.25, 0])
                    rotate([90,0,0])
                        cylinder(d=hole_diameter_value, h=thickness+0.5, $fn=36);

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
                                        perforation_spacing
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
                    thickness + 2,
                    corner_locator_pin_z(direction)
                ])
                    rotate([90,0,0])
                        cylinder(
                            d=hub75_locator_pin_diameter()
                              + 2*locator_pin_clearance_value,
                            h=thickness + guide_height_value
                              + outer_ridge_height_value + 4,
                            $fn=48
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
