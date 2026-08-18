// HUB75 display case component: din_rail
include <../config/project_config.scad>

module din_rail_3d(length=din_length) {
    // Vereenvoudigde maar herkenbare TS35x7.5-hoedvorm:
    // narrow center web against the panel, two upright walls
    // and two outward-formed lips.
    color(color_din)
    union() {
        center_half = din_center_web_width/2;
        totaal_half = din_width/2;

        // Center web directly against the panel
        translate([-center_half,0,0])
            cube([din_center_web_width,din_thickness,length]);

        // Opstaande zijwanden
        translate([-center_half,0,0])
            cube([din_thickness,din_height,length]);
        translate([center_half-din_thickness,0,0])
            cube([din_thickness,din_height,length]);

        // Formed lips facing outward
        translate([-totaal_half,din_height-din_thickness,0])
            cube([din_lip_width,din_thickness,length]);
        translate([totaal_half-din_lip_width,din_height-din_thickness,0])
            cube([din_lip_width,din_thickness,length]);
    }
}

/* [Standalone preview] */
preview_length = din_length;
din_rail_3d(preview_length);
