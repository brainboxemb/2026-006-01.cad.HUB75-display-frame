// HUB75 V1.1 display assembly
//
// The V1.1 structural concept starts with ten 160 x 160 mm printed modules
// mounted behind the five HUB75 panels. Separate seam joiners use the existing
// panel screw pairs to tie neighbouring panels and frame modules together.
// Continuous aluminium tubes snap into the outer top and bottom module rows.
// In side view each tube clamp sits beside a straight frame extension, leaving
// the tube useful as a later mounting interface for a visible border.

include <../config/project_config.scad>
use <panels_assembly.scad>
use <frame_modules_assembly.scad>
use <panel_seam_joiners_assembly.scad>
use <stiffening_tubes_assembly.scad>

module display_assembly(
    yshift=0,
    panels_visible=true,
    frame_modules_visible=true,
    seam_joiners_visible=true,
    stiffening_tubes_visible=true,
    orientation_visible=true,
    panel_numbers_visible=true,
    in_out_labels_visible=true,
    explode_distance=0
) {
    if(panels_visible)
        panels_assembly(
            yshift=yshift-explode_distance,
            orientation_visible=orientation_visible,
            panel_numbers_visible=panel_numbers_visible,
            in_out_labels_visible=in_out_labels_visible
        );

    if(frame_modules_visible)
        frame_modules_assembly(yshift=yshift);

    if(seam_joiners_visible)
        panel_seam_joiners_assembly(yshift=yshift+explode_distance);

    if(stiffening_tubes_visible)
        // Keep the tubes with the printed frame layer in exploded view.
        stiffening_tubes_assembly(yshift=yshift);
}

/* [Preview] */
show_panels = true;
show_frame_modules = true;
show_seam_joiners = true;
show_stiffening_tubes = true;
show_orientation = false;
show_panel_numbers = false;
show_in_out_labels = false;
preview_explode_distance = 0; // [0:5:80]

display_assembly(
    panels_visible=show_panels,
    frame_modules_visible=show_frame_modules,
    seam_joiners_visible=show_seam_joiners,
    stiffening_tubes_visible=show_stiffening_tubes,
    orientation_visible=show_orientation,
    panel_numbers_visible=show_panel_numbers,
    in_out_labels_visible=show_in_out_labels,
    explode_distance=preview_explode_distance
);
