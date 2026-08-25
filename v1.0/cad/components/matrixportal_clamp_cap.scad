// HUB75 display case component: matrixportal_clamp_cap
include <../config/project_config.scad>

module matrixportal_clamp_cap() {
    // Separate flat cap for the TS35 clamp; can be laid flat on the print bed.
    kap_b = din_width + 18;
    kap_h = 34;
    kap_d = 5;
    color(color_bracket)
    difference() {
        cube([kap_b,kap_d,kap_h],center=true);
        for(z=[-10,10])
            translate([0,-kap_d/2-1,z]) rotate([-90,0,0])
                cylinder(h=kap_d+2,d=5.5,$fn=28);
    }
}

/* [Standalone preview] */
rotate([-90,0,0]) matrixportal_clamp_cap();
