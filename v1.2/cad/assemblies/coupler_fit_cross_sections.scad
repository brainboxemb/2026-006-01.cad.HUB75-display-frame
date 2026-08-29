// HUB75 display frame - V1.2 coupler transverse fit sections
//
// Narrow X slices through the nominal panel seam.  These views are intended
// to inspect the Y/Z fit of the seam locator rib, rear guide and panel body.
// The coupler remains positioned from the nominal 160 x 320 mm panel grid;
// the physical panel geometry is only used for the mating shape.

include <../config/project_config.scad>
use <../components/hub75_panel.scad>
use <panels_assembly.scad>
use <couplers_assembly.scad>

/* [Cross section] */
fit_cross_section_width = 2.0;
fit_cross_section_crop_y = 40.0;
fit_cross_section_crop_z = 150.0;

module fit_pair_at_local_seam(screw_row_z=0) {
    translate([
        panel_center_x(0) - seam_x(0),
        panel_front_y(),
        -screw_row_z
    ])
        project_hub75_panel(
            orientation_visible=false,
            show_connectors=false
        );

    translate([
        panel_center_x(1) - seam_x(0),
        panel_front_y(),
        -screw_row_z
    ])
        rotate([0,180,0])
            project_hub75_panel(
                orientation_visible=false,
                show_connectors=false
            );
}

module transverse_slice_volume(
    width=fit_cross_section_width,
    crop_y=fit_cross_section_crop_y,
    crop_z=fit_cross_section_crop_z
) {
    translate([
        -width/2,
        coupler_mounting_y() - crop_y,
        -crop_z/2
    ])
        cube([width, crop_y + 2.0, crop_z]);
}

module middle_panel_coupler_fit_cross_section(
    width=fit_cross_section_width,
    crop_y=fit_cross_section_crop_y,
    crop_z=fit_cross_section_crop_z
) {
    row_z = panel_hole_z_middle();

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            fit_pair_at_local_seam(row_z);
            transverse_slice_volume(width, crop_y, crop_z);
        }

    color(color_middle_panel_coupler)
        intersection() {
            translate([0, coupler_mounting_y(), 0])
                project_middle_panel_coupler();
            transverse_slice_volume(width, crop_y, crop_z);
        }
}

module horizontal_edge_panel_coupler_fit_cross_section(
    direction="top",
    width=fit_cross_section_width,
    crop_y=fit_cross_section_crop_y,
    crop_z=fit_cross_section_crop_z
) {
    row_z = direction == "top" ? panel_hole_z_top() : panel_hole_z_bottom();

    color([0.68, 0.68, 0.68, 1])
        intersection() {
            fit_pair_at_local_seam(row_z);
            transverse_slice_volume(width, crop_y, crop_z);
        }

    color(color_coupler)
        intersection() {
            translate([0, coupler_mounting_y(), 0])
                project_horizontal_edge_panel_coupler(
                    direction=direction,
                    screw_row_z=row_z
                );
            transverse_slice_volume(width, crop_y, crop_z);
        }
}
