// HUB75 display case component: din_rail_cable_clip
include <../config/project_config.scad>

module din_rail_cable_clip_x() {
    buiten_x = din_width/2 + din_clip_clearance;
    top_y = din_height + ribbon_cable_thickness + ribbon_cable_clearance + 2.0;

    color(color_bracket)
    union() {
        // Two diagonal arms in the X-Z plane.
        // Together they form a simple X above the ribbon cable.
        translate([0,top_y,0])
        rotate([90,0,0])
        linear_extrude(height=xclip_thickness)
        union() {
            hull() {
                translate([-xclip_width/2,-xclip_height/2]) circle(d=xclip_arm_width,$fn=24);
                translate([ xclip_width/2, xclip_height/2]) circle(d=xclip_arm_width,$fn=24);
            }
            hull() {
                translate([-xclip_width/2, xclip_height/2]) circle(d=xclip_arm_width,$fn=24);
                translate([ xclip_width/2,-xclip_height/2]) circle(d=xclip_arm_width,$fn=24);
            }
        }

        // Four vertical legs: left/right and top/bottom in Z.
        for(sx=[-1,1])
            for(sz=[-1,1]) {
                x0 = sx*(buiten_x + xclip_arm_width/2);
                z0 = sz*(xclip_height/2 - xclip_arm_width/2);

                // Leg along the rail side
                translate([
                    x0 - xclip_arm_width/2,
                    din_height-din_thickness,
                    z0-xclip_arm_width/2
                ])
                    cube([
                        xclip_arm_width,
                        ribbon_cable_thickness+ribbon_cable_clearance+xclip_thickness,
                        xclip_arm_width
                    ]);

                // Hook below the outer lip
                translate([
                    sx > 0 ? buiten_x-xclip_hook_depth : -buiten_x,
                    din_height-din_thickness-xclip_hook_height,
                    z0-xclip_arm_width/2
                ])
                    cube([
                        xclip_hook_depth,
                        xclip_hook_height,
                        xclip_arm_width
                    ]);
            }
    }
}

/* [Standalone preview] */
rotate([90,0,0]) din_rail_cable_clip_x();
