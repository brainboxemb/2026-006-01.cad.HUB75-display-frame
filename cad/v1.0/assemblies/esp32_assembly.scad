// HUB75 display case assembly: esp32_assembly
include <../config/project_config.scad>
use <../components/matrixportal_mount.scad>
use <../components/matrixportal_s3.scad>
use <../components/_lib/fasteners.scad>

module esp32_assembly(yshift=0, bolts_visible=true) {
    // Panel 1 is visually left in the rear view.
    // ESP32 positioned as high as possible on the visually leftmost DIN rail.
    rail_x = seam_center(panel_count-2);
    esp_z = din_z_end - esp_simple_plate_height/2 - esp_simple_top_clearance;

    translate([rail_x,din_back_y+yshift,esp_z])
        matrixportal_simple_mount();

    translate([
        rail_x - esp_board_length/2,
        din_back_y+yshift + din_height + esp_simple_plate_thickness + 3,
        esp_z - esp_board_width/2
    ])
        matrixportal_s3_model();

    if(bolts_visible)
        for(dx=[-esp_board_length/2+6,esp_board_length/2-6])
            for(dz=[-esp_board_width/2+6,esp_board_width/2-6])
                translate([
                    rail_x + dx,
                    din_back_y+yshift + din_height
                        + esp_simple_plate_thickness + 6,
                    esp_z + dz
                ]) {
                    bolt_y(3,6,2.5,esp_simple_plate_thickness+6,-1);
                    translate([0,-3.5,0])
                        washer_y(7,3,washer_thickness,-1);
                }

}

// Standalone preview settings.
/* [Preview] */
show_bolts = true;

esp32_assembly(bolts_visible=show_bolts);
