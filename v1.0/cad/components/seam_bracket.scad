// HUB75 display case component: seam_bracket
include <../config/project_config.scad>

module seam_bracket_2d(is_top=false) {
    dir = is_top ? -1 : 1;
    m3_oor_r = 8.0;
    m5_oor_r = 8.0;
    plate_extension = 10.0; // ONLY shape change: plate 10 mm higher

    hull() {
        // Existing M3 zone remains in exactly the same position.
        for(x=[-seam_offset,seam_offset])
            translate([x,0]) circle(r=m3_oor_r);

        // Extra upper points only extend the plate toward the DIN rail.
        for(x=[-seam_offset,seam_offset])
            translate([x,plate_extension*dir]) circle(r=m3_oor_r);

        // Existing M5 extrusion zone remains exactly unchanged.
        for(x=[-m5_center_spacing_x/2,m5_center_spacing_x/2])
            translate([x,-extrusion_offset*dir]) circle(r=m5_oor_r);
    }
}

module seam_bracket_3d(is_top=false) {
    dir = is_top ? -1 : 1;

    rail_end_z = rail_m3_clearance * dir;
    zadel_z0 = dir > 0 ? rail_end_z : rail_end_z-rail_clamp_length;
    zadel_z1 = dir > 0 ? rail_end_z+rail_clamp_length : rail_end_z;

    buiten_half_x =
        din_width/2 + rail_clamp_clearance_x + rail_clamp_wall;
    binnen_half_x =
        din_width/2 + rail_clamp_clearance_x;
    brug_y = din_height-rail_clamp_clearance_y;

    y_panel = 0;
    y_extrusion = panel_extrusion_y_offset;

    color(color_bracket)
    difference() {
        union() {
            // Completely flat top plate on the extrusion face.
            // The longer M3 bolts run through spacers to the panel.
            translate([0,y_extrusion+bracket_thickness,0])
                rotate([90,0,0])
                    linear_extrude(height=bracket_thickness)
                        hull() {
                            for(x=[-seam_offset,seam_offset]) {
                                translate([x,0]) circle(r=8,$fn=36);
                                translate([x,10*dir]) circle(r=8,$fn=36);
                            }
                        }

            // One continuous rounded M5 mounting plate.
            // The two existing M5 hole centers remain exactly unchanged.
            hull()
                for(x=[-m5_center_spacing_x/2,m5_center_spacing_x/2])
                    translate([
                        x,
                        y_extrusion+bracket_thickness,
                        -extrusion_offset*dir
                    ])
                        rotate([90,0,0])
                            cylinder(
                                h=bracket_thickness,
                                r=8,
                                $fn=48
                            );

            // Smooth connections between the M3 and M5 zones.
            // The top plate remains flat; only the outer contour is rounded.
            for(x=[-m5_center_spacing_x/2,m5_center_spacing_x/2])
                hull() {
                    translate([
                        x,
                        y_extrusion+bracket_thickness,
                        -3*dir // 2 mm higher; better aligned with the lower edge of the top plate
                    ])
                        rotate([90,0,0])
                            cylinder(
                                h=bracket_thickness,
                                r=5,
                                $fn=40
                            );

                    translate([
                        x,
                        y_extrusion+bracket_thickness,
                        -extrusion_offset*dir
                    ])
                        rotate([90,0,0])
                            cylinder(
                                h=bracket_thickness,
                                r=7,
                                $fn=48
                            );
                }

            // Spacers below the flat top plate.
            // They bridge the 6 mm gap to the panel without
            // obstructing access to the bolt head from the top side.
            for(x=[-seam_offset,seam_offset])
                translate([x,y_panel,0])
                    rotate([-90,0,0])
                        difference() {
                            cylinder(
                                h=y_extrusion,
                                d=10,
                                $fn=36
                            );
                            translate([0,0,-0.1])
                                cylinder(
                                    h=y_extrusion+0.2,
                                    d=m3_hole_diameter,
                                    $fn=28
                                );
                        }

            // DIN saddle remains directly on the rear panel surface.
            for(s=[-1,1])
                translate([
                    s>0 ? binnen_half_x : -buiten_half_x,
                    y_panel,
                    min(zadel_z0,zadel_z1)
                ])
                    cube([
                        rail_clamp_wall,
                        brug_y+rail_clamp_roof,
                        abs(zadel_z1-zadel_z0)
                    ]);

            translate([
                -buiten_half_x,
                y_panel+brug_y,
                min(zadel_z0,zadel_z1)
            ])
                cube([
                    2*buiten_half_x,
                    rail_clamp_roof,
                    abs(zadel_z1-zadel_z0)
                ]);

            stop_z = dir>0
                ? rail_end_z-rail_end_stop_thickness-rail_end_stop_overlap
                : rail_end_z;
            translate([
                -buiten_half_x,
                y_panel,
                stop_z
            ])
                cube([
                    2*buiten_half_x,
                    brug_y+rail_clamp_roof,
                    rail_end_stop_thickness+rail_end_stop_overlap
                ]);

            // Smooth transition from the M3 plate to the DIN saddle.
            // On the DIN side, the transition meets a flat surface within
            // the existing wall width, without an outward bulge.
            for(s=[-1,1])
                hull() {
                    translate([
                        s*(seam_offset+3),
                        y_panel+bracket_thickness+1,
                        5*dir
                    ])
                        rotate([90,0,0])
                            cylinder(
                                h=bracket_thickness+1,
                                r=3,
                                $fn=32
                            );

                    // Rechthoekig aansluitvlak binnen de DIN-wand.
                    // Geen ronde uitstulping aan de buitenzijde.
                    translate([
                        s>0
                            ? binnen_half_x-0.4
                            : -buiten_half_x,
                        y_panel,
                        rail_end_z
                            +dir*rail_transition_length/2
                            -3
                    ])
                        cube([
                            rail_clamp_wall+0.4,
                            brug_y+rail_clamp_roof,
                            6
                        ]);
                }
        }

        // Continuous M3 holes through the top plate and spacers.
        for(x=[-seam_offset,seam_offset])
            translate([x,y_panel-0.2,0])
                rotate([-90,0,0])
                    cylinder(
                        h=y_extrusion+bracket_thickness+0.4,
                        d=m3_hole_diameter,
                        $fn=28
                    );

        // M5 holes on the extrusion face recessed by 6 mm.
        for(x=[-m5_center_spacing_x/2,m5_center_spacing_x/2])
            translate([
                x,
                y_extrusion-1,
                -extrusion_offset*dir
            ])
                rotate([-90,0,0])
                    cylinder(
                        h=bracket_thickness+2,
                        d=m5_hole_diameter,
                        $fn=28
                    );

        // Vrije TS35-doorsnede.
        translate([
            -din_width/2-din_clearance,
            y_panel-0.01,
            min(zadel_z0,zadel_z1)-0.01
        ])
            cube([
                din_width+2*din_clearance,
                din_height+rail_clamp_clearance_y,
                abs(zadel_z1-zadel_z0)+0.02
            ]);
    }
}

/* [Standalone preview] */
preview_variant = "bottom"; // [bottom,top]
rotate([-90,0,0]) seam_bracket_3d(preview_variant == "top");
