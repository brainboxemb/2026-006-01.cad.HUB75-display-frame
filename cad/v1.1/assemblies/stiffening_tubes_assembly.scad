// HUB75 display frame - V1.1 aluminium stiffening-tube assembly
//
// Two continuous 800 mm tubes run above and below the HUB75 panel edges.
// The frame plates extend straight past the panel edge and the clamps sit
// beside those extensions. Exposed tube sections can later provide a mounting
// interface for border parts from the opposite side.

include <../config/project_config.scad>
use <../components/aluminium_stiffening_tube.scad>

module stiffening_tubes_assembly(
    yshift=0,
    bottom_zshift=0,
    top_zshift=0
) {
    translate([0, stiffening_tube_y()+yshift, stiffening_tube_bottom_z()+bottom_zshift])
        aluminium_stiffening_tube();

    translate([0, stiffening_tube_y()+yshift, stiffening_tube_top_z()+top_zshift])
        aluminium_stiffening_tube();
}

/* [Preview] */
preview_bottom_zshift = 0; // [-40:2:0]
preview_top_zshift = 0;    // [0:2:40]
stiffening_tubes_assembly(
    bottom_zshift=preview_bottom_zshift,
    top_zshift=preview_top_zshift
);
