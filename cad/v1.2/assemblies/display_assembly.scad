// HUB75 V1.2 display assembly
//
// V1.2 keeps the V1.1 panel geometry, orientation and aluminium tube locations.
// The 160 x 160 mm printed modules are removed. Direct printed couplers now tie
// the panel screw rows to each other and to the two continuous tubes.

include <../config/project_config.scad>
use <panels_assembly.scad>
use <couplers_assembly.scad>
use <tubes_assembly.scad>

module display_assembly(
    yshift=0,
    panels_visible=true,
    couplers_visible=true,
    stiffening_tubes_visible=true,
    orientation_visible=true,
    panel_numbers_visible=true,
    in_out_labels_visible=true,
    explode_distance=0
) {
    exploded = explode_distance > 0;
    layer_distance = explode_distance;
    tube_gap = explode_distance * 0.55;

    if(panels_visible)
        panels_assembly(
            yshift=yshift-(exploded ? layer_distance : 0),
            orientation_visible=orientation_visible,
            panel_numbers_visible=panel_numbers_visible,
            in_out_labels_visible=in_out_labels_visible
        );

    if(couplers_visible)
        couplers_assembly(
            yshift=yshift+(exploded ? layer_distance : 0)
        );

    if(stiffening_tubes_visible)
        tubes_assembly(
            yshift=yshift,
            bottom_zshift=exploded ? -tube_gap : 0,
            top_zshift=exploded ? tube_gap : 0
        );
}

/* [Preview] */
show_panels = true;
show_couplers = true;
show_stiffening_tubes = true;
show_orientation = false;
show_panel_numbers = false;
show_in_out_labels = false;
preview_explode_distance = 0; // [0:5:80]

display_assembly(
    panels_visible=show_panels,
    couplers_visible=show_couplers,
    stiffening_tubes_visible=show_stiffening_tubes,
    orientation_visible=show_orientation,
    panel_numbers_visible=show_panel_numbers,
    in_out_labels_visible=show_in_out_labels,
    explode_distance=preview_explode_distance
);
