// HUB75 display frame - V1.2 shared-profile 100 mm horizontal edge panel coupler with two short tube clips
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
wall_thickness = 5.0;
rib_clearance = 0.50;
profile_side_material = wall_thickness + rib_clearance;
horizontal_arm_height = hub75_rear_end_rail_width() + 2*profile_side_material;
vertical_arm_width = 2*12.5 + 2*profile_side_material;
inside_corner_radius = 10.0;
outer_corner_radius = 6.0;
base_thickness = 4.0;

/* [Mounting holes] */
left_hole_x = -8.15;
right_hole_x = 7.85;
hole_diameter = 3.4;
screw_row_to_panel_edge = 7.855;


/* [Panel fit] */
guide_height = 10.0;
guide_end_rounding = 1.5;

/* [Seam wedge] */
seam_wedge_width = 3.0;
seam_wedge_height = 4.0;
seam_wedge_length = 30.0;
seam_wedge_end_radius = 1.2;

/* [Outer display-edge ridge] */
// Keep this low ridge equal in height and taper to the small seam wedge.
outer_ridge_height = seam_wedge_height;
outer_ridge_taper_inset = seam_wedge_width * (1.0 - 0.73) / 2;

/* [Reinforcement bushing relief] */
reinforcement_bushing_clearance = 0.45;
reinforcement_bushing_relief_extra_depth = 0.20;

/* [Locator-pin clearance] */
// The physical panel has a Ø3 x 3 mm locating pin close to each relevant
// horizontal edge coupler.  This is a true through-clearance in the 4 mm
// base plate, not a shallow pocket.
locator_pin_clearance = 0.40;

/* [Decorative pockets] */
show_perforation_holes = true;
perforation_hole_diameter = 3.0;
perforation_depth = 2.5;
perforation_spacing = 10.0;
perforation_edge_margin = 7.0;
perforation_centre_keepout = 20.0;

/* [Clip positions] */
clip_x_positions = [-25.0, 25.0];

/* [Tube clip] */
clip_length = 16.0;
clip_wall = 2.6;
clip_inner_diameter = 10.4;
clip_opening = 8.2;
clip_vertical_overlap = 2.0;
clip_root_height = 6.0;
clip_root_depth = 5.0;
clip_ridge_clearance = 2.5;

/* [Standalone preview] */
preview_direction = "top"; // [top, bottom]
preview_tube_y = -5.0;
preview_tube_z = 18.0;
preview_color = [0.86, 0.08, 0.05, 1];

/* [Resolution] */
$fn = 64;


// Shared T silhouette is the shared PLUS with one arm clipped away.

// The end rail is not centred on the mounting screw row.  Position the
// horizontal T arm around the REAL rail so the printed wall is the same on
// its inward and outward sides.
function panel_end_rail_center_z(direction) =
    (direction == "top" ? 1 : -1)
    * (screw_row_to_panel_edge - hub75_rear_end_rail_width()/2);


// Position of the one panel locator pin that falls under an internal
// horizontal edge coupler.  The offsets are derived by hub75_panel.scad from
// the PDF locator-pin position and mounting-hole pattern.
function edge_locator_pin_x(direction, left_screw_x, right_screw_x) =
    direction == "top"
        ? right_screw_x - hub75_locator_pin_near_edge_screw_x_delta()
        : left_screw_x  + hub75_locator_pin_near_edge_screw_x_delta();

function edge_locator_pin_z(direction) =
    (direction == "top" ? -1 : 1)
    * hub75_locator_pin_edge_screw_z_delta();

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
    horizontal_center_z=0
) {
    if(end_rounding > 0)
        offset(r=end_rounding)
            offset(delta=-end_rounding)
                difference() {
                    coupler_t_profile_2d(
                        direction=direction, width=width, height=height,
                        horizontal_arm_height=bar_height, vertical_arm_width=stem_width,
                        inside_radius=inner_r, outside_radius=outer_r,
                        horizontal_arm_center_z=horizontal_center_z
                    );
                    offset(delta=clearance)
                        panel_edge_t_keepout_2d(direction,width,height);
                }
    else
        difference() {
            coupler_t_profile_2d(
                direction=direction, width=width, height=height,
                horizontal_arm_height=bar_height, vertical_arm_width=stem_width,
                inside_radius=inner_r, outside_radius=outer_r,
                horizontal_arm_center_z=horizontal_center_z
            );
            offset(delta=clearance)
                panel_edge_t_keepout_2d(direction,width,height);
        }
}


module outer_edge_zone_2d(direction, width, height, edge_z, clearance) {
    // Region outside the physical HUB75 panel edge.  The normal fitted guide
    // is suppressed here and rebuilt as a segmented outer ridge so it cannot
    // run through the tube clips.
    zone_h = height + 20;
    if(direction == "top")
        translate([0, edge_z + clearance + zone_h/2])
            square([width + 20, zone_h], center=true);
    else
        translate([0, edge_z - clearance - zone_h/2])
            square([width + 20, zone_h], center=true);
}

module segmented_outer_edge_ridge_2d(
    direction,
    width,
    height,
    bar_height,
    stem_width,
    inner_r,
    outer_r,
    clearance,
    end_rounding,
    horizontal_center_z,
    edge_z,
    clip_positions,
    clip_length,
    clip_clearance
) {
    difference() {
        intersection() {
            t_side_guides_2d(
                direction,width,height,
                bar_height,stem_width,
                inner_r,outer_r,
                clearance,end_rounding,horizontal_center_z
            );
            outer_edge_zone_2d(direction,width,height,edge_z,clearance);
        }

        // Two clip gaps split the outside ridge into three explicit pieces.
        // The gaps are slightly wider than the clips so neither the ridge nor
        // its rounded ends can pass through the C-rings.
        for(cx=clip_positions)
            translate([cx, direction == "top" ? height/2 : -height/2])
                square([clip_length + 2*clip_clearance, height + 30], center=true);
    }
}

module _horizontal_ridge_patch_taper_3d(ridge_height, taper_inset) {
    // Taper ONE connected 2D patch only.  Keeping each patch separate is
    // essential: hull() across the complete interrupted ridge would bridge
    // the clip gaps and recreate a bar through the C-rings.
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

module tapered_segmented_outer_edge_ridge_3d(
    direction,
    width,
    height,
    bar_height,
    stem_width,
    inner_r,
    outer_r,
    clearance,
    end_rounding,
    horizontal_center_z,
    edge_z,
    clip_positions,
    clip_length,
    clip_clearance,
    ridge_height,
    taper_inset
) {
    // With two clips the outside ridge is exactly three independent pieces.
    // Build and taper those pieces independently so no hull operation can
    // bridge the spaces reserved for the snap clips.
    gap_half = clip_length/2 + clip_clearance;
    span = width + 40;
    x0 = clip_positions[0];
    x1 = clip_positions[1];

    intervals = [
        [-span/2, x0-gap_half],
        [x0+gap_half, x1-gap_half],
        [x1+gap_half, span/2]
    ];

    for(interval=intervals) {
        lo = interval[0];
        hi = interval[1];
        if(hi > lo + 0.2)
            _horizontal_ridge_patch_taper_3d(ridge_height,taper_inset)
                intersection() {
                    segmented_outer_edge_ridge_2d(
                        direction,width,height,bar_height,stem_width,
                        inner_r,outer_r,clearance,end_rounding,
                        horizontal_center_z,edge_z,clip_positions,
                        clip_length,clip_clearance
                    );
                    translate([(lo+hi)/2,0])
                        square([hi-lo,height+40],center=true);
                }
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
    row_z = panel_end_rail_center_z(direction) + sign * (hy * 0.22);
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
    locator_pin_clearance_value = locator_pin_clearance,
    local_tube_y = preview_tube_y,
    local_tube_z = preview_tube_z,
    clip_length_value = clip_length,
    clip_wall_value = clip_wall,
    clip_inner_diameter_value = clip_inner_diameter,
    clip_opening_value = clip_opening,
    clip_vertical_overlap_value = clip_vertical_overlap,
    clip_root_height_value = clip_root_height,
    clip_root_depth_value = clip_root_depth,
    clip_ridge_clearance_value = clip_ridge_clearance,
    outer_ridge_height_value = outer_ridge_height,
    outer_ridge_taper_inset_value = outer_ridge_taper_inset,
    part_color = preview_color
) {
    body_center_z = 0;
    horizontal_center_z = panel_end_rail_center_z(direction);

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
                                inside_radius=inside_radius, outside_radius=outside_radius,
                                horizontal_arm_center_z=horizontal_center_z
                            );

                // Existing pair of mounting screws at the panel seam.
                for(x=[left_hole_x_value,right_hole_x_value])
                    translate([x, thickness+0.25, 0])
                        rotate([90,0,0])
                            cylinder(d=hole_diameter_value,h=thickness+0.5,$fn=36);

                // Full through-clearance for the physical Ø3 x 3 mm locator
                // pin.  Unlike the decorative Ø3 pockets below, this cut runs
                // completely through the base plate so the coupler never
                // bears on the locating pin.
                translate([
                    edge_locator_pin_x(direction,left_hole_x_value,right_hole_x_value),
                    thickness + 0.25,
                    edge_locator_pin_z(direction)
                ])
                    rotate([90,0,0])
                        cylinder(
                            d=hub75_locator_pin_diameter() + 2*locator_pin_clearance_value,
                            h=thickness + 0.5,
                            $fn=48
                        );

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
                                            inside_radius=inside_radius, outside_radius=outside_radius,
                                            horizontal_arm_center_z=horizontal_center_z
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
            // Keep the guide on BOTH sides of the top/bottom end rail. This makes
            // the outside display contour a continuous raised ridge and gives the
            // end rail the same printed side-material rule in Z that the seam rail
            // already has in X. The slimmer rib-derived T bar prevents this ridge
            // from becoming the large solid fence seen in earlier revisions.
            // The Ø14 reinforcement bushings are relieved ONLY from this wall;
            // the 4 mm base plate remains continuous underneath them.
            if(guide_height_value > 0)
                difference() {
                    rotate([90,0,0])
                        linear_extrude(height=guide_height_value)
                            // Main 10 mm fitted guide only on the inboard side.
                            // The outer display-edge ridge is deliberately built
                            // separately below at the much lower seam-wedge height.
                            difference() {
                                t_side_guides_2d(
                                    direction,width,height,
                                    horizontal_height,vertical_width,
                                    inside_radius,outside_radius,
                                    rib_clearance_value,
                                    guide_end_rounding_value,
                                    horizontal_center_z
                                );
                                outer_edge_zone_2d(
                                    direction,width,height,
                                    direction == "top" ? screw_row_to_panel_edge : -screw_row_to_panel_edge,
                                    rib_clearance_value
                                );
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

            // Low outer display-edge ridge: three separate X segments so both
            // snap clips stay completely free.  Its height equals the centre
            // seam wedge, and the top is inset to create the same sloped wall.
            if(outer_ridge_height_value > 0)
                color(part_color)
                    difference() {
                        tapered_segmented_outer_edge_ridge_3d(
                            direction,width,height,
                            horizontal_height,vertical_width,
                            inside_radius,outside_radius,
                            rib_clearance_value,guide_end_rounding_value,
                            horizontal_center_z,
                            direction == "top" ? screw_row_to_panel_edge : -screw_row_to_panel_edge,
                            clip_x_positions_value,clip_length_value,
                            clip_ridge_clearance_value,
                            outer_ridge_height_value,
                            outer_ridge_taper_inset_value
                        );

                        // The aluminium tube runs continuously in X.  Therefore
                        // an X-only gap around each clip is not sufficient: the
                        // ridge must also be outside the complete tube envelope.
                        // Use the clip's inner diameter as the fitted tube
                        // clearance, so a Ø10 tube has 0.2 mm radial clearance.
                        tube_axis_keepout(
                            center_x=0,
                            local_tube_y=local_tube_y,
                            local_tube_z=local_tube_z,
                            length=width + 20,
                            diameter=clip_inner_diameter_value
                        );

                        // Also keep the flexible C-ring itself completely free.
                        for(clip_x=clip_x_positions_value)
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

    // Two genuinely separate short C-clips.  Each ring is attached only by
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

        // Tapered support web: strong local connection without the visible
        // rectangular block used in earlier revisions.
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

// Standalone preview.
horizontal_edge_panel_coupler(direction=preview_direction);
