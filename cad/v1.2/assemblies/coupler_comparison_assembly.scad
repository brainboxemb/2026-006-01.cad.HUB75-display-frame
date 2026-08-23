// HUB75 display frame - V1.2 coupler comparison assembly V105
//
// Diagnostic assembly for comparing all four printable coupler variants from
// the same geometric reference point. The individual components remain fully
// parametric; this file only places them on a common grid.

include <../config/project_config.scad>
use <couplers_assembly.scad>
use <../components/hub75_panel.scad>
use <../components/_lib/reference_grid.scad>

/* [Coupler profile] */
coupler_design_profile = "default"; // [default,lightweight]
use_custom_coupler_dimensions = false;
coupler_custom_profile_size = 100;
coupler_custom_wall_thickness = 6;
coupler_custom_guide_height = 10;
coupler_custom_base_thickness = 4;

$coupler_design_profile = coupler_design_profile;
$coupler_use_custom_dimensions = use_custom_coupler_dimensions;
$coupler_custom_profile_size = coupler_custom_profile_size;
$coupler_custom_wall_thickness = coupler_custom_wall_thickness;
$coupler_custom_guide_height = coupler_custom_guide_height;
$coupler_custom_base_thickness = coupler_custom_base_thickness;

// Comparison spacing is derived from the active nominal profile size.  It is
// intentionally independent of the actual asymmetric edge/corner outlines:
// every component is aligned by its own geometric + reference at [0,0,0].
function coupler_comparison_pitch() = project_coupler_profile_size() + 30;
function coupler_comparison_grid_margin() = 20;

module coupler_comparison_variant(index) {
    if (index == 0)
        project_corner_edge_panel_coupler(
            side="left",
            direction="top",
            screw_row_z=panel_hole_z_top()
        );
    else if (index == 1)
        project_horizontal_edge_panel_coupler(
            direction="top",
            screw_row_z=panel_hole_z_top()
        );
    else if (index == 2)
        project_middle_panel_coupler();
    else if (index == 3)
        project_corner_edge_panel_coupler(
            side="right",
            direction="top",
            screw_row_z=panel_hole_z_top()
        );
}

module coupler_comparison_side_by_side(
    show_grid=true,
    grid_major=10,
    grid_half_step=true
) {
    pitch = coupler_comparison_pitch();
    width = 3*pitch + project_coupler_profile_size() + 2*coupler_comparison_grid_margin();
    height = project_coupler_profile_size() + 2*coupler_comparison_grid_margin();

    if (show_grid)
        reference_grid_xz(
            width=width,
            height=height,
            y=0.25,
            major=grid_major,
            show_half=grid_half_step
        );

    for (i=[0:3])
        translate([(i-1.5)*pitch, 0, 0])
            coupler_comparison_variant(i);
}

module coupler_comparison_stacked(
    show_grid=true,
    grid_major=10,
    grid_half_step=true
) {
    pitch = coupler_comparison_pitch();
    width = project_coupler_profile_size() + 2*coupler_comparison_grid_margin();
    height = 3*pitch + project_coupler_profile_size() + 2*coupler_comparison_grid_margin();

    if (show_grid)
        reference_grid_xz(
            width=width,
            height=height,
            y=0.25,
            major=grid_major,
            show_half=grid_half_step
        );

    for (i=[0:3])
        translate([0, 0, (1.5-i)*pitch])
            coupler_comparison_variant(i);
}
