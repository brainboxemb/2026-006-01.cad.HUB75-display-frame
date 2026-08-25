// HUB75 display case component: power_supply_plate
include <../config/project_config.scad>

module power_supply_plate_model() {
    x0 = power_supply_plate_x_center - power_supply_plate_width/2;
    z0 = power_supply_plate_bottom_z;

    color([0.70,0.72,0.74,1])
    difference() {
        translate([x0,din_front_y+2,z0])
            cube([
                power_supply_plate_width,
                power_supply_plate_thickness,
                power_supply_plate_height
            ]);

        // Two M5 holes to the lower 2020 T-slot.
        for(dx=[-power_supply_frame_hole_spacing/2,power_supply_frame_hole_spacing/2])
            translate([
                power_supply_plate_x_center+dx,
                din_front_y+1,
                z0+21
            ])
                rotate([-90,0,0])
                    cylinder(h=power_supply_plate_thickness+2,d=5.5,$fn=28);

        // Four mounting holes for the power supply.
        for(dx=[-32.5,32.5])
            for(dz=[-27,27])
                translate([
                    power_supply_plate_x_center+dx,
                    din_front_y+1,
                    z0+power_supply_bottom_clearance+power_supply_height/2+dz
                ])
                    rotate([-90,0,0])
                        cylinder(h=power_supply_plate_thickness+2,d=power_supply_mount_hole_diameter,$fn=28);
    }
}

/* [Standalone preview] */
translate([-power_supply_plate_x_center, -(din_front_y+2), -power_supply_plate_bottom_z]) power_supply_plate_model();
