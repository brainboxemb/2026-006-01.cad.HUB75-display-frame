// HUB75 display frame - V1.2 aluminium stiffening tube
//
// Self-contained component.
// No project_config.scad dependency.

/* [Tube] */
tube_length = 800.0;
tube_outer_diameter = 10.0;
tube_wall_thickness = 1.0;

/* [Preview] */
preview_color = [0.72, 0.74, 0.76, 1];

/* [Resolution] */
$fn = 64;


function aluminium_tube_default_length() = tube_length;
function aluminium_tube_outer_diameter() = tube_outer_diameter;
function aluminium_tube_wall_thickness() = tube_wall_thickness;
function aluminium_tube_inner_diameter() = tube_outer_diameter - 2*tube_wall_thickness;

module aluminium_stiffening_tube(
    length = tube_length,
    outer_diameter = tube_outer_diameter,
    wall_thickness = tube_wall_thickness,
    part_color = preview_color
) {
    inner_diameter =
        outer_diameter - 2 * wall_thickness;

    color(part_color)
        rotate([0, 90, 0])
            difference() {
                cylinder(
                    h=length,
                    d=outer_diameter
                );

                translate([0, 0, -0.1])
                    cylinder(
                        h=length + 0.2,
                        d=inner_diameter
                    );
            }
}


// Standalone preview
aluminium_stiffening_tube();
