// HUB75 display case component: matrixportal_mount
include <../config/project_config.scad>

module matrixportal_simple_mount() {
    // Compact mount directly on the TS35 rail:
    // flat plate, two snap zones and small side rims.
    plate_y = din_height + 2;

    color(color_bracket)
    union() {
        translate([
            -esp_simple_plate_width/2,
            plate_y,
            -esp_simple_plate_height/2
        ])
            cube([
                esp_simple_plate_width,
                esp_simple_plate_thickness,
                esp_simple_plate_height
            ]);

        // Support rim.
        translate([
            -esp_simple_plate_width/2,
            plate_y,
            -esp_simple_plate_height/2
        ])
            cube([
                esp_simple_plate_width,
                7,
                esp_simple_edge
            ]);

        // Two small side rims.
        for(sx=[-1,1])
            translate([
                sx > 0
                    ? esp_simple_plate_width/2-esp_simple_edge
                    : -esp_simple_plate_width/2,
                plate_y,
                -esp_simple_plate_height/2
            ])
                cube([
                    esp_simple_edge,
                    7,
                    esp_simple_plate_height
                ]);

        // Two snap blocks around the TS35 lips.
        for(sz=[-1,1]) {
            zc = sz*(esp_simple_plate_height/2-11);

            translate([
                -esp_simple_clip_width/2,
                din_height-din_thickness,
                zc-esp_simple_clip_width/2
            ])
                cube([
                    esp_simple_clip_width,
                    esp_simple_plate_thickness+4,
                    esp_simple_clip_width
                ]);

            translate([
                -din_width/2-0.5,
                din_height-din_thickness-4,
                zc-esp_simple_clip_width/2
            ])
                cube([
                    din_width+1,
                    4,
                    esp_simple_clip_width
                ]);
        }
    }
}

/* [Standalone preview] */
rotate([-90,0,0]) matrixportal_simple_mount();
