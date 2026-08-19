// HUB75 display frame - V1.1 panel seam joiner
//
// Separate printed plate spanning one vertical seam between two HUB75 panels.
// The two existing panel screw positions pass through one continuous joiner. Four
// small locating pins register the joiner in matching holes in the underlying
// 160 x 160 mm frame modules.

include <../config/project_config.scad>

module seam_joiner_outline_2d() {
    // One continuous plate rather than two circular pads joined by a narrow
    // bridge. Small chamfers keep the shape compact and consistent with the
    // angular language of the frame-module puzzle joints.
    center_x = (seam_joiner_left_screw_x + seam_joiner_right_screw_x) / 2;
    half_w = seam_joiner_width / 2;
    half_h = seam_joiner_height / 2;
    c = min(seam_joiner_corner_chamfer, half_w, half_h);

    translate([center_x, 0])
        polygon([
            [-half_w + c, -half_h],
            [ half_w - c, -half_h],
            [ half_w,     -half_h + c],
            [ half_w,      half_h - c],
            [ half_w - c,  half_h],
            [-half_w + c,  half_h],
            [-half_w,       half_h - c],
            [-half_w,      -half_h + c]
        ]);
}

module seam_joiner_body() {
    color(color_seam_joiner)
        difference() {
            translate([0,seam_joiner_thickness,0])
                rotate([90,0,0])
                    linear_extrude(height=seam_joiner_thickness)
                        seam_joiner_outline_2d();

            // The two existing HUB75 screws provide the actual clamping force.
            for(x=[seam_joiner_left_screw_x, seam_joiner_right_screw_x])
                translate([x,-0.1,0])
                    rotate([-90,0,0])
                        cylinder(
                            h=seam_joiner_thickness + 0.2,
                            d=seam_joiner_screw_hole_diameter,
                            $fn=28
                        );
        }
}

module seam_joiner_locating_pins() {
    color(color_seam_joiner)
        for(x=[-seam_joiner_pin_x_offset, seam_joiner_pin_x_offset])
            for(z=[-seam_joiner_pin_z_offset, seam_joiner_pin_z_offset])
                translate([x,0,z])
                    rotate([90,0,0])
                        cylinder(
                            h=seam_joiner_pin_length,
                            d=seam_joiner_pin_diameter,
                            $fn=24
                        );
}

module panel_seam_joiner(show_pins=true) {
    union() {
        seam_joiner_body();
        if(show_pins)
            seam_joiner_locating_pins();
    }
}

/* [Standalone preview] */
preview_show_pins = true;

panel_seam_joiner(show_pins=preview_show_pins);
