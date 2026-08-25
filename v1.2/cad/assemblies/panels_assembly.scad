// HUB75 display frame - V1.2 panel array
//
// Physical panel geometry comes exclusively from hub75_panel.scad.
// This assembly only decides how many panels exist, where they are placed and
// how the rear data chain is ordered.

include <../config/project_config.scad>
use <../components/hub75_panel.scad>

module project_hub75_panel(
    orientation_visible=true,
    show_connectors=true
) {
    hub75_panel(
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

// Rear-view annotation styling.  These are deliberately high-contrast against
// both the grey panel body and the red couplers used in documentation renders.
rear_panel_number_color = [0.25, 0.90, 1.00, 1];
rear_input_label_color = [0.20, 1.00, 0.35, 1];
rear_output_label_color = [0.25, 0.90, 1.00, 1];
rear_io_label_visual_offset = 28;

module rear_text_label(label, x, z, size=10, label_color=rear_panel_number_color) {
    color(label_color)
        translate([x, project_panel_rear_y + 0.35, z])
            rotate([90,0,180])
                linear_extrude(height=0.35)
                    text(label, size=size, halign="center", valign="center");
}

// Annotation coordinates must follow the centred component coordinate system.
// hub75_panel_data_connector_z_*() intentionally expose drawing coordinates
// measured from the lower panel edge; panel_drawing_z() converts them to the
// project coordinates used after hub75_panel() centres itself on Z=0.
function panel_data_connector_z_top() =
    panel_drawing_z(hub75_panel_data_connector_z_top());
function panel_data_connector_z_bottom() =
    panel_drawing_z(hub75_panel_data_connector_z_bottom());

// The documentation camera looks at the rear with X visually mirrored.  Keep
// this detail here so annotation placement is expressed in visual left/right
// terms rather than by trial-and-error world-coordinate offsets.
function rear_visual_x(panel_x, visual_offset) = panel_x - visual_offset;

module panel_chain_annotations(global_index, show_number=true, show_io=true) {
    chain_no = panel_chain_number(global_index);
    input_top = panel_input_is_top(global_index);
    cx = panel_center_x(global_index);
    input_z = input_top ? panel_data_connector_z_top() : panel_data_connector_z_bottom();
    output_z = input_top ? panel_data_connector_z_bottom() : panel_data_connector_z_top();

    if(show_number)
        rear_text_label(
            str(chain_no),
            cx,
            panel_center_z(),
            15,
            rear_panel_number_color
        );

    if(show_io) {
        // Put IN to the visual right and OUT to the visual left of their real
        // HUB75 connector centre so the text no longer sits on top of it.
        rear_text_label(
            "IN",
            rear_visual_x(cx, rear_io_label_visual_offset),
            input_z,
            8,
            rear_input_label_color
        );
        rear_text_label(
            "OUT",
            rear_visual_x(cx, -rear_io_label_visual_offset),
            output_z,
            8,
            rear_output_label_color
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
            panel_front_y() + yshift,
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
