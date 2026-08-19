// HUB75 display frame - V1.1
//
// V1.1 direction: a modular 3D-printed structural frame based on a nominal
// 160 x 160 mm grid, reinforced by aluminium tubes above and below the panel array.
// The printed modules extend straight beyond the panel edge and the tube clamps
// sit beside those extensions. Exposed tube sections can later also serve as a
// clip interface for the visible border.

/* [View] */
view_mode = "assembly"; // [assembly, exploded, panels_only, frame_modules_only, seam_joiners_only, stiffening_tubes_only, single_module, single_seam_joiner]

show_panels = true;
show_frame_modules = true;
show_seam_joiners = true;
show_stiffening_tubes = true;
show_orientation = false;
show_panel_numbers = false;
show_in_out_labels = false;

/* [Exploded view] */
exploded_distance = 30; // [10:5:80]

/* [Single module view] */
single_module_row = "lower"; // [lower, upper]

include <config/project_config.scad>

use <components/frame_module.scad>
use <components/panel_seam_joiner.scad>
use <assemblies/display_assembly.scad>
use <assemblies/panels_assembly.scad>
use <assemblies/frame_modules_assembly.scad>
use <assemblies/panel_seam_joiners_assembly.scad>
use <assemblies/stiffening_tubes_assembly.scad>

if(view_mode == "exploded") {
    display_assembly(
        panels_visible=show_panels,
        frame_modules_visible=show_frame_modules,
        seam_joiners_visible=show_seam_joiners,
        stiffening_tubes_visible=show_stiffening_tubes,
        orientation_visible=show_orientation,
        panel_numbers_visible=show_panel_numbers,
        in_out_labels_visible=show_in_out_labels,
        explode_distance=exploded_distance
    );
} else if(view_mode == "panels_only") {
    panels_assembly(
        orientation_visible=show_orientation,
        panel_numbers_visible=show_panel_numbers,
        in_out_labels_visible=show_in_out_labels
    );
} else if(view_mode == "frame_modules_only") {
    frame_modules_assembly();
} else if(view_mode == "seam_joiners_only") {
    panel_seam_joiners_assembly();
} else if(view_mode == "stiffening_tubes_only") {
    stiffening_tubes_assembly();
} else if(view_mode == "single_module") {
    frame_module(
        row=single_module_row,
        left_edge="female",
        right_edge="male",
        bottom_edge="female",
        top_edge="male",
        tube_clip_edge=single_module_row == "upper" ? "top" : "bottom"
    );
} else if(view_mode == "single_seam_joiner") {
    panel_seam_joiner();
} else {
    display_assembly(
        panels_visible=show_panels,
        frame_modules_visible=show_frame_modules,
        seam_joiners_visible=show_seam_joiners,
        stiffening_tubes_visible=show_stiffening_tubes,
        orientation_visible=show_orientation,
        panel_numbers_visible=show_panel_numbers,
        in_out_labels_visible=show_in_out_labels
    );
}
