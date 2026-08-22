// HUB75 display frame - V1.2 panel array
//
// Panel orientation and numbering are explicitly defined from the REAR.
// By default panel 1 is rear-left with its HUB75 input at the top. The chain
// then snakes across the display, rotating every second panel by 180 degrees.

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

module rear_text_label(label, x, z, size=10, label_color=[0.05,0.05,0.05,1]) {
    color(label_color)
        translate([x, panel_mounting_plane_y + 0.35, z])
            rotate([90,0,180])
                linear_extrude(height=0.35)
                    text(label, size=size, halign="center", valign="center");
}

module panel_chain_annotations(global_index, show_number=true, show_io=true) {
    chain_no = panel_chain_number(global_index);
    input_top = panel_input_is_top(global_index);
    cx = panel_center_x(global_index);

    if(show_number)
        rear_text_label(str(chain_no), cx, panel_center_z(), 15, [0.15,0.15,0.15,1]);

    if(show_io) {
        rear_text_label(
            chain_no == 1 ? "1  IN" : "IN",
            cx,
            input_top ? data_connector_z_top : data_connector_z_bottom,
            8,
            [0.0,0.35,0.0,1]
        );
        rear_text_label(
            "OUT",
            cx,
            input_top ? data_connector_z_bottom : data_connector_z_top,
            8,
            [0.35,0.0,0.0,1]
        );
    }
}

module panels_assembly(
    yshift=0,
    orientation_visible=true,
    panel_numbers_visible=true,
    in_out_labels_visible=true,
    show_connectors=true
) {
    for(i=[0:panel_count-1]) {
        translate([
            panel_center_x(i),
            panel_front_y + yshift,
            panel_center_z()
        ])
            if(panel_rotated(i))
                rotate([0,180,0])
                    project_hub75_panel(
                        orientation_visible=orientation_visible,
                        show_connectors=show_connectors
                    );
            else
                project_hub75_panel(
                    orientation_visible=orientation_visible,
                    show_connectors=show_connectors
                );

        if(panel_numbers_visible || in_out_labels_visible)
            translate([0,yshift,0])
                panel_chain_annotations(
                    i,
                    show_number=panel_numbers_visible,
                    show_io=in_out_labels_visible
                );
    }
}
