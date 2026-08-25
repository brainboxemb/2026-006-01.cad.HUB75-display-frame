// HUB75 display frame - V1.2 middle coupler fit section
//
// Two real HUB75 panel components plus the real middle panel coupler.
// Everything behind a plane 5 mm into the rear of the panels is removed,
// leaving a true exposed 3D section through the rib/coupler interface.

include <../config/project_config.scad>
use <../components/hub75_panel.scad>
use <panels_assembly.scad>
use <couplers_assembly.scad>

/* [Section] */
fit_section_depth = 5.0;
fit_section_crop_width = 145.0;
fit_section_crop_height = 115.0;

module left_fit_panel() {
    translate([
        panel_center_x(0) - seam_x(0),
        panel_front_y(),
        -panel_hole_z_middle()
    ])
        project_hub75_panel(
            orientation_visible=false,
            show_connectors=false
        );
}

module right_fit_panel() {
    translate([
        panel_center_x(1) - seam_x(0),
        panel_front_y(),
        -panel_hole_z_middle()
    ])
        rotate([0,180,0])
            project_hub75_panel(
                orientation_visible=false,
                show_connectors=false
            );
}

module section_keep_volume(depth, crop_width, crop_height) {
    section_y = coupler_mounting_y() - depth;

    // Keep the front side up to the section plane and crop around the local
    // middle-coupler area. The cut face itself lies at Y=section_y.
    translate([
        -crop_width/2,
        panel_front_y() - 1.0,
        -crop_height/2
    ])
        cube([
            crop_width,
            section_y - (panel_front_y() - 1.0),
            crop_height
        ]);
}

module middle_panel_coupler_fit_section(
    depth=fit_section_depth,
    crop_width=fit_section_crop_width,
    crop_height=fit_section_crop_height
) {
    color([0.68, 0.68, 0.68, 1])
        intersection() {
            union() {
                left_fit_panel();
                right_fit_panel();
            }
            section_keep_volume(depth, crop_width, crop_height);
        }

    color(color_middle_panel_coupler)
        intersection() {
            translate([0, coupler_mounting_y(), 0])
                project_middle_panel_coupler();
            section_keep_volume(depth, crop_width, crop_height);
        }
}

middle_panel_coupler_fit_section();

$vpt = [0, coupler_mounting_y()-fit_section_depth, 0];
$vpr = [72, 0, 180];
$vpd = 190;
