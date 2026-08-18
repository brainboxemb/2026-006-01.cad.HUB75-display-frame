// HUB75 display case component: aluminium_extrusion
include <../config/project_config.scad>

module extrusion_cross_section_2d() {
    difference() {
        square([extrusion_size, extrusion_size], center=true);
        circle(d=4.2);
        for(a=[0:90:270]) rotate(a) translate([0,extrusion_size/2]) square([6,2.5],center=true);
    }
}

module aluminium_extrusion_3d(length, horizontaal=true) {
    color(color_extrusion)
    if(horizontaal)
        translate([0,extrusion_size/2,extrusion_size/2]) rotate([0,90,0]) linear_extrude(length) extrusion_cross_section_2d();
    else
        translate([extrusion_size/2,extrusion_size/2,0]) linear_extrude(length) extrusion_cross_section_2d();
}

/* [Standalone preview] */
preview_length = 120; // [40:10:840]
aluminium_extrusion_3d(preview_length, true);
