// HUB75 display case component: power_supply_bottom_bracket
include <../config/project_config.scad>

module power_supply_bottom_bracket() {
    // Straight two-point bracket:
    // top against the metal plate, bottom with a solid clamping face
    // against the rear of the 2020 extrusion.
    plate_flange_h = 28;
    extrusion_clamp_width = 24;
    extrusion_clamp_height = 20;
    extrusion_center_local_z = extrusion_size/2 - power_supply_plate_bottom_z;
    extrusion_y = frame_back_y - (din_front_y + 2 + power_supply_plate_thickness);
    arm_width = 6;

    color(color_bracket)
    difference() {
        union() {
            // Upper flange against the metal plate.
            translate([
                -power_supply_bottom_bracket_width/2,
                0,
                0
            ])
                cube([
                    power_supply_bottom_bracket_width,
                    power_supply_bottom_bracket_thickness,
                    plate_flange_h
                ]);

            // Solid clamping face against the rear of the extrusion.
            // At least approximately 7 mm of material remains around the M5 hole.
            translate([
                -extrusion_clamp_width/2,
                extrusion_y,
                extrusion_center_local_z-extrusion_clamp_height/2
            ])
                cube([
                    extrusion_clamp_width,
                    power_supply_bottom_bracket_thickness,
                    extrusion_clamp_height
                ]);

            // Two straight connecting arms between the plate flange and clamping face.
            for(sx=[-1,1])
                hull() {
                    translate([
                        sx < 0
                            ? -power_supply_bottom_bracket_width/2
                            : power_supply_bottom_bracket_width/2-arm_width,
                        -0.1,
                        3
                    ])
                        cube([
                            arm_width,
                            power_supply_bottom_bracket_thickness,
                            10
                        ]);

                    translate([
                        sx < 0
                            ? -extrusion_clamp_width/2
                            : extrusion_clamp_width/2-arm_width,
                        extrusion_y,
                        extrusion_center_local_z+2
                    ])
                        cube([
                            arm_width,
                            power_supply_bottom_bracket_thickness,
                            10
                        ]);
                }
        }

        // Upper M5 bolt, high in the plate flange.
        translate([0,-1,21])
            rotate([-90,0,0])
                cylinder(
                    h=power_supply_bottom_bracket_thickness+3,
                    d=5.5,
                    $fn=28
                );

        // Lower M5 bolt through the solid clamping face
        // to the T-nut in the rear extrusion slot.
        translate([
            0,
            extrusion_y-1,
            extrusion_center_local_z
        ])
            rotate([-90,0,0])
                cylinder(
                    h=power_supply_bottom_bracket_thickness+3,
                    d=5.5,
                    $fn=28
                );
    }
}

/* [Standalone preview] */
power_supply_bottom_bracket();
