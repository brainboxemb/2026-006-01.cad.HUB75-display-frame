// HUB75 display frame - V1.1 aluminium stiffening-tube assembly
//
// Two continuous 800 mm tubes run above and below the HUB75 panel edges.
// The frame plates extend straight past the panel edge and the clamps sit
// beside those extensions. Exposed tube sections can later provide a mounting
// interface for border parts from the opposite side.

include <../config/project_config.scad>
use <../components/aluminium_stiffening_tube.scad>

module stiffening_tubes_assembly(yshift=0) {
    for(z=[stiffening_tube_bottom_z(), stiffening_tube_top_z()])
        translate([0, stiffening_tube_y()+yshift, z])
            aluminium_stiffening_tube();
}

/* [Preview] */
stiffening_tubes_assembly();
