// HUB75 display frame - V1.2 panel array
//
// hub75_panel.scad is fully self-contained and centred around X=0 / Z=0.
// This assembly maps project coordinates to that centred component.

include <../config/project_config.scad>
use <../components/hub75_panel.scad>


module project_hub75_panel(
    orientation_visible=true,
    show_connectors=true
) {
    hub75_panel(
        width=panel_width,
        height=panel_height,

        reference_width_value=panel_reference_nominal_width,
        reference_height_value=panel_reference_nominal_height,

        front_mask_depth_value=panel_front_mask_depth,
        pcb_thickness_value=panel_pcb_thickness,
        mounting_plane_y_value=panel_mounting_plane_y,
        max_depth_value=panel_max_depth,

        hole_x_left_value=panel_hole_x[0],
        hole_x_right_value=panel_hole_x[1],
        hole_z_bottom_value=panel_hole_z[0],
        hole_z_middle_value=panel_hole_z[1],
        hole_z_top_value=panel_hole_z[2],
        hole_diameter_value=panel_hole_diameter,

        show_orientation=orientation_visible,
        show_connectors=show_connectors,
        show_rear_recess=true,
        show_pdf_verification_grid=false,

        body_color=color_panel,
        web_color=[0.62, 0.62, 0.62, 1],
        front_color=[0.52, 0.52, 0.52, 1],
        pcb_color=color_pcb,
        connector_color=[0.06, 0.06, 0.06, 1]
    );
}


module panels_assembly(
    yshift=0,
    orientation_visible=true,
    panel_numbers_visible=true,
    in_out_labels_visible=true,
    show_connectors=true
) {
    // panel_numbers_visible and in_out_labels_visible are retained for
    // compatibility with display_assembly.
    //
    // The panel component is now centred around X=0 and Z=0. Every panel is
    // therefore translated to its centre in the global nominal 160 mm grid.
    // Odd panels can be rotated directly around that centre without the old
    // width/height compensation translations.
    for(i=[0:panel_count-1]) {
        translate([
            panel_center_x(i),
            panel_front_y + yshift,
            panel_center_z()
        ])
            if(i % 2 == 0)
                project_hub75_panel(
                    orientation_visible=orientation_visible,
                    show_connectors=show_connectors
                );
            else
                rotate([0,180,0])
                    project_hub75_panel(
                        orientation_visible=orientation_visible,
                        show_connectors=show_connectors
                    );
    }
}
