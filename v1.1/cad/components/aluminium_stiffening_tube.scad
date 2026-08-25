// HUB75 display frame - V1.1 aluminium stiffening tube
//
// Continuous hollow aluminium tube used along the top or bottom of the
// 5 x 2 printed frame-module grid.

include <../config/project_config.scad>

module aluminium_stiffening_tube(
    length=stiffening_tube_length,
    outer_diameter=stiffening_tube_outer_diameter,
    wall_thickness=stiffening_tube_wall_thickness
) {
    inner_diameter = outer_diameter - 2*wall_thickness;

    color(color_aluminium_tube)
        rotate([0,90,0])
            difference() {
                cylinder(h=length, d=outer_diameter, $fn=56);
                translate([0,0,-0.1])
                    cylinder(h=length+0.2, d=inner_diameter, $fn=56);
            }
}

/* [Standalone preview] */
preview_length = 160; // [80:20:800]

aluminium_stiffening_tube(length=preview_length);
