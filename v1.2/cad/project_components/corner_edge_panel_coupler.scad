// HUB75 display frame - V1.2 corner edge panel coupler
//
// One printable component is mirrored/oriented for all four display corners.
// It shares the same active-profile rounded language as the middle PLUS and
// horizontal-edge T couplers, but is cropped around one outside panel corner.
// The body follows the real HUB75 side/end rails and uses short local tube
// clips so each snap requires less force.

use <../components/tube_clip.scad>
use <../components/hub75_panel.scad>
use <_lib/coupler_profile.scad>
use <_lib/coupler_dimensions.scad>

include <../config/project_config.scad>

/* [Profile] */
profile_size = project_coupler_profile_size();
wall_thickness = project_coupler_wall_thickness();
fit_clearance = coupler_fit_clearance_default();
profile_side_material = coupler_project_side_material();
horizontal_arm_height = coupler_project_horizontal_arm_height();
vertical_arm_width = coupler_project_corner_vertical_arm_width();
inside_corner_radius = project_coupler_corner_radius();
outside_corner_radius = project_coupler_edge_radius();
base_thickness = project_coupler_base_thickness();
max_outside_projection = 19.5;

/* [Mounting] */
hole_diameter = coupler_screw_hole_diameter_default();
screw_relief_depth = coupler_screw_relief_depth_default();
screw_relief_radial = coupler_screw_relief_radial_default();
screw_to_side_edge = hub75_panel_hole_x_left();
screw_to_horizontal_edge = hub75_panel_hole_z_bottom();

/* [Panel fit] */
rib_clearance = coupler_fit_clearance_default();
guide_height = project_coupler_guide_height();
guide_end_rounding = project_coupler_guide_end_rounding();
guide_length = project_coupler_guide_length();
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
clip_inboard_positions = [project_coupler_tube_clip_offset()];
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

// Reference the printable corner geometry to the nominal 160 x 320 mm panel
// corner, not to the mounting-screw centre.  The real screw remains at local
// [0,0]; these offsets place the nominal panel edge/corner around it.  Using
// the nominal drawing dimensions keeps the corner profile and its pocket
// raster tied to the rounded 160 x 320 reference envelope.
function corner_nominal_reference_x(side) =
    side == "left"
        ? -hub75_panel_nominal_width()/2 - hub75_panel_hole_x_left_centered()
        :  hub75_panel_nominal_width()/2 - hub75_panel_hole_x_right_centered();

function corner_nominal_reference_z(direction) =
    direction == "top"
        ?  hub75_panel_nominal_height()/2 - hub75_panel_hole_z_top_centered()
        : -hub75_panel_nominal_height()/2 - hub75_panel_hole_z_bottom_centered();

// Public comparison/inspection anchors.  These are the nominal 160 x 320 mm
// corner (+) expressed in the screw-centred local component system.
function corner_edge_panel_coupler_reference_x(side="left") =
    corner_nominal_reference_x(side);
function corner_edge_panel_coupler_reference_z(direction="top") =
    corner_nominal_reference_z(direction);

// Physical rear-rail centre lines relative to the corner mounting screw.
// The mounting screw is not centred in either rear rail.  The base silhouette
// must follow these real rail centres so its 5 mm wall rule matches the
// horizontal-edge coupler when both are placed on the same nominal panel edge.
function corner_side_rail_center_x(side) =
    side == "left"
        ? -screw_to_side_edge
          + hub75_rear_outer_inset_x()
          + hub75_rear_side_rail_width_at_mounting_plane()/2
        :  screw_to_side_edge
          - hub75_rear_outer_inset_x()
          - hub75_rear_side_rail_width_at_mounting_plane()/2;

function corner_end_rail_center_z(direction) =
    direction == "top"
        ?  screw_to_horizontal_edge
           - hub75_rear_outer_inset_z()
           - hub75_rear_end_rail_width_at_mounting_plane()/2
        : -screw_to_horizontal_edge
           + hub75_rear_outer_inset_z()
           + hub75_rear_end_rail_width_at_mounting_plane()/2;

// Keep the physical corner profile in the real screw-centred coordinate
// system.  The nominal 160 x 320 mm corner only determines where the outer
// edge is and how far the inward arms extend.  This is important: translating
// the complete profile to the nominal corner also translated the fitted guide
// geometry away from the real panel ribs.
//
// A nominal 100 mm corner profile means 50 mm inward from the nominal panel
// corner.  Because the screw is ~8 mm inward from that corner, the screw-local
// half-span is correspondingly smaller.  The outside crop is the nominal
// screw-to-corner offset plus the requested outside projection.  The resulting
// overall extent therefore remains 50 + outside_projection (69.5 mm by
// default), independent of the mounting-hole offset.
module corner_nominal_profile_2d(
    side, direction, width, height,
    horizontal_arm_height, vertical_arm_width,
    inside_radius, outside_radius, outward_x, outward_z,
    horizontal_arm_center_z=0, vertical_arm_center_x=0
) {
    reference_x = abs(corner_nominal_reference_x(side));
    reference_z = abs(corner_nominal_reference_z(direction));

    // Desired extents are measured from the mounting-screw origin.  The
    // profile must reach BOTH the requested outside projection and the
    // profile_size/2 inward reach from the nominal panel corner.  The older
    // `effective_width = 2*(size/2-reference)` construction became too small
    // for the 60 mm profile, so its source PLUS ended before the outside crop
    // and the corner guide literally had no plate underneath it.
    inward_x = max(1, width/2 - reference_x);
    inward_z = max(1, height/2 - reference_z);
    screw_local_outward_x = reference_x + outward_x;
    screw_local_outward_z = reference_z + outward_z;

    // Build a sufficiently large symmetric source PLUS, then crop it to the
    // exact asymmetric screw-local bounds.  Arm centre lines stay in the real
    // panel/screw coordinate system; only the outer envelope is asymmetric.
    source_width = 2 * max(inward_x, screw_local_outward_x);
    source_height = 2 * max(inward_z, screw_local_outward_z);

    xmin = side == "left" ? -screw_local_outward_x : -inward_x;
    xmax = side == "left" ?  inward_x              :  screw_local_outward_x;
    zmin = direction == "top" ? -inward_z              : -screw_local_outward_z;
    zmax = direction == "top" ?  screw_local_outward_z :  inward_z;

    intersection() {
        coupler_corner_profile_2d(
            side=side,
            direction=direction,
            width=source_width,
            height=source_height,
            horizontal_arm_height=horizontal_arm_height,
            vertical_arm_width=vertical_arm_width,
            inside_radius=inside_radius,
            outside_radius=outside_radius,
            outward_x=screw_local_outward_x,
            outward_z=screw_local_outward_z,
            horizontal_arm_center_z=horizontal_arm_center_z,
            vertical_arm_center_x=vertical_arm_center_x
        );
        translate([xmin,zmin]) square([xmax-xmin,zmax-zmin], center=false);
    }
}

module corner_panel_keepout_2d(side, direction, total_size) {
    ix = side == "left" ? 1 : -1;
    iz = direction == "top" ? -1 : 1;
    physical_edge_x = -ix * screw_to_side_edge;
    physical_edge_z = -iz * screw_to_horizontal_edge;
    edge_x = physical_edge_x + ix*hub75_rear_outer_inset_x();
    edge_z = physical_edge_z + iz*hub75_rear_outer_inset_z();
    side_w = hub75_rear_side_rail_width_at_mounting_plane();
    end_w = hub75_rear_end_rail_width_at_mounting_plane();
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
    edge_x = -ix * screw_to_side_edge + ix*hub75_rear_outer_inset_x();
    edge_z = -iz * screw_to_horizontal_edge + iz*hub75_rear_outer_inset_z();
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
    horizontal_center_offset_z, vertical_center_offset_x,
    reference_steps = project_coupler_reference_steps(),
    reference_pitch = coupler_reference_pocket_pitch_default(),
    reference_lane_offset = coupler_reference_pocket_lane_offset_default()
) {
    // Build the corner pocket raster from a FULL SYMMETRIC virtual cross first.
    //
    // Local [0,0] is the nominal panel corner.  The real horizontal and
    // vertical arms are offset because they follow the physical HUB75 rear
    // rails.  Those offsets must not be used to invent special one-sided hole
    // coordinates.  Instead:
    //   1. mirror each real INBOARD arm edge across the nominal panel edge;
    //   2. obtain two symmetric virtual arms;
    //   3. derive one shared hole-centre-to-arm-edge inset;
    //   4. generate the complete +/-X and +/-Z raster;
    //   5. let the actual corner silhouette remove every unsupported pocket.
    //
    // This is the same design principle as the horizontal-edge coupler, but at
    // a corner it is applied in both axes.  The missing outside quadrant is a
    // crop of the symmetric construction, never a special-case hole pattern.
    inward_x = side == "left" ? 1 : -1;
    inward_z = direction == "top" ? -1 : 1;

    real_horizontal_inboard_edge_z =
        horizontal_center_offset_z + inward_z*horizontal_height/2;
    real_vertical_inboard_edge_x =
        vertical_center_offset_x + inward_x*vertical_width/2;

    virtual_horizontal_half = abs(real_horizontal_inboard_edge_z);
    virtual_vertical_half = abs(real_vertical_inboard_edge_x);

    // Use the smaller virtual arm as the common symmetric design section.  It
    // determines a single edge inset that is guaranteed to fit both arms.
    // The wider virtual arm then places its lane farther from the nominal edge
    // so both remaining rows have exactly the same centre-to-edge distance.
    common_virtual_half = min(virtual_horizontal_half, virtual_vertical_half);
    common_virtual_thickness = 2*common_virtual_half;
    common_lane_offset = is_undef(reference_lane_offset)
        ? coupler_reference_lane_offset_for_arm(common_virtual_thickness)
        : min(reference_lane_offset, common_virtual_half);
    shared_edge_inset = common_virtual_half - common_lane_offset;

    x_arm_lane = max(0, virtual_horizontal_half - shared_edge_inset);
    z_arm_lane = max(0, virtual_vertical_half - shared_edge_inset);

    // Always generate the complete symmetric cross.  The caller intersects it
    // with the real corner profile, so outward stations and outward lanes that
    // have no material simply disappear.
    for (sx=[-1,1])
        coupler_reference_pocket_strip_2d(
            axis="x", direction_sign=sx, lane_signs=[-1,1],
            steps=reference_steps, pitch=reference_pitch, hole_d=hole_d,
            lane_offset=x_arm_lane
        );

    for (sz=[-1,1])
        coupler_reference_pocket_strip_2d(
            axis="z", direction_sign=sz, lane_signs=[-1,1],
            steps=reference_steps, pitch=reference_pitch, hole_d=hole_d,
            lane_offset=z_arm_lane
        );
}

module corner_fitted_guides_2d(
    side, direction, size,
    horizontal_height, vertical_width,
    inside_radius, outside_radius,
    outward_x, outward_z,
    clearance, end_rounding,
    guide_length_value=1e6
) {
    // Crop to the configured reach first and round the exposed guide ends
    // afterwards. This keeps corner/edge guides consistent with the middle
    // and horizontal-edge components.
    if(end_rounding > 0)
        offset(r=end_rounding)
            offset(delta=-end_rounding)
                intersection() {
                    square([2*guide_length_value, 2*guide_length_value], center=true);
                    difference() {
                    corner_nominal_profile_2d(
                        side=side,direction=direction,
                        width=size,height=size,
                        horizontal_arm_height=horizontal_height,
                        vertical_arm_width=vertical_width,
                        inside_radius=inside_radius,
                        outside_radius=outside_radius,
                        outward_x=outward_x,
                        outward_z=outward_z,
                        horizontal_arm_center_z=corner_end_rail_center_z(direction),
                        vertical_arm_center_x=corner_side_rail_center_x(side)
                    );
                    offset(delta=clearance)
                        corner_panel_keepout_2d(side,direction,size);
                    }
                }
    else
        intersection() {
            square([2*guide_length_value, 2*guide_length_value], center=true);
            difference() {
            corner_nominal_profile_2d(
                side=side,direction=direction,
                width=size,height=size,
                horizontal_arm_height=horizontal_height,
                vertical_arm_width=vertical_width,
                inside_radius=inside_radius,
                outside_radius=outside_radius,
                outward_x=outward_x,
                outward_z=outward_z,
                horizontal_arm_center_z=corner_end_rail_center_z(direction),
                vertical_arm_center_x=corner_side_rail_center_x(side)
            );
            offset(delta=clearance)
                corner_panel_keepout_2d(side,direction,size);
        }
    }
}

module corner_outside_edge_zone_2d(side, direction, size, clearance) {
    ix = side == "left" ? 1 : -1;
    iz = direction == "top" ? -1 : 1;
    edge_x = -ix * screw_to_side_edge + ix*hub75_rear_outer_inset_x();
    edge_z = -iz * screw_to_horizontal_edge + iz*hub75_rear_outer_inset_z();
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
    reference_pocket_steps_value=project_coupler_reference_steps(),
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
    // The corner profile is centred on the nominal panel corner.  Therefore
    // the outside projection is measured directly from that corner instead
    // of adding the screw-to-edge distance a second time.
    outward_x = max_outside_projection_value;
    outward_z = max_outside_projection_value;
    corner_reference_x = corner_nominal_reference_x(side);
    corner_reference_z = corner_nominal_reference_z(direction);
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
                    corner_nominal_profile_2d(
                        side=side,
                        direction=direction,
                        width=size,
                        height=size,
                        horizontal_arm_height=horizontal_height,
                        vertical_arm_width=vertical_width,
                        inside_radius=inside_radius,
                        outside_radius=outside_radius,
                        outward_x=outward_x,
                        outward_z=outward_z,
                        horizontal_arm_center_z=corner_end_rail_center_z(direction),
                        vertical_arm_center_x=corner_side_rail_center_x(side)
                    );
    }

    module raw_corner_body() {
        union() {
            difference() {
                translate([0, thickness, 0])
                    rotate([90,0,0])
                        linear_extrude(height=thickness)
                            corner_nominal_profile_2d(
                                side=side,
                                direction=direction,
                                width=size,
                                height=size,
                                horizontal_arm_height=horizontal_height,
                                vertical_arm_width=vertical_width,
                                inside_radius=inside_radius,
                                outside_radius=outside_radius,
                                outward_x=outward_x,
                                outward_z=outward_z,
                                horizontal_arm_center_z=corner_end_rail_center_z(direction),
                                vertical_arm_center_x=corner_side_rail_center_x(side)
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
                                        corner_nominal_profile_2d(
                                            side=side,direction=direction,
                                            width=size,height=size,
                                            horizontal_arm_height=horizontal_height,
                                            vertical_arm_width=vertical_width,
                                            inside_radius=inside_radius,
                                            outside_radius=outside_radius,
                                            outward_x=outward_x,
                                            outward_z=outward_z,
                                            horizontal_arm_center_z=corner_end_rail_center_z(direction),
                                            vertical_arm_center_x=corner_side_rail_center_x(side)
                                        );
                                    translate([corner_reference_x, corner_reference_z])
                                        corner_reference_perforations_2d(
                                            side,direction,
                                            perforation_hole_diameter_value,
                                            perforation_spacing,
                                            horizontal_height,
                                            vertical_width,
                                            corner_end_rail_center_z(direction) - corner_reference_z,
                                            corner_side_rail_center_x(side) - corner_reference_x,
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
                                        corner_nominal_profile_2d(
                                            side=side,direction=direction,
                                            width=size,height=size,
                                            horizontal_arm_height=horizontal_height,
                                            vertical_arm_width=vertical_width,
                                            inside_radius=inside_radius,
                                            outside_radius=outside_radius,
                                            outward_x=outward_x,
                                            outward_z=outward_z,
                                            horizontal_arm_center_z=corner_end_rail_center_z(direction),
                                            vertical_arm_center_x=corner_side_rail_center_x(side)
                                        );
                                    translate([corner_reference_x, corner_reference_z])
                                        coupler_center_marks_2d(
                                            span_x=size, span_z=size,
                                            pitch=center_mark_pitch_value,
                                            dash_length=center_mark_dash_length_value,
                                            dash_width=center_mark_dash_width_value,
                                            cross_length=center_mark_cross_length_value,
                                            keepout_points=[[-corner_reference_x,-corner_reference_z]],
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
                                    rib_clearance_value,guide_end_rounding_value,
                                    guide_length
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
