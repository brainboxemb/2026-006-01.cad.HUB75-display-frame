// HUB75 display case assembly: frame_assembly
include <../config/project_config.scad>
use <../components/aluminium_extrusion.scad>

module frame_assembly(yshift=0) {
    translate([0,frame_front_y+yshift,0]) {
        // Buitenmaat 840 x 360.
        aluminium_extrusion_3d(horizontal_extrusion_length,true);
        translate([0,0,frame_height-extrusion_size])
            aluminium_extrusion_3d(horizontal_extrusion_length,true);

        // 320 mm vertical extrusions between the top and bottom rails.
        translate([0,0,extrusion_size])
            aluminium_extrusion_3d(vertical_extrusion_length,false);
        translate([horizontal_extrusion_length-extrusion_size,0,extrusion_size])
            aluminium_extrusion_3d(vertical_extrusion_length,false);
    }
}

// Standalone preview when this file is opened directly.
frame_assembly();
