// HUB75 display frame - V1.2 aluminium tube assembly
//
// aluminium_tube.scad is self-contained.
// Project dimensions are passed explicitly here.

include <../config/project_config.scad>
use <../components/aluminium_tube.scad>


module project_aluminium_tube() {
    aluminium_stiffening_tube(
        length=stiffening_tube_length,
        outer_diameter=
            stiffening_tube_outer_diameter,
        wall_thickness=
            stiffening_tube_wall_thickness,
        part_color=
            color_aluminium_tube
    );
}


module tubes_assembly(
    yshift=0,
    bottom_zshift=0,
    top_zshift=0,
    exploded=false
) {
    explode =
        exploded
            ? exploded_tube_offset
            : 0;

    translate([
        0,
        stiffening_tube_y() + yshift,
        stiffening_tube_bottom_z()
            - explode
            + bottom_zshift
    ])
        project_aluminium_tube();

    translate([
        0,
        stiffening_tube_y() + yshift,
        stiffening_tube_top_z()
            + explode
            + top_zshift
    ])
        project_aluminium_tube();
}
