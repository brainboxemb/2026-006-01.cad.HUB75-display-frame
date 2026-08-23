// HUB75 Display Frame - V1.2 / project coordinates and envelope V82 - comparison/profile alignment + switchable coupler profiles + plate thickness + symmetric lightweight T-coupler raster V100
//
// Simplified proof-of-concept based directly on V1.1:
// - V1.1 HUB75 panel reference retained unchanged;
// - no 160 x 160 mm printed frame modules;
// - wider top/bottom two-panel couplers;
// - four short tube clips per horizontal edge panel coupler;
// - one-screw/one-clip couplers at both display ends;
// - rounded middle panel couplers;
// - V1.1 aluminium tube size, position and 40/120 mm clip spacing retained.

include <config/project_config.scad>
use <assemblies/display_assembly.scad>
use <assemblies/panels_assembly.scad>
use <assemblies/couplers_assembly.scad>
use <assemblies/tubes_assembly.scad>
use <project_components/middle_panel_coupler.scad>
use <project_components/horizontal_edge_panel_coupler.scad>
use <project_components/corner_edge_panel_coupler.scad>
use <assemblies/middle_panel_coupler_fit_section.scad>
use <assemblies/rear_fit_section.scad>
use <assemblies/coupler_comparison_assembly.scad>
use <components/_lib/reference_grid.scad>
use <components/_lib/reference_box.scad>
use <components/hub75_panel.scad>

/* [View] */
view_mode = "assembly"; // [assembly, exploded, panels, single_panel, couplers, tubes, middle_panel_coupler, horizontal_edge_panel_coupler, middle_panel_fit_section, rear_fit_section, corner_edge_panel_coupler_left, corner_edge_panel_coupler_right, couplers_side_by_side, couplers_stacked]

/* [Coupler profile] */
coupler_design_profile = "default"; // [default,lightweight]
use_custom_coupler_dimensions = false;

// These are plain numeric input boxes and are only used when custom dimensions is enabled.
coupler_custom_profile_size = 100;
coupler_custom_wall_thickness = 6;
coupler_custom_guide_height = 10;
coupler_custom_base_thickness = 4;

// Pass the visible Customizer values into all project components and assemblies.
$coupler_design_profile = coupler_design_profile;
$coupler_use_custom_dimensions = use_custom_coupler_dimensions;
$coupler_custom_profile_size = coupler_custom_profile_size;
$coupler_custom_wall_thickness = coupler_custom_wall_thickness;
$coupler_custom_guide_height = coupler_custom_guide_height;
$coupler_custom_base_thickness = coupler_custom_base_thickness;

/* [Visibility] */
show_panels = true;
show_couplers = true;
show_stiffening_tubes = true;
show_orientation = false;
show_panel_numbers = false;
show_in_out_labels = false;
show_project_envelope = false;

/* [Panel settings] */
// Reference grid is currently supported by the single_panel inspection view.
// The geometry itself remains generic so other inspection views can reuse it later.
show_reference_grid = true;
reference_grid_spacing = 10; // [5:5:20]
reference_grid_half_step = true;

/* [Exploded view] */
exploded_distance = 40; // [10:5:80]

if(view_mode == "assembly")
    display_assembly(
        panels_visible=show_panels,
        couplers_visible=show_couplers,
        stiffening_tubes_visible=show_stiffening_tubes,
        orientation_visible=show_orientation,
        panel_numbers_visible=show_panel_numbers,
        in_out_labels_visible=show_in_out_labels
    );

if(view_mode == "exploded")
    display_assembly(
        panels_visible=show_panels,
        couplers_visible=show_couplers,
        stiffening_tubes_visible=show_stiffening_tubes,
        orientation_visible=show_orientation,
        panel_numbers_visible=show_panel_numbers,
        in_out_labels_visible=show_in_out_labels,
        explode_distance=exploded_distance
    );

if(view_mode == "panels")
    panels_assembly(
        orientation_visible=show_orientation,
        panel_numbers_visible=show_panel_numbers,
        in_out_labels_visible=show_in_out_labels
    );

// Generic reference-grid geometry lives in components/_lib/reference_grid.scad.
// Each supported view supplies its own extents and plane position.

// Single physical HUB75 panel, centred at the local component origin.
// This view is intended for tuning panel details such as the IDC connector.
if(view_mode == "single_panel") {
    project_hub75_panel(
        orientation_visible=show_orientation,
        show_connectors=true
    );

    if(show_reference_grid)
        reference_grid_xz(
            width=hub75_panel_width(),
            height=hub75_panel_height(),
            y=hub75_panel_mounting_plane_y() + 3.6,
            major=reference_grid_spacing,
            show_half=reference_grid_half_step
        );
}

if(view_mode == "couplers")
    couplers_assembly();

if(view_mode == "tubes")
    tubes_assembly();

if(view_mode == "middle_panel_coupler")
    project_middle_panel_coupler();

if(view_mode == "middle_panel_fit_section")
    middle_panel_coupler_fit_section(
        depth=5.0,
        crop_width=145.0,
        crop_height=115.0
    );

if(view_mode == "rear_fit_section")
    rear_fit_section(
        depth=5.0,
        show_panel_numbers=show_panel_numbers,
        show_io_labels=show_in_out_labels
    );


// Top and bottom are the same printable component.  The assembly mirrors/
// orients it as required, so one canonical component view is sufficient.
if(view_mode == "horizontal_edge_panel_coupler")
    project_horizontal_edge_panel_coupler(direction="top", screw_row_z=panel_hole_z_top());

if(view_mode == "corner_edge_panel_coupler_left")
    project_corner_edge_panel_coupler(side="left", direction="top", screw_row_z=panel_hole_z_top());

if(view_mode == "corner_edge_panel_coupler_right")
    project_corner_edge_panel_coupler(side="right", direction="top", screw_row_z=panel_hole_z_top());

if(view_mode == "couplers_side_by_side")
    coupler_comparison_side_by_side(
        show_grid=show_reference_grid,
        grid_major=reference_grid_spacing,
        grid_half_step=reference_grid_half_step
    );

if(view_mode == "couplers_stacked")
    coupler_comparison_stacked(
        show_grid=show_reference_grid,
        grid_major=reference_grid_spacing,
        grid_half_step=reference_grid_half_step
    );


// Optional project-level dimensional check. The 840 x 360 rectangle is
// centred on X=0 / Z=0. Four Y-direction corner lines make the current design
// depth explicit from the panel front face to the Y=0 rear mounting plane.
if(show_project_envelope)
    reference_box_wireframe(
        x_min=display_envelope_x_min(),
        x_max=display_envelope_x_max(),
        y_min=display_envelope_y_min(),
        y_max=display_envelope_y_max(),
        z_min=display_envelope_z_min(),
        z_max=display_envelope_z_max(),
        line_thickness=0.6
    );
