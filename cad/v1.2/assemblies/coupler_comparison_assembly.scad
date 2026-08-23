// HUB75 display frame - V1.2 coupler comparison assembly V94
//
// This assembly is directly viewable: open this file in OpenSCAD and use the
// Customizer below.  When imported with `use`, the standalone invocation is
// ignored and only the modules/functions are made available.

include <../config/project_config.scad>
use <couplers_assembly.scad>
use <../components/hub75_panel.scad>
use <../components/_lib/reference_grid.scad>
use <../project_components/horizontal_edge_panel_coupler.scad>
use <../project_components/corner_edge_panel_coupler.scad>

/* [Standalone view] */
comparison_view = "side_by_side"; // [side_by_side, stacked]
show_reference_grid = true;
reference_grid_spacing = 10; // [5:5:20]
reference_grid_half_step = true;

comparison_side_spacing = 140;
comparison_stack_spacing = 125;
comparison_side_grid_width = 560;
comparison_side_grid_height = 140;
comparison_stack_grid_width = 150;
comparison_stack_grid_height = 520;
comparison_grid_y = -0.20;

function comparison_two_screw_alignment_x() = -hub75_panel_hole_x_left();

module coupler_comparison_side_by_side(
    spacing=comparison_side_spacing,
    show_grid=false,
    grid_major=10,
    grid_half_step=true
) {
    screw_row_z = panel_hole_z_top();

    // Use anchors published by the components themselves.  The comparison
    // assembly therefore cannot silently drift away when a component's local
    // reference geometry changes.
    edge_cross_z = horizontal_edge_panel_coupler_reference_z("top");
    corner_cross_z = corner_edge_panel_coupler_reference_z("top");
    corner_left_cross_x = corner_edge_panel_coupler_reference_x("left");
    corner_right_cross_x = corner_edge_panel_coupler_reference_x("right");

    if(show_grid)
        reference_grid_xz(
            width=comparison_side_grid_width,
            height=comparison_side_grid_height,
            y=comparison_grid_y,
            major=grid_major,
            show_half=grid_half_step
        );

    translate([1.5*spacing, 0, 0])
        project_middle_panel_coupler();

    translate([0.5*spacing, 0, -edge_cross_z])
        project_horizontal_edge_panel_coupler(
            direction="top",
            screw_row_z=screw_row_z
        );

    translate([-0.5*spacing - corner_left_cross_x, 0, -corner_cross_z])
        project_corner_edge_panel_coupler(
            side="left",
            direction="top",
            screw_row_z=screw_row_z
        );

    translate([-1.5*spacing - corner_right_cross_x, 0, -corner_cross_z])
        project_corner_edge_panel_coupler(
            side="right",
            direction="top",
            screw_row_z=screw_row_z
        );
}

module coupler_comparison_stacked(
    spacing=comparison_stack_spacing,
    show_grid=false,
    grid_major=10,
    grid_half_step=true
) {
    screw_row_z = panel_hole_z_top();
    two_screw_shift_x = comparison_two_screw_alignment_x();

    if(show_grid)
        reference_grid_xz(
            width=comparison_stack_grid_width,
            height=comparison_stack_grid_height,
            y=comparison_grid_y,
            major=grid_major,
            show_half=grid_half_step
        );

    translate([two_screw_shift_x, 0, 1.5*spacing])
        project_middle_panel_coupler();

    translate([two_screw_shift_x, 0, 0.5*spacing])
        project_horizontal_edge_panel_coupler(
            direction="top",
            screw_row_z=screw_row_z
        );

    translate([0, 0, -0.5*spacing])
        project_corner_edge_panel_coupler(
            side="left",
            direction="top",
            screw_row_z=screw_row_z
        );

    translate([0, 0, -1.5*spacing])
        project_corner_edge_panel_coupler(
            side="right",
            direction="top",
            screw_row_z=screw_row_z
        );
}

// Standalone assembly preview.  `use <...>` ignores this top-level statement,
// so main.scad and render/export entry points do not get duplicate geometry.
if(comparison_view == "side_by_side")
    coupler_comparison_side_by_side(
        show_grid=show_reference_grid,
        grid_major=reference_grid_spacing,
        grid_half_step=reference_grid_half_step
    );
else
    coupler_comparison_stacked(
        show_grid=show_reference_grid,
        grid_major=reference_grid_spacing,
        grid_half_step=reference_grid_half_step
    );
