// HUB75 panel-array reference assembly
include <../config/project_config.scad>
use <../components/hub75_panel.scad>

module panels_assembly(
    yshift=0,
    orientation_visible=true,
    panel_numbers_visible=true,
    in_out_labels_visible=true
) {
    translate([0,panel_front_y+yshift,panel_z_offset]) {
        // Physical panels. The chain alternates orientation by 180 degrees.
        for(x_index=[0:panel_count-1]) {
            chain_number = panel_count - x_index;

            if(chain_number % 2 == 1)
                translate([panel_x(x_index),0,0])
                    hub75_panel(chain_number, orientation_visible);
            else
                translate([panel_x(x_index)+panel_width,0,panel_height])
                    rotate([0,180,0])
                        hub75_panel(chain_number, orientation_visible);
        }

        // Information layer, kept upright and readable from the rear.
        for(x_index=[0:panel_count-1]) {
            chain_number = panel_count - x_index;
            xc = panel_x(x_index) + panel_width/2;

            in_z = (chain_number % 2 == 1)
                ? data_connector_z_top
                : data_connector_z_bottom;
            out_z = (chain_number % 2 == 1)
                ? data_connector_z_bottom
                : data_connector_z_top;

            if(panel_numbers_visible)
                rear_text(
                    xc,
                    panel_height/2 + 34,
                    str("P",chain_number),
                    18,
                    [1.0,0.75,0.1,1]
                );

            if(in_out_labels_visible) {
                rear_text(xc,in_z+14,"IN",7);
                rear_text(xc,out_z-14,"OUT",7);
            }
        }
    }
}

/* [Preview] */
show_orientation = true;
show_panel_numbers = true;
show_in_out_labels = true;

panels_assembly(
    orientation_visible=show_orientation,
    panel_numbers_visible=show_panel_numbers,
    in_out_labels_visible=show_in_out_labels
);
