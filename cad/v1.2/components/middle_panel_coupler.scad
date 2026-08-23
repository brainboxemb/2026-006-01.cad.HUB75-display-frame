// HUB75 display frame - V1.2 middle coupler V36
//
// V16 keeps the rounded PLUS footprint and 10 mm rib-following guide.
// Cosmetic Ø3 mm holes are now 2.5 mm deep blind pockets.
// Raised-guide end transitions are softened, and a dedicated fit-check view
// overlays the real HUB75 rib keep-out without using transparency.

/* [Base plate] */
base_thickness = 4.0;
overall_width = 100.0;
overall_height = 100.0;
// Standalone defaults follow the exact same rule as the project assembly:
// real HUB75 rib width + equal printed material on both sides.
wall_thickness = 5.0;
fit_clearance = 0.50;
profile_side_material = wall_thickness + fit_clearance;
horizontal_arm_height = 20.0 + 2*profile_side_material;
vertical_arm_width = 2*12.5 + 2*profile_side_material;
inside_corner_radius = 10.0;
outer_corner_radius = 6.0;

/* [Raised rib guides] */
reinforcement_height = 10.0;
rib_clearance = 0.50;
guide_end_rounding = 1.5;

/* [Mounting screws] */
left_screw_x = -8.15;
right_screw_x = 7.85;
screw_hole_diameter = 3.4;

/* [Reference-style perforation pattern] */
show_perforation_holes = true;
perforation_hole_diameter = 3.0;
perforation_spacing = 9.0;
perforation_edge_margin = 8.0;
perforation_centre_keepout = 22.0;
perforation_depth = 2.5;

/* [Small protruding mounting tubes] */
mounting_tube_outer_diameter = 8.50;
mounting_tube_clearance = 0.45;
mounting_tube_pocket_depth = 0.90;

/* [Centre seam rib] */
centre_locator_x = 0.0;
centre_locator_z = 0.0;
// Kept as legacy parameters for assembly compatibility; V12 uses a tapered rib.
centre_locator_diameter = 2.10;
centre_locator_height = 2.0;
centre_seam_rib_length = 30.0;
centre_seam_rib_base_width = 3.0;
centre_seam_rib_tip_width = 2.2;
centre_seam_rib_height = 4.0;
centre_seam_rib_end_radius = 1.0;
reinforcement_bushing_clearance = 0.45;
reinforcement_bushing_relief_extra_depth = 0.20;

/* [Preview] */
preview_color = [0.72, 0.05, 0.04, 1];
show_print_orientation = false;

/* [Resolution] */
$fn = 96;

use <hub75_panel.scad>
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
    centre_keepout
) {
    hw = width/2;
    hh = height/2;
    vx = v_arm_width/2;
    hy = h_arm_height/2;

    // Horizontal arms: two compact rows on both sides.
    for (sx=[-1,1])
        for (x=[centre_keepout + spacing/2 : spacing : hw-edge_margin])
            for (z=[-spacing/2, spacing/2])
                translate([sx*x, z]) circle(d=hole_d);

    // Vertical arms: two compact columns above and below.
    for (sz=[-1,1])
        for (z=[centre_keepout + spacing/2 : spacing : hh-edge_margin])
            for (x=[-spacing/2, spacing/2])
                translate([x, sz*z]) circle(d=hole_d);
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
    centre_rib_width_value = 0,
    centre_rib_height_value = 0,
    centre_rib_length_value = 0,
    reinforcement_pad_depth_value = 0,
    reinforcement_pad_length_value = 0,
    reinforcement_pad_height_value = 0,

    show_perforation_holes_value = show_perforation_holes,
    perforation_hole_diameter_value = perforation_hole_diameter,
    perforation_spacing_value = perforation_spacing,
    perforation_edge_margin_value = perforation_edge_margin,
    perforation_centre_keepout_value = perforation_centre_keepout,
    perforation_depth_value = perforation_depth,
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
                    translate([x, thickness + 0.25, 0])
                        rotate([90,0,0])
                            cylinder(
                                d=hole_diameter_value,
                                h=thickness + guide_wall_height_value + 0.50
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
                                        perforation_centre_keepout_value
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
