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

module interlock_right_2d(center_position, clearance=0) {
    neck = frame_interlock_neck_width + 2*clearance;
    head = frame_interlock_head_width + 2*clearance;
    depth = frame_interlock_depth + clearance;

    polygon([
        [frame_module_size, center_position - neck/2],
        [frame_module_size + depth*0.35, center_position - neck/2],
        [frame_module_size + depth, center_position - head/2],
        [frame_module_size + depth, center_position + head/2],
        [frame_module_size + depth*0.35, center_position + neck/2],
        [frame_module_size, center_position + neck/2]
    ]);
}

module interlock_left_2d(center_position, clearance=0) {
    neck = frame_interlock_neck_width + 2*clearance;
    head = frame_interlock_head_width + 2*clearance;
    depth = frame_interlock_depth + clearance;

    polygon([
        [0, center_position - neck/2],
        [depth*0.35, center_position - neck/2],
        [depth, center_position - head/2],
        [depth, center_position + head/2],
        [depth*0.35, center_position + neck/2],
        [0, center_position + neck/2]
    ]);
}

module interlock_top_2d(center_position, clearance=0) {
    neck = frame_interlock_neck_width + 2*clearance;
    head = frame_interlock_head_width + 2*clearance;
    depth = frame_interlock_depth + clearance;

    polygon([
        [center_position - neck/2, frame_module_size],
        [center_position - neck/2, frame_module_size + depth*0.35],
        [center_position - head/2, frame_module_size + depth],
        [center_position + head/2, frame_module_size + depth],
        [center_position + neck/2, frame_module_size + depth*0.35],
        [center_position + neck/2, frame_module_size]
    ]);
}

module interlock_bottom_2d(center_position, clearance=0) {
    neck = frame_interlock_neck_width + 2*clearance;
    head = frame_interlock_head_width + 2*clearance;
    depth = frame_interlock_depth + clearance;

    polygon([
        [center_position - neck/2, 0],
        [center_position - neck/2, depth*0.35],
        [center_position - head/2, depth],
        [center_position + head/2, depth],
        [center_position + neck/2, depth*0.35],
        [center_position + neck/2, 0]
    ]);
}

// Ownership feature for the middle HUB75 screw row. The screw positions sit
// close to the vertical module edges, so the lower module uses edge-connected
// trapezoidal tabs instead of isolated puzzle heads. The upper module receives
// matching trapezoidal pockets. This avoids thin points where four modules meet
// and keeps the complete screw hole in one printed part.
module middle_screw_edge_tab_top_2d(center_position, clearance=0) {
    depth = frame_middle_screw_tab_depth + clearance;
    base_width = frame_middle_screw_tab_base_width + clearance;
    tip_width = frame_middle_screw_tab_tip_width + clearance;
    left_side = center_position < frame_module_size/2;

    if(left_side)
        polygon([
            [0, frame_module_size],
            [base_width, frame_module_size],
            [tip_width, frame_module_size + depth],
            [0, frame_module_size + depth]
        ]);
    else
        polygon([
            [frame_module_size - base_width, frame_module_size],
            [frame_module_size, frame_module_size],
            [frame_module_size, frame_module_size + depth],
            [frame_module_size - tip_width, frame_module_size + depth]
        ]);
}

module middle_screw_edge_pocket_bottom_2d(center_position, clearance=0) {
    depth = frame_middle_screw_tab_depth + clearance;
    base_width = frame_middle_screw_tab_base_width + clearance;
    tip_width = frame_middle_screw_tab_tip_width + clearance;
    left_side = center_position < frame_module_size/2;

    if(left_side)
        polygon([
            [0, 0],
            [base_width, 0],
            [tip_width, depth],
            [0, depth]
        ]);
    else
        polygon([
            [frame_module_size - base_width, 0],
            [frame_module_size, 0],
            [frame_module_size, depth],
            [frame_module_size - tip_width, depth]
        ]);
}

module middle_screw_tabs_2d() {
    for(x=panel_hole_x)
        middle_screw_edge_tab_top_2d(x);
}

module middle_screw_tab_pockets_2d() {
    for(x=panel_hole_x)
        middle_screw_edge_pocket_bottom_2d(
            x,
            frame_middle_screw_tab_clearance
        );
}

module frame_module_outline_2d(
    row="lower",
    left_edge="female",
    right_edge="male",
    bottom_edge="female",
    top_edge="male"
) {
    difference() {
        union() {
            square([frame_module_size, frame_module_size]);

            // Give the middle screw row to the lower module rather than
            // splitting each hole across two module edges. Because the screw
            // positions are close to the left/right module edges, each tab
            // runs all the way to that edge and uses one simple sloping side.
            if(row == "lower")
                middle_screw_tabs_2d();

            if(right_edge == "male")
                for(p=frame_interlock_positions)
                    interlock_right_2d(p);

            if(left_edge == "male")
                for(p=frame_interlock_positions)
                    mirror([1,0,0])
                        interlock_right_2d(p);

            if(top_edge == "male")
                for(p=frame_interlock_positions)
                    interlock_top_2d(p);

            if(bottom_edge == "male")
                for(p=frame_interlock_positions)
                    translate([0,frame_module_size])
                        mirror([0,1,0])
                            interlock_top_2d(p);
        }

        // Matching trapezoidal pockets in the upper module accept the lower
        // module tabs without leaving narrow points at the grid intersection.
        if(row == "upper")
            middle_screw_tab_pockets_2d();

        if(left_edge == "female")
            for(p=frame_interlock_positions)
                interlock_left_2d(p, frame_interlock_clearance);

        if(right_edge == "female")
            for(p=frame_interlock_positions)
                translate([frame_module_size,0])
                    mirror([1,0,0])
                        interlock_left_2d(p, frame_interlock_clearance);

        if(bottom_edge == "female")
            for(p=frame_interlock_positions)
                interlock_bottom_2d(p, frame_interlock_clearance);

        if(top_edge == "female")
            for(p=frame_interlock_positions)
                translate([0,frame_module_size])
                    mirror([0,1,0])
                        interlock_bottom_2d(p, frame_interlock_clearance);
    }
}

function module_mount_z_positions(row) =
    row == "upper"
        ? [panel_hole_z[2] - frame_module_size]
        : [panel_hole_z[0], panel_hole_z[1]];

// Local Z positions for the locating holes used by the vertical seam joiners.
// The middle panel screw row sits at the horizontal 160 mm grid seam. This
// means the lower module receives the lower pin and the upper module receives
// the upper pin from the same joiner.
function seam_joiner_pin_z_positions(row) =
    row == "upper"
        ? [
            panel_hole_z[1] + seam_joiner_pin_z_offset - frame_module_size,
            panel_hole_z[2] - seam_joiner_pin_z_offset - frame_module_size,
            panel_hole_z[2] + seam_joiner_pin_z_offset - frame_module_size
          ]
        : [
            panel_hole_z[0] - seam_joiner_pin_z_offset,
            panel_hole_z[0] + seam_joiner_pin_z_offset,
            panel_hole_z[1] - seam_joiner_pin_z_offset
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

        // Mounting points follow the measured HUB75 PCB holes. The middle
        // screw row is intentionally owned by the lower module; edge-connected
        // trapezoidal tabs cross the seam and the upper module has matching pockets.
        for(x=panel_hole_x)
            for(z=module_mount_z_positions(row))
                translate([x,z])
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
