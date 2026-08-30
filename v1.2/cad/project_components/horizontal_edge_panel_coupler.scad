// HUB75 display frame - V1.2 shared-profile horizontal edge panel coupler with two short tube clips
//
// Used for the four upper and four lower internal panel joins at the horizontal display edges.
// The outer corner/end couplers are deliberately a separate component and
// are not changed by this design.
//
// The T-shaped printed body follows the same design language as the middle
// PLUS coupler. Its inward reach follows half of the active profile envelope,
// while only the outward projection is capped below 20 mm.
// Raised guide material sits beside the real HUB75 rear ribs,
// leaving a fitted T-shaped channel for the panel housing.

use <../components/tube_clip.scad>
use <../components/hub75_panel.scad>
use <../components/_lib/panel_fit_geometry.scad>
use <_lib/coupler_profile.scad>
use <_lib/coupler_dimensions.scad>

include <../config/project_config.scad>

/* [T body] */
overall_width = project_coupler_profile_size();
inboard_reach = project_coupler_profile_size()/2;
max_outside_projection = 19.5;
overall_height = project_coupler_profile_size();
// Standalone defaults follow the exact same rule as the project assembly:
// real HUB75 rib width + equal printed material on both sides.
wall_thickness = project_coupler_wall_thickness();
rib_clearance = coupler_fit_clearance_default();
profile_side_material = coupler_project_side_material();
horizontal_arm_height = coupler_project_horizontal_arm_height();
vertical_arm_width = coupler_project_edge_vertical_arm_width();
inside_corner_radius = project_coupler_corner_radius();
outer_corner_radius = project_coupler_edge_radius();
base_thickness = project_coupler_base_thickness();

/* [Mounting holes] */
left_hole_x = hub75_fit_seam_left_hole_x();
right_hole_x = hub75_fit_seam_right_hole_x();
hole_diameter = coupler_screw_hole_diameter_default();
screw_relief_depth = coupler_screw_relief_depth_default();
screw_relief_radial = coupler_screw_relief_radial_default();
screw_row_to_panel_edge = hub75_panel_hole_z_bottom();


/* [Panel fit] */
guide_height = project_coupler_guide_height();
guide_end_rounding = project_coupler_guide_end_rounding();
guide_length = project_coupler_guide_length();

/* [Seam wedge] */
seam_wedge_width = coupler_project_seam_locator_width(rib_clearance);
seam_wedge_height = coupler_seam_wedge_height_default();
seam_wedge_length = inboard_reach;
seam_wedge_end_radius = 1.2;
seam_wedge_lead_in_depth = 0.8;
seam_wedge_lead_in_per_side = min(0.20, rib_clearance);

/* [Outer display-edge ridge] */
// Keep this low ridge equal in height and taper to the small seam wedge.
outer_ridge_height = seam_wedge_height;
// Outer edge ridge is not a seam blade.  Give its low wall a small printable
// taper independent of the (currently zero) inter-panel seam locator width.
outer_ridge_taper_inset = min(0.5, wall_thickness/4);

/* [Reinforcement bushing relief] */
reinforcement_bushing_clearance = coupler_bushing_clearance_default();
reinforcement_bushing_relief_extra_depth = 0.20;

/* [Locator-pin clearance] */
// The physical panel has a Ø3 x 3 mm locating pin close to each relevant
// horizontal edge coupler.  This is a true through-clearance in the 4 mm
// base plate, not a shallow pocket.
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
perforation_edge_margin = 7.0;
perforation_centre_keepout = 20.0;

/* [Clip positions] */
clip_x_positions = [-project_coupler_tube_clip_offset(), project_coupler_tube_clip_offset()];

/* [Tube clip] */
clip_length = 16.0;
clip_wall = tube_clip_wall();
clip_inner_diameter = tube_clip_inner_diameter();
clip_opening = tube_clip_opening();
clip_vertical_overlap = tube_clip_vertical_overlap();
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
    hub75_fit_edge_rear_end_rail_center_z(direction);

// Nominal 320 mm envelope edge relative to the real mounting-hole row.
// This is the geometric + reference for the horizontal edge coupler.
function panel_nominal_edge_reference_z(direction) =
    hub75_fit_edge_nominal_reference_z(direction);

// Public comparison/inspection anchor: the engraved + lies on this nominal
// 320 mm panel edge, expressed in the screw-centred local component system.
function horizontal_edge_panel_coupler_reference_z(direction="top") =
    panel_nominal_edge_reference_z(direction);

// Keep the original rail-fitted T profile intact and only trim its far
// inboard end so the printed arm reaches exactly `inward_reach_value` from
// the nominal 320 mm panel edge.  This avoids shifting the horizontal arm or
// its guide away from the real rear end rail.
module edge_profile_2d(
    direction, width, height, bar_height, stem_width, inner_r, outer_r,
    horizontal_center_z, inward_reach_value
) {
    nominal_z = panel_nominal_edge_reference_z(direction);
    limit_z = nominal_z + (direction == "top" ? -inward_reach_value : inward_reach_value);

    // Do not hard-clip the far end of the T stem: that removed the normal R6
    // outside corner and left the edge coupler with a square bottom.  Instead
    // choose a symmetric PLUS/T source height whose inward end lands exactly
    // on the nominal 320 mm reference reach.  coupler_t_profile_2d then keeps
    // the same rounded end treatment as the rest of the coupler family.
    effective_height = 2*abs(limit_z);

    coupler_t_profile_2d(
        direction=direction, width=width, height=effective_height,
        horizontal_arm_height=bar_height, vertical_arm_width=stem_width,
        inside_radius=inner_r, outside_radius=outer_r,
        horizontal_arm_center_z=horizontal_center_z
    );
}


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
    vertical_w = coupler_project_edge_seam_keepout_width();
    horizontal_w = hub75_fit_rear_end_rail_width();
    corner_r = hub75_rear_opening_corner_radius();

    edge_sign = direction == "top" ? 1 : -1;
    // Canonical rear outer edge in this coupler's screw-row-centred system.
    edge_z = hub75_fit_edge_rear_outer_edge_z(direction);
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
    horizontal_center_z=0,
    inward_reach_value=inboard_reach,
    guide_length_value=1e6
) {
    // Keep the small-profile guide structurally intact: guide rounding must not
    // be implemented by eroding the complete fitted shell.  Limit only its
    // X reach; the plate profile itself supplies the curved outer envelope.
    intersection() {
        square([2*guide_length_value, height + 40], center=true);
        difference() {
            edge_profile_2d(
                direction,width,height,bar_height,stem_width,
                inner_r,outer_r,horizontal_center_z,inward_reach_value
            );
            offset(delta=clearance)
                panel_edge_t_keepout_2d(direction,width,height);
        }
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

module seam_locator_wedge(
    length,
    width,
    height,
    end_radius,
    lead_in_depth=0.8,
    lead_in_per_side=0.2
) {
    // The locator is sized from the real REAR seam gap with print clearance
    // removed on both sides.  Taper the complete height symmetrically instead
    // of using a parallel body plus a short insertion nose.
    tip_width = max(0.6, width - 2*lead_in_per_side);
    r0 = min(end_radius, min(width, length)/2 - 0.01);
    r1 = min(end_radius, min(tip_width, length)/2 - 0.01);

    module rounded_section(w, r) {
        offset(r=r)
            square([
                max(0.01, w - 2*r),
                max(0.01, length - 2*r)
            ], center=true);
    }

    hull() {
        translate([0,-0.01,0])
            rotate([90,0,0])
                linear_extrude(height=0.02)
                    rounded_section(width, r0);
        translate([0,-height+0.01,0])
            rotate([90,0,0])
                linear_extrude(height=0.02)
                    rounded_section(tip_width, r1);
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
    centre_keepout,
    horizontal_center_offset_z,
    reference_steps = project_coupler_reference_steps(),
    reference_pitch = coupler_reference_pocket_pitch_default(),
    reference_lane_offset = coupler_reference_pocket_lane_offset_default()
) {
    // Build the pocket raster from a SYMMETRIC virtual cross first.
    //
    // This module is called in coordinates centred on the nominal panel edge.
    // The real horizontal arm is asymmetric around that reference because it
    // follows the physical HUB75 end rail.  That asymmetry must not determine
    // a special one-row pocket coordinate.
    //
    // Instead we derive one common hole-centre-to-arm-edge inset from the
    // symmetric vertical stem.  We mirror the real inboard half of the
    // horizontal arm around the nominal edge to make a virtual symmetric arm,
    // place TWO rows on that virtual arm using the same edge inset, and let the
    // actual T silhouette remove the unsupported outside row.
    //
    // Result: the remaining horizontal row and the vertical rows have exactly
    // the same centre-to-edge distance, for all named profiles and custom mode
    // dimensions, without profile-specific correction constants.
    inward = direction == "top" ? -1 : 1;

    z_arm_lane = is_undef(reference_lane_offset)
        ? coupler_reference_lane_offset_for_arm(stem_width)
        : reference_lane_offset;

    // Reference design quantity shared by both perpendicular arms.
    shared_edge_inset = stem_width/2 - z_arm_lane;

    // In this local coordinate system Z=0 is the nominal panel edge.
    // Mirror the REAL inboard edge to obtain the symmetric virtual arm.
    real_inboard_edge_z = horizontal_center_offset_z + inward*bar_height/2;
    virtual_horizontal_half = abs(real_inboard_edge_z);
    x_arm_lane = max(0, virtual_horizontal_half - shared_edge_inset);

    z_lane_signs = coupler_reference_two_lanes_fit(stem_width, hole_d)
        ? [-1,1]
        : [0];

    // Always generate the horizontal raster symmetrically. The intersection
    // with the actual edge profile in the caller removes the row that lies in
    // the missing/asymmetric part of the T.
    for (sx=[-1,1])
        coupler_reference_pocket_strip_2d(
            axis="x", direction_sign=sx, lane_signs=[-1,1],
            steps=reference_steps, pitch=reference_pitch, hole_d=hole_d,
            lane_offset=x_arm_lane
        );

    // The vertical stem is already symmetric and supplies the reference inset.
    coupler_reference_pocket_strip_2d(
        axis="z", direction_sign=inward, lane_signs=z_lane_signs,
        steps=reference_steps, pitch=reference_pitch, hole_d=hole_d,
        lane_offset=z_arm_lane
    );
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
    screw_relief_depth_value = screw_relief_depth,
    screw_relief_radial_value = screw_relief_radial,
    rib_clearance_value = rib_clearance,
    guide_height_value = guide_height,
    guide_end_rounding_value = guide_end_rounding,
    show_perforation_holes_value = show_perforation_holes,
    perforation_hole_diameter_value = perforation_hole_diameter,
    perforation_depth_value = perforation_depth,
    perforation_spacing_value = perforation_spacing,
    perforation_edge_margin_value = perforation_edge_margin,
    perforation_centre_keepout_value = perforation_centre_keepout,
    reference_pocket_steps_value = project_coupler_reference_steps(),
    reference_pocket_pitch_value = coupler_reference_pocket_pitch_default(),
    reference_pocket_lane_offset_value = coupler_reference_pocket_lane_offset_default(),
    show_center_marks_value = show_center_marks,
    center_mark_depth_value = center_mark_depth,
    center_mark_pitch_value = center_mark_pitch,
    center_mark_dash_length_value = center_mark_dash_length,
    center_mark_dash_width_value = center_mark_dash_width,
    center_mark_cross_length_value = center_mark_cross_length,
    center_mark_edge_margin_value = center_mark_edge_margin,
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
    nominal_edge_z = panel_nominal_edge_reference_z(direction);
    horizontal_center_z = panel_end_rail_center_z(direction);

    color(part_color)
        union() {
            difference() {
                // Base plate behind the panel mounting plane.
                translate([0, thickness, 0])
                    rotate([90,0,0])
                        linear_extrude(height=thickness)
                            edge_profile_2d(
                                direction,width,height,horizontal_height,vertical_width,
                                inside_radius,outside_radius,horizontal_center_z,inward_reach_value
                            );

                // Existing pair of mounting screws at the panel seam.
                for(x=[left_hole_x_value,right_hole_x_value])
                    translate([x,0,0])
                        coupler_screw_hole_y(
                            hole_diameter=hole_diameter_value,
                            plate_thickness=thickness,
                            relief_depth=screw_relief_depth_value,
                            relief_radial=screw_relief_radial_value,
                            fn=48
                        );

                // Full through-clearance for the physical Ø3 x 3 mm locator
                // pin.  Unlike the decorative Ø3 pockets below, this cut runs
                // completely through the base plate so the coupler never
                // bears on the locating pin.
                translate([
                    edge_locator_pin_x(direction,left_hole_x_value,right_hole_x_value),
                    0,
                    edge_locator_pin_z(direction)
                ])
                    coupler_through_hole_y_with_relief(
                        hole_diameter=hub75_locator_pin_diameter() + 2*locator_pin_clearance_value,
                        y_max=thickness,
                        y_min=0,
                        relief_depth=screw_relief_depth_value,
                        relief_radial=screw_relief_radial_value,
                        fn=48
                    );

                // STEP-inspired blind pockets, matching the middle coupler.
                if(show_perforation_holes_value && perforation_depth_value > 0)
                    translate([0, thickness+0.15, 0])
                        rotate([90,0,0])
                            linear_extrude(height=min(perforation_depth_value, thickness-0.2)+0.15)
                                intersection() {
                                    offset(delta=-perforation_edge_margin_value/2)
                                        edge_profile_2d(
                                            direction,width,height,horizontal_height,vertical_width,
                                            inside_radius,outside_radius,horizontal_center_z,inward_reach_value
                                        );
                                    translate([0, nominal_edge_z])
                                        t_reference_perforations_2d(
                                        direction,width,height,
                                        horizontal_height,vertical_width,
                                        perforation_hole_diameter_value,
                                        perforation_spacing_value,
                                        perforation_edge_margin_value,
                                        perforation_centre_keepout_value,
                                        horizontal_center_z - nominal_edge_z,
                                        reference_pocket_steps_value,
                                        reference_pocket_pitch_value,
                                        reference_pocket_lane_offset_value
                                    );
                                }

                if(show_center_marks_value && center_mark_depth_value > 0)
                    translate([0, thickness+0.15, 0])
                        rotate([90,0,0])
                            linear_extrude(height=min(center_mark_depth_value, thickness-0.2)+0.15)
                                intersection() {
                                    offset(delta=-center_mark_edge_margin_value)
                                        edge_profile_2d(
                                            direction,width,height,horizontal_height,vertical_width,
                                            inside_radius,outside_radius,horizontal_center_z,inward_reach_value
                                        );
                                    translate([0, nominal_edge_z])
                                        coupler_center_marks_2d(
                                            span_x=width, span_z=height,
                                            pitch=center_mark_pitch_value,
                                            dash_length=center_mark_dash_length_value,
                                            dash_width=center_mark_dash_width_value,
                                            cross_length=center_mark_cross_length_value,
                                            keepout_points=[
                                                [left_hole_x_value,-nominal_edge_z],
                                                [right_hole_x_value,-nominal_edge_z]
                                            ],
                                            keepout_radius=hole_diameter_value/2 + coupler_center_mark_screw_keepout_default()
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
                                    horizontal_center_z,
                                    inward_reach_value,
                                    guide_length
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

            // Positive locating features for the two panel reinforcement
            // bushings at this edge seam. They occupy the circular recesses
            // that are already cleared from the 10 mm guide wall.
            bushing_offset = hub75_reinforcement_bushing_offset();
            bushing_z = direction == "top" ? -bushing_offset : bushing_offset;
            for(x=[left_hole_x_value,right_hole_x_value])
                translate([x, 0, bushing_z])
                    coupler_reinforcement_locator_y(
                        recess_diameter=hub75_reinforcement_bushing_recess_diameter(),
                        recess_depth=hub75_reinforcement_bushing_recess_depth(),
                        hole_diameter=hub75_reinforcement_bushing_hole_diameter()
                    );

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
                wedge_center_z = nominal_edge_z + inward_sign * seam_wedge_length_value/2;
                translate([0, 0, wedge_center_z])
                    seam_locator_wedge(
                        length=seam_wedge_length_value,
                        width=seam_wedge_width_value,
                        height=seam_wedge_height_value,
                        end_radius=min(seam_wedge_end_radius, seam_wedge_width_value/2 - 0.01),
                        lead_in_depth=seam_wedge_lead_in_depth,
                        lead_in_per_side=seam_wedge_lead_in_per_side
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
