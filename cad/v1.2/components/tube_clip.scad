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


// Standalone preview
tube_clip_with_extension(
    center_x=preview_center_x,
    edge=preview_edge,
    local_tube_y=preview_tube_y,
    local_tube_z=preview_tube_z
);
