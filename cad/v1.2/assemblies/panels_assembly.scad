// HUB75 display frame - V1.2 panel array
//
// hub75_panel.scad is fully self-contained.
// This assembly owns the project-specific mapping from project_config.scad
// to the generic panel component.

include <../config/project_config.scad>
use <../components/hub75_panel.scad>


module project_hub75_panel(
    orientation_visible=true,
    show_connectors=true
) {
    hub75_panel(
        width=panel_width,
        height=panel_height,

        reference_width_value=
            panel_reference_nominal_width,

        reference_height_value=
            panel_reference_nominal_height,

        front_mask_depth_value=
            panel_front_mask_depth,

        pcb_thickness_value=
            panel_pcb_thickness,

        mounting_plane_y_value=
            panel_mounting_plane_y,

        max_depth_value=
            panel_max_depth,

        hole_x_left_value=panel_hole_x[0],
        hole_x_right_value=panel_hole_x[1],

        hole_z_bottom_value=panel_hole_z[0],
        hole_z_middle_value=panel_hole_z[1],
        hole_z_top_value=panel_hole_z[2],

        hole_diameter_value=
            panel_hole_diameter,

        boss_outer_diameter_value=
            panel_boss_outer_diameter,

        rear_frame_side_width_ref=12.5,
        rear_frame_end_width_ref=12.5,
        rear_frame_crossbar_width_ref=8.0,

        rear_crossbar_1_ref=80.0,
        rear_crossbar_2_ref=160.0,
        rear_crossbar_3_ref=240.0,

        data_connector_x_ref=80.0135,
        data_connector_z_bottom_ref=44.10,
        data_connector_z_top_ref=264.60,

        data_connector_width_ref=27.94,
        data_connector_height_ref=9.50,

        data_connector_depth_value=
            data_connector_depth,

        data_connector_front_y_value=
            data_connector_front_y,

        power_connector_width_value=
            power_connector_width,

        power_connector_height_value=
            power_connector_height,

        power_connector_depth_value=
            power_connector_depth,

        show_orientation=
            orientation_visible,

        show_connectors=
            show_connectors,

        // Project assembly colours.
        body_color=
            color_panel,

        front_color=
            [0.015, 0.015, 0.015, 1],

        pcb_color=
            color_pcb,

        connector_color=
            [0.06, 0.06, 0.06, 1]
    );
}


module panels_assembly(
    yshift=0,
    orientation_visible=true,
    panel_numbers_visible=true,
    in_out_labels_visible=true,
    show_connectors=true
) {
    // panel_numbers_visible and in_out_labels_visible are retained in this
    // interface for compatibility with the existing display assembly.
    // The STEP-based lightweight panel currently does not draw those labels.

    for(i=[0:panel_count-1]) {
        if(i % 2 == 0)
            translate([
                panel_x(i),
                panel_front_y + yshift,
                panel_z_offset
            ])
                project_hub75_panel(
                    orientation_visible=
                        orientation_visible,
                    show_connectors=
                        show_connectors
                );
        else
            translate([
                panel_x(i) + panel_width,
                panel_front_y + yshift,
                panel_z_offset + panel_height
            ])
                rotate([0,180,0])
                    project_hub75_panel(
                        orientation_visible=
                            orientation_visible,
                        show_connectors=
                            show_connectors
                    );
    }
}
