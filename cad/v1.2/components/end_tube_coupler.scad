// HUB75 display frame - V1.2 asymmetric end tube coupler
//
// Self-contained component.
// No project_config.scad dependency.
//
// Left and right versions are mirrored so the part stays inside the panel
// outline. The clip is shifted inward toward the display.

/* dependencies */
use <tube_clip.scad>

/* [Plate] */
plate_width = 34.0;
plate_height = 24.0;
plate_thickness = 4.0;
corner_radius = 3.0;

/* [Mounting] */
hole_diameter = 3.4;
outside_material = 6.0;

/* [Clip] */
clip_inward_offset = 6.0;
clip_length = 20.0;
clip_wall = 2.6;
clip_inner_diameter = 10.4;
clip_opening = 8.2;
clip_vertical_overlap = 2.0;

/* [Standalone preview] */
preview_side = "left"; // [left, right]
preview_direction = "top"; // [top, bottom]
preview_tube_y = -5.0;
preview_tube_z = 18.0;
preview_color = [0.82, 0.12, 0.05, 1];

/* [Resolution] */
$fn = 48;


module rounded_rectangle_2d(width, height, radius) {
    offset(r=radius)
        square(
            [width - 2*radius, height - 2*radius],
            center=true
        );
}


module end_tube_coupler(
    side = "left",
    direction = "top",
    width = plate_width,
    height = plate_height,
    thickness = plate_thickness,
    radius = corner_radius,
    hole_diameter_value = hole_diameter,
    outside_material_value = outside_material,
    clip_inward_offset_value = clip_inward_offset,
    local_tube_y = preview_tube_y,
    local_tube_z = preview_tube_z,
    clip_length_value = clip_length,
    clip_wall_value = clip_wall,
    clip_inner_diameter_value = clip_inner_diameter,
    clip_opening_value = clip_opening,
    clip_vertical_overlap_value = clip_vertical_overlap,
    part_color = preview_color
) {
    inward_sign =
        side == "left" ? 1 : -1;

    // Place the hole close to the outer edge, leaving the configured
    // material margin outside it.
    hole_x =
        side == "left"
            ? -width/2 + outside_material_value
            :  width/2 - outside_material_value;

    clip_x =
        hole_x
        + inward_sign * clip_inward_offset_value;

    color(part_color)
        translate([0, thickness, 0])
            rotate([90, 0, 0])
                linear_extrude(height=thickness)
                    difference() {
                        rounded_rectangle_2d(
                            width,
                            height,
                            radius
                        );

                        translate([hole_x, 0])
                            circle(
                                d=hole_diameter_value,
                                $fn=30
                            );
                    }

    tube_clip_with_extension(
        center_x=clip_x,
        edge=direction,
        local_tube_y=local_tube_y,
        local_tube_z=local_tube_z,
        length=clip_length_value,
        wall=clip_wall_value,
        inner_diameter=
            clip_inner_diameter_value,
        opening=clip_opening_value,
        thickness=thickness,
        plate_height=height,
        vertical_overlap=
            clip_vertical_overlap_value,
        part_color=part_color
    );
}


// Standalone preview
end_tube_coupler(
    side=preview_side,
    direction=preview_direction
);
