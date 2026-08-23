// HUB75 display frame - V1.2 middle panel coupler V62
//
// V16 keeps the rounded PLUS footprint and 10 mm rib-following guide.
// Cosmetic Ø3 mm holes are now 2.5 mm deep blind pockets.
// Raised-guide end transitions are softened, and a dedicated fit-check view
// overlays the real HUB75 rib keep-out without using transparency.

/* [Base plate] */
base_thickness = coupler_base_thickness_default();
overall_width = coupler_profile_size_default();
overall_height = coupler_profile_size_default();
// Standalone defaults follow the exact same rule as the project assembly:
// real HUB75 rib width + equal printed material on both sides.
wall_thickness = coupler_wall_thickness_default();
fit_clearance = coupler_fit_clearance_default();
profile_side_material = wall_thickness + fit_clearance;
horizontal_arm_height = hub75_rear_middle_rib_width() + 2*profile_side_material;
vertical_arm_width = 2*hub75_rear_side_rail_width() + 2*profile_side_material;
inside_corner_radius = coupler_profile_inside_radius_default();
outer_corner_radius = coupler_profile_outside_radius_default();

/* [Raised rib guides] */
reinforcement_height = coupler_guide_height_default();
rib_clearance = coupler_fit_clearance_default();
guide_end_rounding = coupler_guide_end_rounding_default();

/* [Mounting screws] */
left_screw_x = hub75_panel_hole_x_right() - hub75_panel_nominal_width();
right_screw_x = hub75_panel_hole_x_left();
screw_hole_diameter = coupler_screw_hole_diameter_default();
screw_relief_depth = coupler_screw_relief_depth_default();
screw_relief_radial = coupler_screw_relief_radial_default();

/* [Reference-style perforation pattern] */
show_perforation_holes = true;
perforation_hole_diameter = coupler_reference_pocket_diameter_default();
perforation_spacing = 10.0;
perforation_edge_margin = 8.0;
perforation_centre_keepout = 22.0;
perforation_depth = coupler_reference_pocket_depth_default();

/* [Centre reference marks] */
show_center_marks = true;
center_mark_depth = coupler_center_mark_depth_default();
center_mark_pitch = coupler_center_mark_pitch_default();
center_mark_dash_length = coupler_center_mark_dash_length_default();
center_mark_dash_width = coupler_center_mark_dash_width_default();
center_mark_cross_length = coupler_center_mark_cross_length_default();
center_mark_edge_margin = coupler_center_mark_edge_margin_default();

/* [Small protruding mounting tubes] */
mounting_tube_outer_diameter = hub75_panel_mounting_tube_outer_diameter();
mounting_tube_clearance = coupler_bushing_clearance_default();
mounting_tube_pocket_depth = 0.90;

/* [Centre seam rib] */
centre_locator_x = 0.0;
centre_locator_z = 0.0;
// Kept as legacy parameters for assembly compatibility; V12 uses a tapered rib.
centre_locator_diameter = 2.10;
centre_locator_height = 2.0;
centre_seam_rib_length = overall_height;
centre_seam_rib_base_width = 3.0;
centre_seam_rib_tip_width = 2.2;
centre_seam_rib_height = 4.0;
centre_seam_rib_end_radius = 1.0;
reinforcement_bushing_clearance = coupler_bushing_clearance_default();
reinforcement_bushing_relief_extra_depth = 0.20;

/* [Preview] */
preview_color = [0.72, 0.05, 0.04, 1];
show_print_orientation = false;

/* [Resolution] */
$fn = 96;

use <../components/hub75_panel.scad>
use <_lib/coupler_profile.scad>


// Shared PLUS/T silhouette is defined in _lib/coupler_profile.scad.

// Raised material lives BESIDE the panel ribs.  The free cross in the middle
// is derived from the actual rear-frame dimensions in hub75_panel.scad:
//   horizontal channel = 20 mm middle crossbar + clearance
//   vertical channel   = 2 x 12.5 mm side rail at the panel seam + clearance
// This makes the printed part wrap around the rib cross instead of adding
// material directly on top of it.
module rib_cross_keepout_2d(horizontal_rib_w, vertical_rib_w, corner_r) {
    hh = horizontal_rib_w/2;
    hv = vertical_rib_w/2;
    r = max(0, corner_r);

    union() {
        // Main horizontal and vertical ribs.
        square([overall_width + 4, horizontal_rib_w], center=true);
        square([vertical_rib_w, overall_height + 4], center=true);

        // Material in the four rounded bay corners.  A HUB75 bay is a rounded
        // rectangle, so the rib intersection is NOT a sharp rectangular +.
        // Each block-minus-quarter-circle reproduces the panel's 5 mm corner.
        for (sx=[-1,1], sz=[-1,1])
            scale([sx, sz])
                translate([hv, hh])
                    difference() {
                        square([r, r], center=false);
                        translate([r, r])
                            circle(r=r);
                    }
    }
}


module rib_side_guides_2d(
    width,
    height,
    h_arm_height,
    v_arm_width,
    inner_r,
    outer_r,
    clearance,
    end_rounding=0
) {
    horizontal_rib_w = hub75_rear_middle_rib_width();
    vertical_rib_w = 2 * hub75_rear_side_rail_width();
    opening_corner_r = hub75_rear_opening_corner_radius();

    // First form the exact guide around the real rib keep-out, then apply a
    // small 2D opening operation. This softens the exposed guide endpoints
    // where the high wall terminates at the PLUS outline, instead of leaving
    // the little pointed/triangular corner visible in V15.
    if (end_rounding > 0)
        offset(r=end_rounding)
            offset(delta=-end_rounding)
                difference() {
                    coupler_plus_profile_2d(
                        width, height,
                        h_arm_height, v_arm_width,
                        inner_r, outer_r
                    );
                    offset(delta=clearance)
                        rib_cross_keepout_2d(
                            horizontal_rib_w,
                            vertical_rib_w,
                            opening_corner_r
                        );
                }
    else
        difference() {
            coupler_plus_profile_2d(
                width, height,
                h_arm_height, v_arm_width,
                inner_r, outer_r
            );
            offset(delta=clearance)
                rib_cross_keepout_2d(
                    horizontal_rib_w,
                    vertical_rib_w,
                    opening_corner_r
                );
        }
}

// Rib that enters the small gap between adjacent panels.  It is widest at
// the coupler base and becomes slightly narrower toward the panel side.
module tapered_seam_rib(
    length,
    base_width,
    tip_width,
    height,
    end_radius
) {
    // The rib enters the narrow panel-to-panel seam in -Y.
    // Its X width tapers gently from base_width to tip_width.
    // Rounded X/Z end profiles avoid a sharp-ended locating blade.
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


// Small Ø3 mm reference-style perforations inspired by the STEP bracket.
// They are deliberately kept away from the centre mounting/seam zone and
// from the outer edge. They are cosmetic/lightening holes, not fasteners.
module reference_perforations_2d(
    width,
    height,
    h_arm_height,
    v_arm_width,
    hole_d,
    spacing,
    edge_margin,
    centre_keepout,
    reference_steps = coupler_reference_pocket_steps_default(),
    reference_pitch = coupler_reference_pocket_pitch_default(),
    reference_lane_offset = coupler_reference_pocket_lane_offset_default()
) {
    // Shared adaptive layout. The longitudinal stations are 20/30/40 mm.
    // Wide arms use two lanes at roughly 1/4 and 3/4 of the real thickness;
    // narrow arms use one centred lane instead of forcing a 2 x 3 pattern.
    x_arm_lane = is_undef(reference_lane_offset)
        ? coupler_reference_lane_offset_for_arm(h_arm_height)
        : reference_lane_offset;
    z_arm_lane = is_undef(reference_lane_offset)
        ? coupler_reference_lane_offset_for_arm(v_arm_width)
        : reference_lane_offset;

    x_lane_signs = coupler_reference_lane_signs_for_arm(h_arm_height);
    z_lane_signs = coupler_reference_lane_signs_for_arm(v_arm_width);

    for (sx=[-1,1])
        coupler_reference_pocket_strip_2d(
            axis="x", direction_sign=sx, lane_signs=x_lane_signs,
            steps=reference_steps, pitch=reference_pitch, hole_d=hole_d,
            lane_offset=x_arm_lane
        );

    for (sz=[-1,1])
        coupler_reference_pocket_strip_2d(
            axis="z", direction_sign=sz, lane_signs=z_lane_signs,
            steps=reference_steps, pitch=reference_pitch, hole_d=hole_d,
            lane_offset=z_arm_lane
        );
}

module middle_panel_coupler(
    width = overall_width,
    height = overall_height,
    horizontal_height = horizontal_arm_height,
    vertical_width = vertical_arm_width,
    thickness = base_thickness,
    inside_radius = inside_corner_radius,
    outside_radius = outer_corner_radius,

    left_hole_x_value = left_screw_x,
    right_hole_x_value = right_screw_x,
    hole_diameter_value = screw_hole_diameter,
    screw_relief_depth_value = screw_relief_depth,
    screw_relief_radial_value = screw_relief_radial,

    mounting_tube_outer_diameter_value = mounting_tube_outer_diameter,
    mounting_tube_clearance_value = mounting_tube_clearance,
    mounting_tube_pocket_depth_value = mounting_tube_pocket_depth,

    centre_locator_x_value = centre_locator_x,
    centre_locator_z_value = centre_locator_z,
    centre_locator_diameter_value = centre_locator_diameter,
    centre_locator_height_value = centre_locator_height,

    guide_wall_thickness_value = rib_clearance,
    guide_wall_height_value = reinforcement_height,
    guide_wall_straight_value = 0,
    centre_rib_width_value = centre_seam_rib_base_width,
    centre_rib_height_value = centre_seam_rib_height,
    centre_rib_length_value = centre_seam_rib_length,
    reinforcement_pad_depth_value = 0,
    reinforcement_pad_length_value = 0,
    reinforcement_pad_height_value = 0,

    show_perforation_holes_value = show_perforation_holes,
    perforation_hole_diameter_value = perforation_hole_diameter,
    perforation_spacing_value = perforation_spacing,
    perforation_edge_margin_value = perforation_edge_margin,
    perforation_centre_keepout_value = perforation_centre_keepout,
    perforation_depth_value = perforation_depth,
    reference_pocket_steps_value = coupler_reference_pocket_steps_default(),
    reference_pocket_pitch_value = coupler_reference_pocket_pitch_default(),
    reference_pocket_lane_offset_value = coupler_reference_pocket_lane_offset_default(),
    show_center_marks_value = show_center_marks,
    center_mark_depth_value = center_mark_depth,
    center_mark_pitch_value = center_mark_pitch,
    center_mark_dash_length_value = center_mark_dash_length,
    center_mark_dash_width_value = center_mark_dash_width,
    center_mark_cross_length_value = center_mark_cross_length,
    center_mark_edge_margin_value = center_mark_edge_margin,
    guide_end_rounding_value = guide_end_rounding,

    part_color = preview_color
) {
    color(part_color)
        union() {
            difference() {
                // Main PLUS base; orientation kept compatible with assembly.
                // The mounting face is local Y=0.  The plate itself must
                // live behind the panel, from Y=0 .. +thickness.
                translate([0, thickness, 0])
                    rotate([90,0,0])
                        linear_extrude(height=thickness)
                            coupler_plus_profile_2d(
                            width, height,
                            horizontal_height, vertical_width,
                            inside_radius, outside_radius
                        );

                // Two screw holes through the base and raised layer.
                for (x=[left_hole_x_value, right_hole_x_value])
                    translate([x, 0, 0])
                        coupler_screw_hole_y(
                            hole_diameter=hole_diameter_value,
                            plate_thickness=thickness,
                            through_front_extra=guide_wall_height_value,
                            relief_depth=screw_relief_depth_value,
                            relief_radial=screw_relief_radial_value
                        );

                // Shallow pockets for the panel locator tubes.
                for (x=[left_hole_x_value, right_hole_x_value])
                    translate([x, mounting_tube_pocket_depth_value, 0])
                        rotate([90,0,0])
                            cylinder(
                                d=mounting_tube_outer_diameter_value + mounting_tube_clearance_value,
                                h=mounting_tube_pocket_depth_value + 0.15
                            );

                // STEP-inspired Ø3 mm decorative pockets. They are blind:
                // cut from the visible rear face into the plate, not through it.
                if (show_perforation_holes_value && perforation_depth_value > 0)
                    translate([0, thickness + 0.15, 0])
                        rotate([90,0,0])
                            linear_extrude(height=min(perforation_depth_value, thickness-0.2) + 0.15)
                                intersection() {
                                    // Clip the pattern to an inset of the true plus outline.
                                    offset(delta=-perforation_edge_margin_value/2)
                                        coupler_plus_profile_2d(
                                            width, height,
                                            horizontal_height, vertical_width,
                                            inside_radius, outside_radius
                                        );
                                    reference_perforations_2d(
                                        width, height,
                                        horizontal_height, vertical_width,
                                        perforation_hole_diameter_value,
                                        perforation_spacing_value,
                                        perforation_edge_margin_value,
                                        perforation_centre_keepout_value,
                                        reference_pocket_steps_value,
                                        reference_pocket_pitch_value,
                                        reference_pocket_lane_offset_value
                                    );
                                }

                // Shallow dashed X/Z centre-reference marks on the visible rear
                // face.  At only 0.4 mm deep by default they remain printable
                // even when this face is placed on the bed, while avoiding a
                // continuous structural groove across the part.
                if (show_center_marks_value && center_mark_depth_value > 0)
                    translate([0, thickness + 0.15, 0])
                        rotate([90,0,0])
                            linear_extrude(height=min(center_mark_depth_value, thickness-0.2) + 0.15)
                                intersection() {
                                    offset(delta=-center_mark_edge_margin_value)
                                        coupler_plus_profile_2d(
                                            width, height,
                                            horizontal_height, vertical_width,
                                            inside_radius, outside_radius
                                        );
                                    coupler_center_marks_2d(
                                        span_x=width, span_z=height,
                                        pitch=center_mark_pitch_value,
                                        dash_length=center_mark_dash_length_value,
                                        dash_width=center_mark_dash_width_value,
                                        cross_length=center_mark_cross_length_value,
                                        keepout_points=[[left_hole_x_value,0],[right_hole_x_value,0]],
                                        keepout_radius=hole_diameter_value/2 + coupler_center_mark_screw_keepout_default()
                                    );
                                }

            }

            // Raised guides beside the actual panel rib cross.
            // guide_wall_thickness_value is used as fitting clearance here
            // for backwards-compatible assembly wiring.
            if (guide_wall_height_value > 0)
                difference() {
                    rotate([90,0,0])
                        linear_extrude(height=guide_wall_height_value)
                            rib_side_guides_2d(
                                width, height,
                                horizontal_height, vertical_width,
                                inside_radius, outside_radius,
                                guide_wall_thickness_value,
                                guide_end_rounding_value
                            );

                    // The two separate HUB75 reinforcement bushings protrude
                    // from the rear face into this raised guide.  Remove only
                    // the interfering part of the WALL; keep the base intact.
                    bushing_d = hub75_reinforcement_bushing_outer_diameter();
                    bushing_offset = hub75_reinforcement_bushing_offset();
                    // Cut the bushing relief through the FULL guide height.
                    // The bushing must notch the wall, not leave a thin lip
                    // projecting behind it.
                    bushing_relief_depth =
                        guide_wall_height_value
                        + reinforcement_bushing_relief_extra_depth;

                    for (p=[
                        [left_hole_x_value, -bushing_offset],
                        [right_hole_x_value, bushing_offset]
                    ])
                        translate([p[0], 0.15, p[1]])
                            rotate([90,0,0])
                                cylinder(
                                    d=bushing_d + 2*reinforcement_bushing_clearance,
                                    h=bushing_relief_depth + 0.30
                                );
                }

            // Positive locating features matching the panel reinforcement
            // bushings. The guide wall is already relieved around the Ø14
            // boss; this Ø9.4 pad enters the panel recess and the Ø2.1 pin
            // locates in its small blind centre hole.
            bushing_offset = hub75_reinforcement_bushing_offset();
            for (p=[
                [left_hole_x_value, -bushing_offset],
                [right_hole_x_value, bushing_offset]
            ])
                translate([p[0], 0, p[1]])
                    coupler_reinforcement_locator_y(
                        recess_diameter=hub75_reinforcement_bushing_recess_diameter(),
                        recess_depth=hub75_reinforcement_bushing_recess_depth(),
                        hole_diameter=hub75_reinforcement_bushing_hole_diameter()
                    );

            // Replace the old single locator pin with a larger tapered rib
            // that enters the narrow seam between the two adjacent displays.
            if (centre_rib_height_value > 0 && centre_rib_width_value > 0 && centre_rib_length_value > 0)
                translate([centre_locator_x_value, 0, centre_locator_z_value])
                    tapered_seam_rib(
                        length=centre_rib_length_value,
                        base_width=centre_rib_width_value,
                        tip_width=max(0.8, centre_rib_width_value * 0.73),
                        height=centre_rib_height_value,
                        end_radius=min(centre_seam_rib_end_radius, centre_rib_width_value/2 - 0.01)
                    );
        }
}



// Fit inspection is implemented as a real two-panel section in
// assemblies/middle_panel_coupler_fit_section.scad.

module middle_panel_coupler_print_orientation(part_color = preview_color) {
    rotate([180,0,0])
        middle_panel_coupler(part_color=part_color);
}


if (show_print_orientation)
    middle_panel_coupler_print_orientation();
else
    middle_panel_coupler();
