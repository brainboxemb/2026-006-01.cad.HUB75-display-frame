// HUB75 Display Frame - V1.2 / middle coupler V19
//
// Simplified proof-of-concept based directly on V1.1:
// - V1.1 HUB75 panel reference retained unchanged;
// - no 160 x 160 mm printed frame modules;
// - wider top/bottom two-panel couplers;
// - two tube clips per internal seam coupler, forming a shallow Y shape;
// - one-screw/one-clip couplers at both display ends;
// - simple middle seam couplers;
// - V1.1 aluminium tube size, position and 40/120 mm clip spacing retained.

include <config/project_config.scad>
use <assemblies/display_assembly.scad>
use <assemblies/panels_assembly.scad>
use <assemblies/couplers_assembly.scad>
use <assemblies/tubes_assembly.scad>
use <components/middle_seam_coupler.scad>
use <components/tube_seam_coupler.scad>
use <components/end_tube_coupler.scad>
use <assemblies/middle_coupler_fit_section.scad>
use <assemblies/rear_fit_section.scad>

/* [View] */
view_mode = "assembly"; // [assembly, exploded, panels, couplers, tubes, middle_coupler, middle_fit_section, rear_fit_section, seam_top, seam_bottom, end_left_top, end_right_top]

/* [Visibility] */
show_panels = true;
show_couplers = true;
show_stiffening_tubes = true;
show_orientation = false;
show_panel_numbers = false;
show_in_out_labels = false;

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

if(view_mode == "couplers")
    couplers_assembly();

if(view_mode == "tubes")
    tubes_assembly();

if(view_mode == "middle_coupler")
    project_middle_coupler();

if(view_mode == "middle_fit_section")
    middle_coupler_fit_section(
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


if(view_mode == "seam_top")
    project_tube_seam_coupler(direction="top", screw_row_z=panel_hole_z[2]);

if(view_mode == "seam_bottom")
    project_tube_seam_coupler(direction="bottom", screw_row_z=panel_hole_z[0]);

if(view_mode == "end_left_top")
    end_tube_coupler(side="left", direction="top");

if(view_mode == "end_right_top")
    end_tube_coupler(side="right", direction="top");
