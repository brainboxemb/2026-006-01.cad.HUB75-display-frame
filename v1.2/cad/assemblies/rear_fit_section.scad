// HUB75 display frame - V1.2 full rear fit section
//
// The display is cut 5 mm forward from the rear mounting plane. This exposes the interface
// between the real HUB75 rear ribs and every printed coupler simultaneously.

include <../config/project_config.scad>
use <../components/hub75_panel.scad>
use <panels_assembly.scad>
use <couplers_assembly.scad>

/* [Section] */
rear_fit_section_depth = 5.0;
rear_fit_section_margin = 18.0;

module rear_section_keep_volume(depth=rear_fit_section_depth, margin=rear_fit_section_margin) {
    section_y = coupler_mounting_y() - depth;

    translate([
        -display_envelope_width/2 - margin,
        panel_front_y() - 1.0,
        -display_envelope_height/2 - margin
    ])
        cube([
            display_envelope_width + 2*margin,
            section_y - (panel_front_y() - 1.0),
            display_envelope_height + 2*margin
        ]);
}

module rear_fit_section(
    depth=rear_fit_section_depth,
    margin=rear_fit_section_margin,
    show_panel_numbers=false,
    show_io_labels=false
) {
    // Grey: rear structural panel frame only. The front pixel face and PCB are hidden
    // so individual panel rims and seams remain readable in this verification view.
    color([0.68, 0.68, 0.68, 1])
        intersection() {
            panels_assembly(
                orientation_visible=false,
                panel_numbers_visible=show_panel_numbers,
                in_out_labels_visible=show_io_labels,
                show_connectors=false,
                show_front_layers=false,
                body_color_value=[0.68, 0.68, 0.68, 1],
                web_color_value=[0.52, 0.52, 0.52, 1]
            );
            rear_section_keep_volume(depth, margin);
        }

    // Red: only the parts of the printed couplers that enter the same volume.
    color(color_middle_panel_coupler)
        intersection() {
            couplers_assembly();
            rear_section_keep_volume(depth, margin);
        }
}

rear_fit_section();

$vpt = [0, coupler_mounting_y()-rear_fit_section_depth, 0];
$vpr = [90, 0, 180];
$vpd = 1200;
