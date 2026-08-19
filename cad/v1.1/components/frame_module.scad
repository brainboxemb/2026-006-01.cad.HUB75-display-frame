// HUB75 display frame - V1.1 printed frame module
//
// Nominal 160 x 160 mm structural module with a large central opening and
// puzzle-style interlocks. Edge modes are controlled by the assembly so the
// ten modules can form one 5 x 2 grid while keeping the outside perimeter flat.
// Small locating holes near joined vertical edges accept the pins from the
// separate panel-seam joiners.

include <../config/project_config.scad>

module rounded_square_2d(size, radius) {
    offset(r=radius)
        square([size - 2*radius, size - 2*radius], center=true);
}

// Adjacent modules deliberately do not meet on the nominal 160 mm grid line.
// The FEMALE / pocket side owns a continuous 5 mm strip across that line and
// the MALE side is cut back by 5 mm.
//
// Crossing refinement is handled explicitly in the REAR view used to inspect
// the display:
//
//      A | B
//     ---+---
//      C | D
//
// A owns the first middle screw through the normal overlap. D gets one simple
// tab upward into B with a 45-degree free corner so D owns the second middle screw.
// At its lower corner the tab tapers directly back to the normal D/C boundary
// with one 45-degree flank. No separately dimensioned tongue is used.
function edge_min(edge) =
    edge == "female" ? -frame_interlock_overlap :
    edge == "male"   ?  frame_interlock_overlap : 0;

function edge_max(edge) =
    edge == "female" ? frame_module_size + frame_interlock_overlap :
    edge == "male"   ? frame_module_size - frame_interlock_overlap : frame_module_size;

// Dovetail interlock profile.
//
// The profile is defined ONCE in local coordinates and is reused for every
// male key and every female pocket.  The local X axis is the insertion
// direction: x=0 is the narrow root and x=frame_interlock_depth is the wide
// tip.  The 45-degree sides start immediately at the root and stop
// frame_interlock_tip_flat before the end, leaving a short straight tip
// instead of a sharp corner.
module dovetail_profile_2d(clearance=0) {
    depth = frame_interlock_depth;
    neck = frame_interlock_neck_width;
    flat = frame_interlock_tip_flat;
    slope_run = depth - flat;
    head = neck + 2*slope_run;

    module raw_profile() {
        polygon([
            [0,              -neck/2],
            [slope_run,      -head/2],
            [depth,          -head/2],
            [depth,           head/2],
            [slope_run,       head/2],
            [0,               neck/2]
        ]);
    }

    if(clearance > 0)
        offset(delta=clearance)
            raw_profile();
    else
        raw_profile();
}

// Male profiles start at the cut-back module edge and point towards the
// neighbouring module. Female pockets are the SAME profile, transformed into
// the neighbouring module's coordinate system. This is important: a female
// LEFT edge mates a male RIGHT edge and therefore must not simply be a mirrored
// copy of another female edge.
module male_interlock_right_2d(center_position) {
    translate([
        frame_module_size - frame_interlock_overlap,
        center_position
    ])
        dovetail_profile_2d();
}

module female_interlock_left_2d(center_position) {
    translate([
        -frame_interlock_overlap,
        center_position
    ])
        dovetail_profile_2d(frame_interlock_clearance);
}

module male_interlock_left_2d(center_position) {
    translate([
        frame_interlock_overlap,
        center_position
    ])
        mirror([1,0,0])
            dovetail_profile_2d();
}

module female_interlock_right_2d(center_position) {
    translate([
        frame_module_size + frame_interlock_overlap,
        center_position
    ])
        mirror([1,0,0])
            dovetail_profile_2d(frame_interlock_clearance);
}

module male_interlock_top_2d(center_position) {
    translate([
        center_position,
        frame_module_size - frame_interlock_overlap
    ])
        rotate([0,0,90])
            dovetail_profile_2d();
}

module female_interlock_bottom_2d(center_position) {
    translate([
        center_position,
        -frame_interlock_overlap
    ])
        rotate([0,0,90])
            dovetail_profile_2d(frame_interlock_clearance);
}

module male_interlock_bottom_2d(center_position) {
    translate([
        center_position,
        frame_interlock_overlap
    ])
        rotate([0,0,-90])
            dovetail_profile_2d();
}

module female_interlock_top_2d(center_position) {
    translate([
        center_position,
        frame_module_size + frame_interlock_overlap
    ])
        rotate([0,0,-90])
            dovetail_profile_2d(frame_interlock_clearance);
}

// Four-module crossing, named as seen from the REAR of the display:
//
//      A | B
//     ---+---
//      C | D
//
// Rear viewing mirrors model X. Therefore visual D is the lower module whose
// RIGHT edge is the internal vertical seam, and visual B is the upper module
// above it. D gets a simple tab upward into B around the second middle screw.
// The tab remains on the visual B/D side. Its base continues into the D body
// over the full tab width; only the final 5 mm 45-degree tip enters C.
module d_crossing_tab_2d(clearance=0) {
    tab_width = 18.0;
    tab_depth = 2 * frame_interlock_overlap;
    tab_chamfer = 5.0;

    // Simple D -> B ownership tab with one 45-degree free corner.
    // In the normal rear inspection view this is the upper-left corner
    // of the D tab. The corner is clipped instead of ending in a hard 90°.
    module tab_profile() {
        polygon(points=[
            [0, 0],
            [tab_width, 0],
            [tab_width, tab_depth],
            [tab_chamfer, tab_depth],
            [0, tab_depth-tab_chamfer]
        ]);
    }

    if(clearance > 0)
        offset(delta=clearance)
            tab_profile();
    else
        tab_profile();
}


// D -> C transition at the base of the crossing tab.
// Seen from the REAR, D is the lower-right module and C the lower-left.
// This is not given an independent arbitrary depth. The transition simply
// connects the extended D tab back to the normal D/C material boundary with
// one 45-degree flank. Its size therefore follows the existing offset between
// the nominal 160 mm grid line and the cut-back male module edge.
module d_to_c_crossing_transition_2d(clearance=0) {
    transition_run = frame_module_size - edge_max("male");

    module transition_profile() {
        polygon(points=[
            [0, -transition_run],
            [0, 0],
            [transition_run, 0]
        ]);
    }

    if(clearance > 0)
        offset(delta=clearance)
            transition_profile();
    else
        transition_profile();
}

module frame_module_outline_2d(
    row="lower",
    left_edge="female",
    right_edge="male",
    bottom_edge="female",
    top_edge="male"
) {
    xmin = edge_min(left_edge);
    xmax = edge_max(right_edge);
    zmin = edge_min(bottom_edge);
    zmax = edge_max(top_edge);

    difference() {
        union() {
            // Female edges get the extra 5 mm material; male edges stop 5 mm
            // before the nominal grid line.
            translate([xmin,zmin])
                square([xmax-xmin, zmax-zmin]);

            // Male dovetails bridge the 10 mm joint region. Their 45-degree
            // flanks start immediately at the root and finish with a short
            // straight tip instead of a sharp point.
            if(right_edge == "male")
                for(p=frame_interlock_positions)
                    male_interlock_right_2d(p);

            if(left_edge == "male")
                for(p=frame_interlock_positions)
                    male_interlock_left_2d(p);

            if(top_edge == "male")
                for(p=frame_interlock_positions)
                    male_interlock_top_2d(p);

            if(bottom_edge == "male")
                for(p=frame_interlock_positions)
                    male_interlock_bottom_2d(p);

            // Rear-view D -> B crossing tab. Visual D is the lower module
            // on the right side of the rear-view crossing. In model coordinates
            // this is the module with the internal RIGHT edge. The tab grows
            // upward from z=155 to z=165 and contains the second middle screw
            // at local x=151.85, z=159.855.
            if(row == "lower" && right_edge == "male" && top_edge == "male") {
                translate([
                    frame_module_size-18.0,
                    frame_module_size-frame_interlock_overlap
                ])
                    d_crossing_tab_2d();

                // Taper the D tab directly back to the normal D/C boundary
                // with one 45-degree flank. No horizontal tongue is added.
                translate([
                    edge_max("male"),
                    frame_module_size-frame_interlock_overlap
                ])
                    d_to_c_crossing_transition_2d();
            }

        }

        // Rear-view B matching pocket for the D crossing tab. Visual B is the
        // upper module with the internal RIGHT edge in model coordinates.
        if(row == "upper" && right_edge == "male" && bottom_edge == "female")
            translate([frame_module_size-18.0, -frame_interlock_overlap])
                d_crossing_tab_2d(frame_interlock_clearance/2);

        // Rear-view C matching pocket for the D -> C transition. Visual C is
        // the lower module with the internal LEFT edge in model coordinates.
        if(row == "lower" && left_edge == "female" && top_edge == "male")
            translate([
                -frame_interlock_overlap,
                frame_module_size-frame_interlock_overlap
            ])
                d_to_c_crossing_transition_2d(frame_interlock_clearance/2);

        // The upper-right module in model coordinates is visual A in the rear
        // view. Because A owns the 5 mm female overlap strip, the D tab already
        // reaches underneath A up to the nominal A/B grid line. Remove the
        // matching part from A as well, so D visibly/structurally continues all
        // the way to that nominal centre line instead of disappearing under A.
        if(row == "upper" && left_edge == "female" && bottom_edge == "female")
            translate([-18.0, -frame_interlock_overlap])
                d_crossing_tab_2d(frame_interlock_clearance/2);

        // Female pockets match the complete dovetail profile. Print clearance
        // is added to the pocket only.
        if(left_edge == "female")
            for(p=frame_interlock_positions)
                female_interlock_left_2d(p);

        if(right_edge == "female")
            for(p=frame_interlock_positions)
                female_interlock_right_2d(p);

        if(bottom_edge == "female")
            for(p=frame_interlock_positions)
                female_interlock_bottom_2d(p);

        if(top_edge == "female")
            for(p=frame_interlock_positions)
                female_interlock_top_2d(p);

    }
}

function module_mount_points(row) =
    // Middle-row screw ownership follows the model grid directly:
    //
    //      A | B
    //     ---+---
    //      C | D
    //
    // The RIGHT middle screw of the upper/left panel half belongs to A; the
    // LEFT middle screw of the lower/right panel half belongs to D. Across the
    // complete display this means upper modules own their local RIGHT middle
    // screw and lower modules own their local LEFT middle screw.
    row == "upper"
        ? [
            [panel_hole_x[1], panel_hole_z[1] - frame_module_size],
            [panel_hole_x[0], panel_hole_z[2] - frame_module_size],
            [panel_hole_x[1], panel_hole_z[2] - frame_module_size]
          ]
        : [
            [panel_hole_x[0], panel_hole_z[0]],
            [panel_hole_x[1], panel_hole_z[0]],
            [panel_hole_x[0], panel_hole_z[1]]
          ];

function seam_joiner_pin_z_positions(row) =
    row == "upper"
        ? [
            panel_hole_z[1] + seam_joiner_middle_pin_z_offset - frame_module_size,
            panel_hole_z[2] - seam_joiner_pin_z_offset - frame_module_size,
            panel_hole_z[2] + seam_joiner_pin_z_offset - frame_module_size
          ]
        : [
            panel_hole_z[0] - seam_joiner_pin_z_offset,
            panel_hole_z[0] + seam_joiner_pin_z_offset,
            panel_hole_z[1] - seam_joiner_middle_pin_z_offset
          ];

module frame_module_2d(
    row="lower",
    left_edge="female",
    right_edge="male",
    bottom_edge="female",
    top_edge="male"
) {
    difference() {
        frame_module_outline_2d(
            row=row,
            left_edge=left_edge,
            right_edge=right_edge,
            bottom_edge=bottom_edge,
            top_edge=top_edge
        );

        // Large material-saving opening. It also leaves the HUB75 rear
        // connectors accessible.
        translate([frame_module_size/2, frame_module_size/2])
            rounded_square_2d(
                frame_module_opening_size,
                frame_module_opening_radius
            );

        // Mounting points follow the measured HUB75 PCB holes. The middle row
        // is split diagonally between the two module rows, so each screw hole
        // is completely contained by one printed module.
        for(point=module_mount_points(row))
            translate(point)
                circle(d=frame_module_mount_hole_diameter, $fn=28);

        // Locating holes are added only on internal vertical grid edges. The
        // seam joiner pins are deliberately shorter than the module thickness,
        // so they locate the parts without touching the HUB75 PCB.
        if(left_edge != "none")
            for(z=seam_joiner_pin_z_positions(row))
                translate([seam_joiner_pin_x_offset,z])
                    circle(d=seam_joiner_pin_hole_diameter, $fn=24);

        if(right_edge != "none")
            for(z=seam_joiner_pin_z_positions(row))
                translate([frame_module_size-seam_joiner_pin_x_offset,z])
                    circle(d=seam_joiner_pin_hole_diameter, $fn=24);
    }
}


// C-shaped snap clip around a horizontal aluminium tube. The tube axis is X.
// In the Y-Z side view the frame plate continues straight beyond the panel
// edge, while the circular clip sits beside that extension. This is the simple
// tangent arrangement used in the design sketch: no L-shaped support and no
// clamp centred in the plate thickness.
module tube_snap_clip(center_x, edge="top") {
    inner_d = tube_clip_inner_diameter;
    outer_d = tube_clip_outer_diameter();
    outer_r = tube_clip_outer_radius();

    // frame_module() is placed at frame_module_y in the assembly. Convert the
    // global tube position back to the component-local Y axis.
    local_tube_y = stiffening_tube_y() - frame_module_y;
    local_tube_z = edge == "top"
        ? frame_module_size + outer_r
        : -outer_r;

    difference() {
        translate([center_x, local_tube_y, local_tube_z])
            rotate([0,90,0])
                cylinder(
                    h=tube_clip_length,
                    d=outer_d,
                    center=true,
                    $fn=48
                );

        translate([center_x, local_tube_y, local_tube_z])
            rotate([0,90,0])
                cylinder(
                    h=tube_clip_length+0.4,
                    d=inner_d,
                    center=true,
                    $fn=48
                );

        // Straight throat smaller than the 10 mm tube diameter provides the
        // snap action. The opening is rotated 90 degrees compared with the
        // earlier version: it faces away from the straight plate extension.
        // In Y-Z side view the plate is on the +Y side of the ring, so the
        // opening is cut towards -Y. Top and bottom clips use the same section.
        translate([
            center_x-tube_clip_length/2-0.3,
            local_tube_y-outer_r-0.6,
            local_tube_z-tube_clip_opening/2
        ])
            cube([
                tube_clip_length+0.6,
                outer_r+0.6,
                tube_clip_opening
            ]);
    }
}

// Straight continuation of the 160 x 160 mm module edge. In side view this is
// the vertical rectangular part of the sketch. The tube clip is offset towards
// the front and intersects only the front side of this extension.
module tube_clip_extension(center_x, edge="top") {
    outer_r = tube_clip_outer_radius();
    local_tube_z = edge == "top"
        ? frame_module_size + outer_r
        : -outer_r;

    if(edge == "top")
        translate([
            center_x-tube_clip_length/2,
            0,
            frame_module_size-frame_module_thickness
        ])
            cube([
                tube_clip_length,
                frame_module_thickness,
                (local_tube_z + tube_clip_vertical_overlap) -
                    (frame_module_size-frame_module_thickness)
            ]);
    else
        translate([
            center_x-tube_clip_length/2,
            0,
            local_tube_z-tube_clip_vertical_overlap
        ])
            cube([
                tube_clip_length,
                frame_module_thickness,
                frame_module_thickness -
                    (local_tube_z-tube_clip_vertical_overlap)
            ]);
}

module integrated_tube_clips(edge="none", module_color=color_frame_module_r1) {
    if(edge == "top" || edge == "bottom")
        color(module_color)
            for(x=tube_clip_positions)
                union() {
                    tube_snap_clip(center_x=x, edge=edge);
                    tube_clip_extension(center_x=x, edge=edge);
                }
}

module frame_module(
    row="lower",
    left_edge="female",
    right_edge="male",
    bottom_edge="female",
    top_edge="male",
    tube_clip_edge="none",
    module_color=color_frame_module_r1
) {
    union() {
        color(module_color)
            translate([0,frame_module_thickness,0])
                rotate([90,0,0])
                    linear_extrude(height=frame_module_thickness)
                        frame_module_2d(
                            row=row,
                            left_edge=left_edge,
                            right_edge=right_edge,
                            bottom_edge=bottom_edge,
                            top_edge=top_edge
                        );

        integrated_tube_clips(
            edge=tube_clip_edge,
            module_color=module_color
        );
    }
}

/* [Standalone preview] */
preview_row = "lower"; // [lower, upper]
preview_left_edge = "female"; // [none, male, female]
preview_right_edge = "male"; // [none, male, female]
preview_bottom_edge = "female"; // [none, male, female]
preview_top_edge = "male"; // [none, male, female]
preview_tube_clip_edge = "bottom"; // [none, top, bottom]

frame_module(
    row=preview_row,
    left_edge=preview_left_edge,
    right_edge=preview_right_edge,
    bottom_edge=preview_bottom_edge,
    top_edge=preview_top_edge,
    tube_clip_edge=preview_tube_clip_edge
);
