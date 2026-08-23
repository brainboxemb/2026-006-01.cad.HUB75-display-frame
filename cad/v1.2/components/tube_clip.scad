// HUB75 display frame - V1.2 V1.1-style tube clip
//
// Self-contained component.
// No project_config.scad dependency.
//
// Coordinate system:
// X = tube direction
// Y = front/rear
// Z = vertical
//
// The C-opening points away from the plate in -Y.

 /* [Clip] */
clip_length = 20.0;
clip_wall = 2.6;
clip_inner_diameter = 10.4;
clip_opening = 8.2;

 /* [Attachment] */
clip_plate_overlap = 1.4;
clip_vertical_overlap = 2.0;
attachment_thickness = 4.0;
attachment_plate_height = 24.0;

 /* [Standalone preview] */
preview_edge = "top"; // [top, bottom]
preview_center_x = 0.0;
preview_tube_z = 18.0;
preview_tube_y = -5.0;
preview_color = [0.86, 0.08, 0.05, 1];

 /* [Resolution] */
$fn = 48;


function clip_outer_diameter(
    inner_diameter,
    wall
) =
    inner_diameter + 2 * wall;


function clip_outer_radius(
    inner_diameter,
    wall
) =
    clip_outer_diameter(
        inner_diameter,
        wall
    ) / 2;


module tube_snap_clip(
    center_x = 0,
    local_tube_y = -5,
    local_tube_z = 18,
    length = clip_length,
    wall = clip_wall,
    inner_diameter = clip_inner_diameter,
    opening = clip_opening,
    part_color = preview_color
) {
    outer_d =
        clip_outer_diameter(
            inner_diameter,
            wall
        );

    outer_r =
        outer_d / 2;

    color(part_color)
        difference() {
            translate([
                center_x,
                local_tube_y,
                local_tube_z
            ])
                rotate([0, 90, 0])
                    cylinder(
                        h=length,
                        d=outer_d,
                        center=true,
                        $fn=48
                    );

            translate([
                center_x,
                local_tube_y,
                local_tube_z
            ])
                rotate([0, 90, 0])
                    cylinder(
                        h=length + 0.4,
                        d=inner_diameter,
                        center=true,
                        $fn=48
                    );

            // V1.1 orientation: opening away from the plate (-Y).
            translate([
                center_x - length/2 - 0.3,
                local_tube_y - outer_r - 0.6,
                local_tube_z - opening/2
            ])
                cube([
                    length + 0.6,
                    outer_r + 0.6,
                    opening
                ]);
        }
}


// Local support web between a panel edge and a snap ring.
//
// IMPORTANT: the profile is defined explicitly in the Y/Z plane and then
// extruded along X with a polyhedron.  Earlier revisions used a rotated
// linear_extrude; that accidentally swapped the Y/Z profile axes and could
// create a bar through the C-clip plus a stray block beside it.
module _tube_clip_yz_prism(
    center_x = 0,
    length = 16,
    yz_points = []
) {
    n = len(yz_points);
    x0 = center_x - length/2;
    x1 = center_x + length/2;

    points = concat(
        [for (p=yz_points) [x0, p[0], p[1]]],
        [for (p=yz_points) [x1, p[0], p[1]]]
    );

    // yz_points are supplied counter-clockwise as viewed from +X.
    faces = concat(
        [[for (i=[0:n-1]) n-1-i]],
        [[for (i=[0:n-1]) n+i]],
        [for (i=[0:n-1]) [
            i,
            (i+1)%n,
            n+(i+1)%n,
            n+i
        ]]
    );

    polyhedron(points=points, faces=faces, convexity=6);
}


module tube_clip_support_web(
    center_x = 0,
    edge = "top",
    panel_edge_z = 0,
    local_tube_y = -5,
    local_tube_z = 18,
    length = clip_length,
    wall = clip_wall,
    inner_diameter = clip_inner_diameter,
    root_depth = 5.0,
    root_height = 6.0,
    neck_height = 2.8,
    part_color = preview_color
) {
    outer_r = clip_outer_radius(inner_diameter, wall);
    sign_z = edge == "top" ? 1 : -1;

    // Attach to the plate-side quadrant of the ring, but stay inside the
    // outer circle so the support never projects through the C-opening.
    ring_attach_y = local_tube_y + outer_r - wall*0.55;
    ring_attach_z = local_tube_z - sign_z*(outer_r - wall*0.75);

    // Local plate foot.  Y runs from the plate rear face toward the tube.
    plate_inner_y = 1.2;
    plate_outer_y = plate_inner_y - root_depth;
    plate_z0 = panel_edge_z;
    plate_z1 = panel_edge_z + sign_z*root_height;

    neck_z0 = ring_attach_z - sign_z*neck_height/2;
    neck_z1 = ring_attach_z + sign_z*neck_height/2;

    // Profile in actual [Y,Z] coordinates.  For bottom clips we mirror the
    // same top profile about panel_edge_z rather than changing axis meaning.
    pts_top = [
        [plate_outer_y, plate_z0],
        [plate_inner_y, plate_z0],
        [ring_attach_y, neck_z0],
        [ring_attach_y, neck_z1],
        [plate_inner_y, plate_z1],
        [plate_outer_y, plate_z1]
    ];
    pts_bottom = [for (p=pts_top) [p[0], 2*panel_edge_z-p[1]]];

    color(part_color)
        difference() {
            _tube_clip_yz_prism(
                center_x=center_x,
                length=length,
                yz_points=edge == "top" ? pts_top : pts_bottom
            );

            // The support may touch the outside of the C-ring, but it must
            // never occupy the space reserved for the aluminium tube itself.
            // Use the same fitted inner diameter as the snap ring, giving the
            // Ø10 tube the intended radial assembly clearance.
            translate([center_x,local_tube_y,local_tube_z])
                rotate([0,90,0])
                    cylinder(
                        h=length + 0.6,
                        d=inner_diameter,
                        center=true,
                        $fn=64
                    );
        }
}


module tube_clip_extension(
    center_x = 0,
    edge = "top",
    local_tube_z = 18,
    length = clip_length,
    thickness = attachment_thickness,
    plate_height = attachment_plate_height,
    vertical_overlap = clip_vertical_overlap,
    part_color = preview_color
) {
    color(part_color)
        if(edge == "top")
            translate([
                center_x - length/2,
                0,
                plate_height/2 - thickness
            ])
                cube([
                    length,
                    thickness,
                    (local_tube_z + vertical_overlap)
                        - (plate_height/2 - thickness)
                ]);
        else
            translate([
                center_x - length/2,
                0,
                local_tube_z - vertical_overlap
            ])
                cube([
                    length,
                    thickness,
                    (-plate_height/2 + thickness)
                        - (local_tube_z - vertical_overlap)
                ]);
}


module tube_clip_with_extension(
    center_x = 0,
    edge = "top",
    local_tube_y = -5,
    local_tube_z = 18,
    length = clip_length,
    wall = clip_wall,
    inner_diameter = clip_inner_diameter,
    opening = clip_opening,
    thickness = attachment_thickness,
    plate_height = attachment_plate_height,
    vertical_overlap = clip_vertical_overlap,
    part_color = preview_color
) {
    union() {
        tube_snap_clip(
            center_x=center_x,
            local_tube_y=local_tube_y,
            local_tube_z=local_tube_z,
            length=length,
            wall=wall,
            inner_diameter=inner_diameter,
            opening=opening,
            part_color=part_color
        );

        tube_clip_extension(
            center_x=center_x,
            edge=edge,
            local_tube_z=local_tube_z,
            length=length,
            thickness=thickness,
            plate_height=plate_height,
            vertical_overlap=vertical_overlap,
            part_color=part_color
        );
    }
}




// Generic keep-outs for geometry that lives near a tube clip.
// These are useful for panel-edge ridges: the ridge must not occupy either
// the actual tube envelope or the flexible C-ring envelope.
module tube_axis_keepout(
    center_x = 0,
    local_tube_y = -5,
    local_tube_z = 18,
    length = 100,
    diameter = clip_inner_diameter,
    radial_clearance = 0.0
) {
    translate([center_x, local_tube_y, local_tube_z])
        rotate([0,90,0])
            cylinder(
                h=length,
                d=diameter + 2*radial_clearance,
                center=true,
                $fn=64
            );
}

module tube_clip_outer_keepout(
    center_x = 0,
    local_tube_y = -5,
    local_tube_z = 18,
    length = clip_length,
    wall = clip_wall,
    inner_diameter = clip_inner_diameter,
    axial_clearance = 0.0,
    radial_clearance = 0.0
) {
    tube_axis_keepout(
        center_x=center_x,
        local_tube_y=local_tube_y,
        local_tube_z=local_tube_z,
        length=length + 2*axial_clearance,
        diameter=clip_outer_diameter(inner_diameter, wall),
        radial_clearance=radial_clearance
    );
}

// Standalone preview
tube_clip_with_extension(
    center_x=preview_center_x,
    edge=preview_edge,
    local_tube_y=preview_tube_y,
    local_tube_z=preview_tube_z
);
