// HUB75 display frame - V1.1 panel-seam joiner assembly
//
// One joiner is fitted at each of the three existing HUB75 mounting rows on
// every vertical seam between neighbouring panels: 4 seams x 3 rows = 12 parts.

include <../config/project_config.scad>
use <../components/panel_seam_joiner.scad>

module panel_seam_joiners_assembly(yshift=0, show_pins=true) {
    for(seam_index=[1:panel_count-1])
        for(z=panel_hole_z) {
            pin_z_offset = abs(z-panel_hole_z[1]) < 0.01
                ? seam_joiner_middle_pin_z_offset
                : seam_joiner_pin_z_offset;

            translate([
                seam_index * panel_pitch,
                seam_joiner_y + yshift,
                z
            ])
                panel_seam_joiner(
                    show_pins=show_pins,
                    pin_z_offset=pin_z_offset
                );
        }
}

/* [Preview] */
preview_show_pins = true;
panel_seam_joiners_assembly(show_pins=preview_show_pins);
