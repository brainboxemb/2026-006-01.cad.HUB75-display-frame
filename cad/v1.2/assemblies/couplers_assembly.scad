// HUB75 display frame - V1.2 coupler assembly
//
// Coupler geometry and defaults live in the component files. This assembly
// only places/orients those components in the five-panel display and supplies
// the local tube centre where required.

include <../config/project_config.scad>
use <../components/hub75_panel.scad>
use <../project_components/middle_panel_coupler.scad>
use <../project_components/horizontal_edge_panel_coupler.scad>
use <../project_components/corner_edge_panel_coupler.scad>

function coupler_mounting_y() = project_panel_rear_y;

module project_middle_panel_coupler() {
    middle_panel_coupler(part_color=color_middle_panel_coupler);
}

module project_horizontal_edge_panel_coupler(direction="top", screw_row_z=0) {
    tube_z = direction == "top" ? stiffening_tube_top_z() : stiffening_tube_bottom_z();
    horizontal_edge_panel_coupler(
        direction=direction,
        local_tube_y=stiffening_tube_y() - coupler_mounting_y(),
        local_tube_z=tube_z - screw_row_z,
        part_color=color_coupler
    );
}

module project_corner_edge_panel_coupler(side="left", direction="top", screw_row_z=0) {
    tube_z = direction == "top" ? stiffening_tube_top_z() : stiffening_tube_bottom_z();
    corner_edge_panel_coupler(
        side=side,
        direction=direction,
        local_tube_y=stiffening_tube_y() - coupler_mounting_y(),
        local_tube_z=tube_z - screw_row_z,
        part_color=color_corner_edge_panel_coupler
    );
}

module couplers_assembly(yshift=0, exploded=false) {
    y_offset = yshift + (exploded ? exploded_coupler_offset : 0);
    hole_z = panel_hole_z_positions();

    // Four internal seams.
    for(seam=[0:panel_count-2]) {
        x = seam_x(seam);

        translate([x, coupler_mounting_y()+y_offset, hole_z[0]])
            project_horizontal_edge_panel_coupler(direction="bottom", screw_row_z=hole_z[0]);

        translate([x, coupler_mounting_y()+y_offset, hole_z[1]])
            project_middle_panel_coupler();

        translate([x, coupler_mounting_y()+y_offset, hole_z[2]])
            project_horizontal_edge_panel_coupler(direction="top", screw_row_z=hole_z[2]);
    }

    // Four outside corners.
    left_x = panel_x(0) + hub75_panel_hole_x_left();
    right_x = panel_x(panel_count-1) + hub75_panel_hole_x_right();

    for(direction=["bottom","top"]) {
        z = direction == "top" ? panel_hole_z_top() : panel_hole_z_bottom();

        translate([left_x, coupler_mounting_y()+y_offset, z])
            project_corner_edge_panel_coupler(side="left", direction=direction, screw_row_z=z);

        translate([right_x, coupler_mounting_y()+y_offset, z])
            project_corner_edge_panel_coupler(side="right", direction=direction, screw_row_z=z);
    }
}
