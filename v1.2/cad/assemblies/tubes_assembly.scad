// HUB75 display frame - V1.2 aluminium tube assembly
//
// Tube material geometry belongs to aluminium_tube.scad. This assembly only
// sets project length and placement.

include <../config/project_config.scad>
use <../components/aluminium_tube.scad>

module project_aluminium_tube() {
    aluminium_stiffening_tube(
        length=stiffening_tube_length(),
        part_color=color_aluminium_tube
    );
}

module tubes_assembly(
    yshift=0,
    bottom_zshift=0,
    top_zshift=0,
    exploded=false
) {
    explode = exploded ? exploded_tube_offset : 0;

    translate([
        stiffening_tube_x(),
        stiffening_tube_y() + yshift,
        stiffening_tube_bottom_z() - explode + bottom_zshift
    ]) project_aluminium_tube();

    translate([
        stiffening_tube_x(),
        stiffening_tube_y() + yshift,
        stiffening_tube_top_z() + explode + top_zshift
    ]) project_aluminium_tube();
}
