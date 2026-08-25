// HUB75 display case component: dc_dc_power_supply
include <../config/project_config.scad>

module dc_dc_power_supply_model() {
    color([0.48,0.50,0.52,1])
    union() {
        cube([power_supply_width,power_supply_depth,power_supply_height],center=true);

        // Cooling fins on the outside.
        for(x=[-30:10:30])
            translate([x,power_supply_depth/2+2,0])
                cube([4,4,power_supply_height-8],center=true);

        // Two indicative mounting lugs.
        for(x=[-power_supply_width/2,power_supply_width/2])
            translate([x,0,0])
            difference() {
                cube([10,power_supply_depth-4,power_supply_height],center=true);
                for(z=[-power_supply_height/2+10,power_supply_height/2-10])
                    translate([0,0,z])
                        rotate([90,0,0])
                            cylinder(h=power_supply_depth+2,d=power_supply_mount_hole_diameter,$fn=28,center=true);
            }
    }
}

/* [Standalone preview] */
dc_dc_power_supply_model();
