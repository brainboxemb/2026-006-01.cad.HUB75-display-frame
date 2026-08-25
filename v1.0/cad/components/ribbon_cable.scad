// HUB75 display case component: ribbon_cable
include <../config/project_config.scad>

module ribbon_cable_horizontal(x1,x2,z) {
    length = abs(x2-x1);
    color([0.80,0.80,0.72,1])
        translate([min(x1,x2),ribbon_cable_y,z-ribbon_cable_width/2])
            cube([length,ribbon_cable_thickness,ribbon_cable_width]);
}

module ribbon_cable_connector_end(x,z) {
    color([0.06,0.06,0.06,1])
        translate([x,ribbon_cable_y-1.2,z])
            cube([10,4,20],center=true);
}

/* [Standalone preview] */
ribbon_cable_horizontal(0,120,0);
ribbon_cable_connector_end(0,0);
ribbon_cable_connector_end(120,0);
