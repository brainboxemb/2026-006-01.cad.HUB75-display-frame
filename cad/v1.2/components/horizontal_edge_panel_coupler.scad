// HUB75 display frame - V1.2 V32 shared-profile 100 mm rounded horizontal edge panel coupler with four short tube clips
//
// Used for the four upper and four lower internal panel joins at the horizontal display edges.
// The outer corner/end couplers are deliberately a separate component and
// are not changed by this design.
//
// The T-shaped printed body follows the same design language as the middle
// PLUS coupler. Its inward reach is deliberately the same 50 mm as one half
// of the middle PLUS, while only the outward projection is capped below 20 mm.
// Raised guide material sits beside the real HUB75 rear ribs,
// leaving a fitted T-shaped channel for the panel housing.

use <tube_clip.scad>
use <hub75_panel.scad>
use <_lib/coupler_profile.scad>

/* [T body] */
overall_width = 100.0;
inboard_reach = 50.0;
max_outside_projection = 19.5;
overall_height = 100.0;
// Standalone defaults follow the exact same rule as the project assembly:
// real HUB75 rib width + equal printed material on both sides.
profile_side_material = 6.5;
horizontal_arm_height = max(
    hub75_rear_end_rail_width() + 2*profile_side_material,
    hub75_rear_middle_rib_width() + 2*profile_side_material
);
vertical_arm_width = 2*12.5 + 2*profile_side_material;
inside_corner_radius = 18.0;
outer_corner_radius = 12.0;
base_thickness = 4.0;

/* [Mounting holes] */
left_hole_x = -8.15;
right_hole_x = 7.85;
hole_diameter = 3.4;
screw_row_to_panel_edge = 7.855;


/* [Panel fit] */
rib_clearance = 0.50;
guide_height = 10.0;
guide_end_rounding = 2.5;

/* [Seam wedge] */
seam_wedge_width = 3.0;
seam_wedge_height = 4.0;
seam_wedge_length = 30.0;
seam_wedge_end_radius = 1.2;

/* [Reinforcement bushing relief] */
reinforcement_bushing_clearance = 0.45;
reinforcement_bushing_relief_extra_depth = 0.20;

/* [Decorative pockets] */
show_perforation_holes = true;
perforation_hole_diameter = 3.0;
perforation_depth = 2.5;
perforation_spacing = 10.0;
perforation_edge_margin = 7.0;
perforation_centre_keepout = 20.0;

/* [Clip positions] */
clip_x_positions = [-30.0, -10.0, 10.0, 30.0];

/* [Tube clip] */
clip_length = 10.0;
clip_wall = 2.6;
clip_inner_diameter = 10.4;
clip_opening = 8.2;
clip_vertical_overlap = 2.0;
clip_root_height = 6.0;
clip_root_depth = 5.0;

/* [Standalone preview] */
preview_direction = "top"; // [top, bottom]
preview_tube_y = -5.0;
preview_tube_z = 18.0;
preview_color = [0.86, 0.08, 0.05, 1];

/* [Resolution] */
$fn = 64;


// Shared T silhouette is the shared PLUS with one arm clipped away.

// Rear housing T at a top/bottom panel edge.  At an internal seam two side
// rails meet, while the panel end rail forms the horizontal part of the T.
// The end-rail position is derived from the real screw-row-to-edge distance.
module panel_edge_t_keepout_2d(direction, total_width, total_height) {
    vertical_w = 2 * hub75_rear_side_rail_width();
    horizontal_w = hub75_rear_end_rail_width();
    corner_r = hub75_rear_opening_corner_radius();

    edge_sign = direction == "top" ? 1 : -1;
    edge_z = edge_sign * screw_row_to_panel_edge;
    rail_center_z = edge_z - edge_sign * horizontal_w/2;
    rail_inner_z = edge_z - edge_sign * horizontal_w;

    union() {
        // Horizontal top/bottom rear-frame rail.
        translate([0, rail_center_z])
            square([total_width + 6, horizontal_w], center=true);

        // Vertical seam rail continues from the end rail toward panel centre.
        stem_h = total_height + 12;
        translate([
            0,
            rail_inner_z - edge_sign * stem_h/2
        ])
            square([vertical_w, stem_h], center=true);

        // Reproduce the rounded opening corners where end rail and side rails
        // meet.  This avoids a sharp rectangular inside corner in the guide.
        for(sx=[-1,1])
            translate([
                sx*vertical_w/2,
                rail_inner_z
            ])
                scale([sx, -edge_sign])
                    difference() {
                        square([corner_r, corner_r], center=false);
                        translate([corner_r, corner_r])
                            circle(r=corner_r);
                    }
    }
}

module t_side_guides_2d(
    direction,
    width,
    height,
    bar_height,
    stem_width,
    inner_r,
    outer_r,
    clearance,
    end_rounding,
    body_center_z=0
) {
    if(end_rounding > 0)
        offset(r=end_rounding)
            offset(delta=-end_rounding)
                difference() {
                    coupler_t_profile_2d(
                        direction=direction, width=width, height=height,
                        horizontal_arm_height=bar_height, vertical_arm_width=stem_width,
                        inside_radius=inner_r, outside_radius=outer_r
                    );
                    offset(delta=clearance)
                        panel_edge_t_keepout_2d(direction,width,height);
                }
    else
        difference() {
            coupler_t_profile_2d(
                direction=direction, width=width, height=height,
                horizontal_arm_height=bar_height, vertical_arm_width=stem_width,
                inside_radius=inner_r, outside_radius=outer_r
            );
            offset(delta=clearance)
                panel_edge_t_keepout_2d(direction,width,height);
        }
}

module tapered_seam_wedge(
    length,
    base_width,
    tip_width,
    height,
    end_radius
) {
    base_r = min(end_radius, min(base_width, length)/2 - 0.01);
    tip_r  = min(end_radius, min(tip_width,  length)/2 - 0.01);

    hull() {
        translate([0, 0.01, 0])
            rotate([90,0,0])
                linear_extrude(height=0.02)
                    offset(r=base_r)
                        square([
                            max(0.01, base_width - 2*base_r),
                            max(0.01, length - 2*base_r)
                        ], center=true);

        translate([0, -height + 0.01, 0])
            rotate([90,0,0])
                linear_extrude(height=0.02)
                    offset(r=tip_r)
                        square([
                            max(0.01, tip_width - 2*tip_r),
                            max(0.01, length - 2*tip_r)
                        ], center=true);
    }
}


module t_reference_perforations_2d(
    direction,
    width,
    height,
    bar_height,
    stem_width,
    hole_d,
    spacing,
    edge_margin,
    centre_keepout
) {
    // STEP-inspired blind-pocket pattern.  Keep the pattern tied to the
    // printable T body rather than to the old seam-specific dimensions.
    // The final intersection in horizontal_edge_panel_coupler() clips these
    // points to the actual rounded T silhouette.
    sign = direction == "top" ? 1 : -1;
    hh = height/2;
    hy = bar_height/2;

    // One clean row across the broad horizontal arm: two blind pockets
    // on each side of the mounting screw pair.
    row_z = sign * (hy * 0.22);
    for (x=[-34,-24,24,34])
        translate([x, row_z])
            circle(d=hole_d);

    // Two compact rows in the vertical stem, away from the screw pair.
    inward = direction == "top" ? -1 : 1;
    for (zoff=[18, 28])
        for (x=[-spacing/2, spacing/2])
            translate([x, inward*zoff])
                circle(d=hole_d);
}


module horizontal_edge_panel_coupler(
    direction = "top",
    width = overall_width,
    height = overall_height,
    inward_reach_value = inboard_reach,
    max_outside_projection_value = max_outside_projection,
    horizontal_height = horizontal_arm_height,
    vertical_width = vertical_arm_width,
    thickness = base_thickness,
    inside_radius = inside_corner_radius,
    outside_radius = outer_corner_radius,
    left_hole_x_value = left_hole_x,
    right_hole_x_value = right_hole_x,
    hole_diameter_value = hole_diameter,
    rib_clearance_value = rib_clearance,
    guide_height_value = guide_height,
    guide_end_rounding_value = guide_end_rounding,
    show_perforation_holes_value = show_perforation_holes,
    perforation_hole_diameter_value = perforation_hole_diameter,
    perforation_depth_value = perforation_depth,
    perforation_spacing_value = perforation_spacing,
    perforation_edge_margin_value = perforation_edge_margin,
    perforation_centre_keepout_value = perforation_centre_keepout,
    clip_x_positions_value = clip_x_positions,
    seam_wedge_width_value = seam_wedge_width,
    seam_wedge_height_value = seam_wedge_height,
    seam_wedge_length_value = seam_wedge_length,
    bushing_clearance_value = reinforcement_bushing_clearance,
    local_tube_y = preview_tube_y,
    local_tube_z = preview_tube_z,
    clip_length_value = clip_length,
    clip_wall_value = clip_wall,
    clip_inner_diameter_value = clip_inner_diameter,
    clip_opening_value = clip_opening,
    clip_vertical_overlap_value = clip_vertical_overlap,
    clip_root_height_value = clip_root_height,
    clip_root_depth_value = clip_root_depth,
    part_color = preview_color
) {
    body_center_z = 0; // shared T is centred on the panel screw row

    color(part_color)
        union() {
            difference() {
                // Base plate behind the panel mounting plane.
                translate([0, thickness, 0])
                    rotate([90,0,0])
                        linear_extrude(height=thickness)
                            coupler_t_profile_2d(
                                direction=direction, width=width, height=height,
                                horizontal_arm_height=horizontal_height, vertical_arm_width=vertical_width,
                                inside_radius=inside_radius, outside_radius=outside_radius
                            );

                // Existing pair of mounting screws at the panel seam.
                for(x=[left_hole_x_value,right_hole_x_value])
                    translate([x, thickness+0.25, 0])
                        rotate([90,0,0])
                            cylinder(d=hole_diameter_value,h=thickness+0.5,$fn=36);

                // STEP-inspired blind pockets, matching the middle coupler.
                if(show_perforation_holes_value && perforation_depth_value > 0)
                    translate([0, thickness+0.15, 0])
                        rotate([90,0,0])
                            linear_extrude(height=min(perforation_depth_value, thickness-0.2)+0.15)
                                intersection() {
                                    offset(delta=-perforation_edge_margin_value/2)
                                        coupler_t_profile_2d(
                                            direction=direction, width=width, height=height,
                                            horizontal_arm_height=horizontal_height, vertical_arm_width=vertical_width,
                                            inside_radius=inside_radius, outside_radius=outside_radius
                                        );
                                    translate([0, body_center_z])
                                        t_reference_perforations_2d(
                                        direction,width,height,
                                        horizontal_height,vertical_width,
                                        perforation_hole_diameter_value,
                                        perforation_spacing_value,
                                        perforation_edge_margin_value,
                                        perforation_centre_keepout_value
                                    );
                                }
            }

            // 10 mm high fitted guide around the actual HUB75 end/seam ribs.
            // The Ø14 reinforcement bushings are relieved ONLY from this wall;
            // the 4 mm base plate remains continuous underneath them.
            if(guide_height_value > 0)
                difference() {
                    // Only keep guide material on the PANEL side of the real
                    // top/bottom edge.  The earlier version continued the 10 mm
                    // wall outside the panel, creating a large solid fence behind
                    // the aluminium tube and visually swallowing the snap clips.
                    rotate([90,0,0])
                        linear_extrude(height=guide_height_value)
                            intersection() {
                                t_side_guides_2d(
                                    direction,width,height,
                                    horizontal_height,vertical_width,
                                    inside_radius,outside_radius,
                                    rib_clearance_value,
                                    guide_end_rounding_value,
                                    body_center_z
                                );

                                edge_z = direction == "top"
                                    ? screw_row_to_panel_edge
                                    : -screw_row_to_panel_edge;

                                if(direction == "top")
                                    translate([0, edge_z - (height+20)/2])
                                        square([width+20, height+20], center=true);
                                else
                                    translate([0, edge_z + (height+20)/2])
                                        square([width+20, height+20], center=true);
                            }

                    bushing_d = hub75_reinforcement_bushing_outer_diameter();
                    bushing_offset = hub75_reinforcement_bushing_offset();
                    bushing_z = direction == "top" ? -bushing_offset : bushing_offset;
                    relief_depth = guide_height_value + reinforcement_bushing_relief_extra_depth;

                    for(x=[left_hole_x_value,right_hole_x_value])
                        translate([x, 0.15, bushing_z])
                            rotate([90,0,0])
                                cylinder(
                                    d=bushing_d + 2*bushing_clearance_value,
                                    h=relief_depth + 0.30,
                                    $fn=64
                                );
                }

            // A tapered wedge fills the narrow vertical gap between the two
            // adjacent panels. It starts at the outer panel edge and extends
            // inward, mirroring automatically for top and bottom placement.
            if(seam_wedge_height_value > 0 && seam_wedge_width_value > 0 && seam_wedge_length_value > 0) {
                inward_sign = direction == "top" ? -1 : 1;
                wedge_center_z = inward_sign * (seam_wedge_length_value/2 - screw_row_to_panel_edge);
                translate([0, 0, wedge_center_z])
                    tapered_seam_wedge(
                        length=seam_wedge_length_value,
                        base_width=seam_wedge_width_value,
                        tip_width=max(0.8, seam_wedge_width_value*0.73),
                        height=seam_wedge_height_value,
                        end_radius=min(seam_wedge_end_radius, seam_wedge_width_value/2 - 0.01)
                    );
            }
        }

    // Four genuinely separate short C-clips.  Each ring is attached only by
    // a small local root at the real panel edge; there is deliberately no
    // continuous extension wall between neighbouring clips.
    clip_outer_r = (clip_inner_diameter_value + 2*clip_wall_value)/2;
    panel_edge_z = direction == "top"
        ? screw_row_to_panel_edge
        : -screw_row_to_panel_edge;

    for(clip_x=clip_x_positions_value) {
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

        // Local support foot for this individual C-clip.  The support extends
        // from the panel edge TOWARD the clip (outward in Z), so the ring has
        // a real overlap area instead of touching the plate almost tangentially.
        // There is still no continuous bridge between neighbouring clips.
        root_center_z = direction == "top"
            ? panel_edge_z + clip_root_height_value/2
            : panel_edge_z - clip_root_height_value/2;

        color(part_color)
            translate([
                clip_x - clip_length_value/2,
                -clip_root_depth_value + 1.5,
                root_center_z - clip_root_height_value/2
            ])
                cube([
                    clip_length_value,
                    clip_root_depth_value,
                    clip_root_height_value
                ]);
    }
}

// Standalone preview.
horizontal_edge_panel_coupler(direction=preview_direction);
