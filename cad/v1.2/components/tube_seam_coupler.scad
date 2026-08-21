// HUB75 display frame - V1.2 compact two-clip seam coupler
//
// Self-contained component.
// No project_config.scad dependency.

use <tube_clip.scad>

/* [Plate] */
plate_width = 56.0;
plate_height = 24.0;
plate_thickness = 4.0;
corner_radius = 3.0;

/* [Mounting holes] */
left_hole_x = -8.15;
right_hole_x = 7.85;
hole_diameter = 3.4;

/* [Clip positions] */
left_clip_x = -14.0;
right_clip_x = 14.0;

/* [Tube clip] */
clip_length = 20.0;
clip_wall = 2.6;
clip_inner_diameter = 10.4;
clip_opening = 8.2;
clip_vertical_overlap = 2.0;

/* [Standalone preview] */
preview_direction = "top"; // [top, bottom]
preview_tube_y = -5.0;
preview_tube_z = 18.0;
preview_color = [0.86, 0.08, 0.05, 1];

/* [Resolution] */
$fn = 48;


module rounded_rectangle_2d(width, height, radius) {
    offset(r=radius)
        square(
            [width - 2*radius, height - 2*radius],
            center=true
        );
}


module tube_seam_coupler(
    direction = "top",
    width = plate_width,
    height = plate_height,
    thickness = plate_thickness,
    radius = corner_radius,
    left_hole_x_value = left_hole_x,
    right_hole_x_value = right_hole_x,
    hole_diameter_value = hole_diameter,
    left_clip_x_value = left_clip_x,
    right_clip_x_value = right_clip_x,
    local_tube_y = preview_tube_y,
    local_tube_z = preview_tube_z,
    clip_length_value = clip_length,
    clip_wall_value = clip_wall,
    clip_inner_diameter_value = clip_inner_diameter,
    clip_opening_value = clip_opening,
    clip_vertical_overlap_value = clip_vertical_overlap,
    part_color = preview_color
) {
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

                        translate([
                            left_hole_x_value,
                            0
                        ])
                            circle(
                                d=hole_diameter_value,
                                $fn=30
                            );

                        translate([
                            right_hole_x_value,
                            0
                        ])
                            circle(
                                d=hole_diameter_value,
                                $fn=30
                            );
                    }

    for(clip_x=[
        left_clip_x_value,
        right_clip_x_value
    ])
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
tube_seam_coupler(
    direction=preview_direction
);
