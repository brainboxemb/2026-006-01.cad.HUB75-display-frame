// Shared utility modules: fasteners
include <../../config/project_config.scad>

module washer_model(outer_diameter,inner_diameter,thickness=1) {
    color([0.72,0.72,0.72,1])
    difference() {
        cylinder(h=thickness,d=outer_diameter,$fn=32);
        translate([0,0,-0.5])
            cylinder(h=thickness+1,d=inner_diameter,$fn=28);
    }
}

module bolt_model(d=5,head_diameter=9,head_height=3.5,length=20) {
    color([0.66,0.67,0.68,1])
    union() {
        cylinder(h=length,d=d,$fn=28);
        translate([0,0,length])
            cylinder(h=head_height,d=head_diameter,$fn=6);
    }
}

module t_nut_model() {
    color([0.35,0.35,0.36,1])
    difference() {
        translate([-t_nut_width/2,-t_nut_length/2,0])
            cube([t_nut_width,t_nut_length,t_nut_thickness]);
        translate([0,0,-0.5])
            cylinder(h=t_nut_thickness+1,d=m5_bolt_diameter,$fn=24);
    }
}

module m4_plate_bolt(length=10) {
    bolt_model(
        d=m4_bolt_diameter,
        head_diameter=m4_head_diameter,
        head_height=m4_head_height,
        length=length
    );
    translate([0,0,length-washer_thickness])
        washer_model(washer_diameter_m4,m4_bolt_diameter,washer_thickness);
}

module m5_extrusion_bolt(length=18) {
    bolt_model(
        d=m5_bolt_diameter,
        head_diameter=m5_head_diameter,
        head_height=m5_head_height,
        length=length
    );
    translate([0,0,length-washer_thickness])
        washer_model(washer_diameter_m5,m5_bolt_diameter,washer_thickness);
}

module bolt_y(d=5,head_diameter=9,head_height=3.5,length=16,direction=-1) {
    if(direction < 0)
        rotate([90,0,0])
            bolt_model(d=d,head_diameter=head_diameter,head_height=head_height,length=length);
    else
        rotate([-90,0,0])
            bolt_model(d=d,head_diameter=head_diameter,head_height=head_height,length=length);
}

module washer_y(outer_diameter=11,inner_diameter=5,thickness=1,direction=-1) {
    // Boutas ligt in Y; de ring ligt dus vlak in het X-Z-vlak.
    if(direction < 0)
        rotate([-90,0,0])
            washer_model(outer_diameter,inner_diameter,thickness);
    else
        rotate([90,0,0])
            washer_model(outer_diameter,inner_diameter,thickness);
}

module washer_y_on_face(
    outer_diameter=11,
    inner_diameter=5,
    thickness=1
) {
    // Washer plane is X-Z; thickness extends inward along -Y.
    rotate([90,0,0])
        washer_model(outer_diameter,inner_diameter,thickness);
}

module bolt_with_washer_y(
    d=5,
    head_diameter=9,
    head_height=3.5,
    length=16,
    washer_outer=11,
    washer_thickness_local=1
) {
    color([0.66,0.67,0.68,1]) {
        // Schacht naar binnen.
        rotate([90,0,0])
            cylinder(h=length,d=d,$fn=28);

        // Kop vóór het montagevlak.
        translate([0,head_height,0])
            rotate([90,0,0])
                cylinder(h=head_height,d=head_diameter,$fn=6);
    }

    // Washer exactly against the outer face, in the X-Z plane.
    washer_y_on_face(
        outer_diameter=washer_outer,
        inner_diameter=d,
        thickness=washer_thickness_local
    );
}

module t_nut_y_model() {
    color([0.35,0.35,0.36,1])
    difference() {
        translate([
            -t_nut_length/2,
            -t_nut_thickness/2,
            -t_nut_width/2
        ])
            cube([t_nut_length,t_nut_thickness,t_nut_width]);
        rotate([90,0,0])
            cylinder(
                h=t_nut_thickness+2,
                d=m5_bolt_diameter,
                center=true,
                $fn=24
            );
    }
}

module verzonken_m4_z(length=16,head_diameter=8,head_height=2.4) {
    color([0.66,0.67,0.68,1]) {
        cylinder(h=length,d=4,$fn=28);
        translate([0,0,-head_height])
            cylinder(h=head_height,d1=head_diameter,d2=4,$fn=32);
    }
}

module verzonken_m4_x(right=false,length=42,head_diameter=8,head_height=2.4) {
    color([0.66,0.67,0.68,1])
    if(right) {
        rotate([0,-90,0]) {
            cylinder(h=length,d=4,$fn=28);
            translate([0,0,-head_height])
                cylinder(h=head_height,d1=head_diameter,d2=4,$fn=32);
        }
    } else {
        rotate([0,90,0]) {
            cylinder(h=length,d=4,$fn=28);
            translate([0,0,-head_height])
                cylinder(h=head_height,d1=head_diameter,d2=4,$fn=32);
        }
    }
}
