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
profile_side_material = 6.5;
horizontal_arm_height = hub75_rear_end_rail_width() + 2*profile_side_material;
vertical_arm_width = hub75_rear_side_rail_width() + 2*profile_side_material;
inside_corner_radius = 18.0;
outside_corner_radius = 12.0;
base_thickness = 4.0;
max_outside_projection = 19.5;

/* [Mounting] */
hole_diameter = 3.4;
screw_to_side_edge = 7.85;
screw_to_horizontal_edge = 7.855;

/* [Panel fit] */
rib_clearance = 0.50;
guide_height = 10.0;
guide_end_rounding = 2.5;
bushing_clearance = 0.45;

/* [Decorative pockets] */
show_perforation_holes = true;
perforation_hole_diameter = 3.0;
perforation_depth = 2.5;
perforation_spacing = 10.0;

/* [Tube clips] */
clip_inboard_positions = [12.0, 28.0];
clip_length = 10.0;
clip_wall = 2.6;
clip_inner_diameter = 10.4;
clip_opening = 8.2;
clip_root_height = 6.0;
clip_root_depth = 7.0;

/* [Standalone preview] */
preview_side = "left"; // [left, right]
preview_direction = "top"; // [top, bottom]
preview_tube_y = -5.0;
preview_tube_z = 18.0;
preview_color = [0.95, 0.20, 0.08, 1];

$fn = 64;

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
    part_color=preview_color
) {
    ix = side == "left" ? 1 : -1;
    iz = direction == "top" ? -1 : 1;
    outward_x = screw_to_side_edge + max_outside_projection_value;
    outward_z = screw_to_horizontal_edge + max_outside_projection_value;
    panel_edge_z = -iz * screw_to_horizontal_edge;

    color(part_color)
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
                            if(guide_end_rounding_value > 0)
                                offset(r=guide_end_rounding_value)
                                    offset(delta=-guide_end_rounding_value)
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
                                            offset(delta=rib_clearance_value)
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
                                    offset(delta=rib_clearance_value)
                                        corner_panel_keepout_2d(side,direction,size);
                                }

                            corner_inside_panel_2d(side,direction,size);
                        }

                        // The STEP-derived Ø14 reinforcement bushing sits
                        // 11 mm inward from each corner mounting screw.
                        // Clear it through the complete guide wall only; the
                        // 4 mm base plate remains intact.
                        translate([0, iz*hub75_reinforcement_bushing_offset()])
                            circle(
                                d=hub75_reinforcement_bushing_outer_diameter()
                                  + 2*bushing_clearance_value,
                                $fn=64
                            );
                    }
    }

    // Two short clips. Their snap-ring centres stay on the common aluminium tube;
    // the local support feet extend farther in Y toward the tube so the clips
    // are better tied into the outside edge of the corner plate.
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

        root_center_z = panel_edge_z - iz*clip_root_height_value/2;
        color(part_color)
            translate([
                clip_x-clip_length_value/2,
                -clip_root_depth_value+1.5,
                root_center_z-clip_root_height_value/2
            ])
                cube([clip_length_value,clip_root_depth_value,clip_root_height_value]);
    }
}

corner_edge_panel_coupler(side=preview_side,direction=preview_direction);
