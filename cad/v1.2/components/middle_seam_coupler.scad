// HUB75 display frame - V1.2 middle seam coupler
//
// Self-contained component.
// No project_config.scad dependency.

/* [Plate] */
plate_width = 48.0;
plate_height = 24.0;
plate_thickness = 4.0;
corner_radius = 3.0;

/* [Mounting holes] */
left_hole_x = -8.15;
right_hole_x = 7.85;
hole_diameter = 3.4;

/* [Preview] */
preview_color = [0.62, 0.04, 0.03, 1];

/* [Resolution] */
$fn = 48;


module rounded_rectangle_2d(width, height, radius) {
    offset(r=radius)
        square(
            [width - 2*radius, height - 2*radius],
            center=true
        );
}


module middle_seam_coupler(
    width = plate_width,
    height = plate_height,
    thickness = plate_thickness,
    radius = corner_radius,
    left_hole_x_value = left_hole_x,
    right_hole_x_value = right_hole_x,
    hole_diameter_value = hole_diameter,
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

                        translate([left_hole_x_value, 0])
                            circle(
                                d=hole_diameter_value,
                                $fn=30
                            );

                        translate([right_hole_x_value, 0])
                            circle(
                                d=hole_diameter_value,
                                $fn=30
                            );
                    }
}


// Standalone preview
middle_seam_coupler();
