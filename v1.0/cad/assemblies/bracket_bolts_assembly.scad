// HUB75 display case assembly: bracket_bolts_assembly
include <../config/project_config.scad>
use <../components/_lib/fasteners.scad>

module bracket_bolts_assembly(yshift=0) {
    // All bolt heads now lie on one flat top surface.
    // The M3 shank passes through the 6 mm spacer to the panel.
    yvlak_m3 = frame_back_y + yshift + bracket_thickness;
    yvlak_m5 = frame_back_y + yshift + bracket_thickness;

    // Seam brackets.
    for(i=[0:panel_count-2]) {
        x0 = seam_center(i);

        for(is_top=[false,true]) {
            z0 = is_top ? hole_z_top : hole_z_bottom;
            dir = is_top ? -1 : 1;

            // Two M3 panel bolts.
            for(dx=[-seam_offset,seam_offset])
                translate([x0+dx,yvlak_m3,z0])
                    bolt_with_washer_y(
                        d=3,
                        head_diameter=6,
                        head_height=2.5,
                        length=bracket_thickness+panel_extrusion_y_offset+6,
                        washer_outer=7
                    );

            // Two M5 bolts to the top/bottom frame rail.
            for(dx=[-m5_center_spacing_x/2,m5_center_spacing_x/2])
                translate([
                    x0+dx,
                    yvlak_m5,
                    z0-extrusion_offset*dir
                ])
                    bolt_with_washer_y(
                        d=m5_bolt_diameter,
                        head_diameter=m5_head_diameter,
                        head_height=m5_head_height,
                        length=bracket_thickness+10,
                        washer_outer=washer_diameter_m5
                    );
        }
    }

    // Outer L-brackets:
    // one M3 to the panel and two M5 bolts to the same horizontal frame rail.
    for(side=[0,1])
        for(top=[0,1]) {
            right = side == 1;
            is_top = top == 1;
            x0 = right
                ? hole_x(panel_count-1,true)
                : hole_x(0,false);
            z0 = is_top ? hole_z_top : hole_z_bottom;
            dz = is_top ? extrusion_offset : -extrusion_offset;
            dx_inwaarts = right ? -20 : 20;

            translate([x0,yvlak_m3,z0])
                bolt_with_washer_y(
                    d=3,
                    head_diameter=6,
                    head_height=2.5,
                    length=bracket_thickness+panel_extrusion_y_offset+6,
                    washer_outer=7
                );

            for(dx=[0,dx_inwaarts])
                translate([x0+dx,yvlak_m5,z0+dz])
                    bolt_with_washer_y(
                        d=m5_bolt_diameter,
                        head_diameter=m5_head_diameter,
                        head_height=m5_head_height,
                        length=bracket_thickness+10,
                        washer_outer=washer_diameter_m5
                    );
        }
}

// Standalone preview when this file is opened directly.
bracket_bolts_assembly();
