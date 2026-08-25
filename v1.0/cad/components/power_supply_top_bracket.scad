// HUB75 display case component: power_supply_top_bracket
include <../config/project_config.scad>

module power_supply_top_bracket() {
    // Local origin: rear face of the DIN rail.
    // The metal plate starts locally at:
    plate_front_y = (din_front_y + 2) - din_back_y;
    free_clearance = 0.6;
    flange_thickness = power_supply_top_bracket_thickness;
    clip_wall = 4;
    clip_outer_width = din_width + 2*clip_wall;

    color(color_bracket)
    difference() {
        union() {
            // True C/U clamp around the full TS35 top-hat profile.
            difference() {
                translate([
                    -clip_outer_width/2,
                    -0.8,
                    -power_supply_top_bracket_height/2
                ])
                    cube([
                        clip_outer_width,
                        din_height + 1.6,
                        power_supply_top_bracket_height
                    ]);

                translate([
                    -din_width/2-din_clip_clearance,
                    -1.2,
                    -power_supply_top_bracket_height/2-1
                ])
                    cube([
                        din_width+2*din_clip_clearance,
                        din_height+1.4,
                        power_supply_top_bracket_height+2
                    ]);
            }

            // Mounting flange on the rail side of the plate.
            // The flange ends 0.6 mm before the plate and therefore cannot intersect it.
            translate([
                -power_supply_top_bracket_width/2,
                plate_front_y-free_clearance-flange_thickness,
                -power_supply_top_bracket_height/2
            ])
                cube([
                    power_supply_top_bracket_width,
                    flange_thickness,
                    power_supply_top_bracket_height
                ]);

            // Solid connecting bridge between rail clamp and plate flange.
            translate([
                -power_supply_top_bracket_width/2,
                din_height-0.3,
                -10
            ])
                cube([
                    power_supply_top_bracket_width,
                    plate_front_y-free_clearance-din_height+0.3,
                    20
                ]);
        }

        // Two M4 holes to the metal plate.
        for(z=[-7,7])
            translate([
                0,
                plate_front_y-free_clearance-flange_thickness-1,
                z
            ])
                rotate([-90,0,0])
                    cylinder(
                        h=flange_thickness+free_clearance+3,
                        d=4.5,
                        $fn=24
                    );
    }
}

/* [Standalone preview] */
power_supply_top_bracket();
