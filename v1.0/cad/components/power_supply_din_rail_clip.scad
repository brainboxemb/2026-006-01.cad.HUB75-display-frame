// HUB75 display case component: power_supply_din_rail_clip
include <../config/project_config.scad>

module power_supply_din_rail_clip() {
    clip_d = 6;
    color(color_bracket)
    difference() {
        union() {
            translate([
                -power_supply_din_clip_width/2,
                0,
                -power_supply_din_clip_height/2
            ])
                cube([
                    power_supply_din_clip_width,
                    din_height + clip_d,
                    power_supply_din_clip_height
                ]);

            // Haak bottom beide TS35-lippen.
            translate([
                -din_width/2-0.5,
                din_height-4,
                -power_supply_din_clip_height/2
            ])
                cube([
                    din_width+1,
                    4,
                    power_supply_din_clip_height
                ]);
        }

        // Rail pocket.
        translate([
            -din_width/2-din_clip_clearance,
            -0.5,
            -power_supply_din_clip_height/2-1
        ])
            cube([
                din_width+2*din_clip_clearance,
                din_height+1,
                power_supply_din_clip_height+2
            ]);

        // Two mounting holes through plate and clip.
        for(z=[-5,5])
            translate([0,-1,z])
                rotate([-90,0,0])
                    cylinder(h=din_height+clip_d+2,d=4.5,$fn=24);
    }
}

/* [Standalone preview] */
power_supply_din_rail_clip();
