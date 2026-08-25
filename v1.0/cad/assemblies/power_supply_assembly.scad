// HUB75 display case assembly: power_supply_assembly
include <../config/project_config.scad>
use <../components/power_supply_plate.scad>
use <../components/dc_dc_power_supply.scad>
use <../components/power_supply_top_bracket.scad>
use <../components/power_supply_bottom_bracket.scad>
use <../components/_lib/fasteners.scad>

module power_supply_assembly(yshift=0, bolts_visible=true) {
    plate_y = din_front_y + 2 + yshift;
    plate_z0 = power_supply_plate_bottom_z;
    power_supply_z = plate_z0 + power_supply_bottom_clearance + power_supply_height/2;

    power_supply_plate_model();

    // Power supply positioned higher on the plate, with cooling fins facing outward.
    translate([
        power_supply_plate_x_center,
        plate_y + power_supply_plate_thickness
            + power_supply_plate_spacing
            + power_supply_depth/2,
        power_supply_z
    ])
        dc_dc_power_supply_model();

    // One clear central top bracket to the same DIN rail.
    translate([
        power_supply_plate_x_center,
        din_back_y+yshift,
        plate_z0 + power_supply_plate_height - 14
    ])
        power_supply_top_bracket();

    // Two true L-brackets to the lower aluminium 2020 extrusion.
    for(dx=[
        -power_supply_frame_hole_spacing/2,
         power_supply_frame_hole_spacing/2
    ])
        translate([
            power_supply_plate_x_center + dx,
            plate_y + power_supply_plate_thickness,
            plate_z0
        ])
            power_supply_bottom_bracket();

    if(bolts_visible) {
        // The four power-supply bolts are not modeled on the inside.
        // This prevents bolts from protruding between the display panels and the metal plate.

        // Two M4 bolts through the plate to the central top bracket.
        for(dz=[-7,7])
            translate([
                power_supply_plate_x_center,
                plate_y + power_supply_plate_thickness + 0.2,
                plate_z0 + power_supply_plate_height - 14 + dz
            ])
                rotate([90,0,0])
                    m4_plate_bolt(length=power_supply_top_bracket_thickness+power_supply_plate_thickness+7);

        // Lower brackets: one M5 through the plate and one M5 to the T-slot.
        for(dx=[
            -power_supply_frame_hole_spacing/2,
             power_supply_frame_hole_spacing/2
        ]) {
            // Upper plate bolt: head on the visible side,
            // shank inward through the plate and bracket flange.
            translate([
                power_supply_plate_x_center + dx,
                plate_y + power_supply_plate_thickness
                    + power_supply_bottom_bracket_thickness + m5_head_height,
                plate_z0 + 21
            ]) {
                bolt_y(
                    d=m5_bolt_diameter,
                    head_diameter=m5_head_diameter,
                    head_height=m5_head_height,
                    length=power_supply_bottom_bracket_thickness
                        + power_supply_plate_thickness + 5,
                    direction=-1
                );
                translate([0,-m5_head_height-washer_thickness,0])
                    washer_y(washer_diameter_m5,m5_bolt_diameter,washer_thickness,-1);
            }

            // M5 from the rear in the Y direction toward the
            // rear T-slot of the lower 2020 extrusion.
            translate([
                power_supply_plate_x_center + dx,
                frame_back_y + power_supply_bottom_bracket_thickness + m5_head_height,
                extrusion_size/2
            ]) {
                bolt_y(
                    d=m5_bolt_diameter,
                    head_diameter=m5_head_diameter,
                    head_height=m5_head_height,
                    length=14,
                    direction=-1
                );
                translate([0,-m5_head_height-washer_thickness,0])
                    washer_y(washer_diameter_m5,m5_bolt_diameter,washer_thickness,-1);
            }

            translate([
                power_supply_plate_x_center + dx,
                frame_back_y-2,
                extrusion_size/2
            ])
                t_nut_y_model();
        }
    }

}

// Standalone preview settings.
/* [Preview] */
show_bolts = true;

power_supply_assembly(bolts_visible=show_bolts);
