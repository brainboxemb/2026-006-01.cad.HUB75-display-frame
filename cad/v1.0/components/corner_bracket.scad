// HUB75 display case component: corner_bracket
include <../config/project_config.scad>

module corner_bracket_3d(is_top=false, right=false) {
    dz = is_top ? extrusion_offset : -extrusion_offset;
    dx_inwaarts = right ? -20 : 20;
    y_panel = 0;
    y_extrusion = panel_extrusion_y_offset;
    oor = 8;

    color(color_bracket)
    difference() {
        union() {
            // Rounded M3 lug in the same top plane as the M5 lugs.
            translate([0,y_extrusion+bracket_thickness,0])
                rotate([90,0,0])
                    cylinder(
                        h=bracket_thickness,
                        r=oor,
                        $fn=48
                    );

            // Spacer to the panel surface located 6 mm lower.
            translate([0,y_panel,0])
                rotate([-90,0,0])
                    difference() {
                        cylinder(h=y_extrusion,d=10,$fn=36);
                        translate([0,0,-0.1])
                            cylinder(
                                h=y_extrusion+0.2,
                                d=m3_hole_diameter,
                                $fn=28
                            );
                    }

            // Two rounded M5 lugs on the extrusion face.
            for(dx=[0,dx_inwaarts])
                translate([
                    dx,
                    y_extrusion+bracket_thickness,
                    dz
                ])
                    rotate([90,0,0])
                        cylinder(
                            h=bracket_thickness,
                            r=oor,
                            $fn=48
                        );

            // Smooth bridges in one flat top plane.
            for(dx=[0,dx_inwaarts])
                hull() {
                    translate([
                        0,
                        y_extrusion+bracket_thickness,
                        0
                    ])
                        rotate([90,0,0])
                            cylinder(
                                h=bracket_thickness,
                                r=5,
                                $fn=40
                            );

                    translate([
                        dx,
                        y_extrusion+bracket_thickness,
                        dz
                    ])
                        rotate([90,0,0])
                            cylinder(
                                h=bracket_thickness,
                                r=6,
                                $fn=40
                            );
                }
        }

        translate([0,y_panel-0.2,0])
            rotate([-90,0,0])
                cylinder(
                    h=y_extrusion+bracket_thickness+0.4,
                    d=m3_hole_diameter,
                    $fn=28
                );

        for(dx=[0,dx_inwaarts])
            translate([
                dx,
                y_extrusion-1,
                dz
            ])
                rotate([-90,0,0])
                    cylinder(
                        h=bracket_thickness+2,
                        d=m5_hole_diameter,
                        $fn=28
                    );
    }
}

/* [Standalone preview] */
preview_vertical = "bottom"; // [bottom,top]
preview_side = "left"; // [left,right]
rotate([-90,0,0]) corner_bracket_3d(preview_vertical == "top", preview_side == "right");
