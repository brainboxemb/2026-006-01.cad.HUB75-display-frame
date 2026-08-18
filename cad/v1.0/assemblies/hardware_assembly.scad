// HUB75 frame-mounted hardware assembly
include <../config/project_config.scad>
use <../components/din_rail.scad>
use <../components/seam_bracket.scad>
use <../components/din_rail_cable_clip.scad>
use <../components/ribbon_cable.scad>
use <../components/corner_bracket.scad>
use <bracket_bolts_assembly.scad>

module hardware_assembly(
    yshift=0,
    brackets_visible=true,
    din_rail_visible=true,
    cable_clips_visible=true,
    ribbon_cables_visible=true,
    bolts_visible=true
) {
    // DIN rail, ribbon cable and brackets at each panel seam.
    for(i=[0:panel_count-2]) {
        x = seam_center(i);
        if(din_rail_visible) {
            translate([x,din_back_y+yshift,din_z_start]) din_rail_3d();
        }
        if(brackets_visible) {
            translate([x,panel_back_y+yshift,hole_z_bottom]) seam_bracket_3d(false);
            translate([x,panel_back_y+yshift,hole_z_top]) seam_bracket_3d(true);
        }
    }

    // Explicit data chain as viewed from the rear:
    // rear view: panel 1 left -> panel 2 right via BOTTOM,
    // panel 2 -> 3 via TOP, then alternating.
    if(ribbon_cables_visible) {
        for(k=[1:panel_count-1]) {
            // Model X is mirrored in the rear view:
            // chain panel 1 is therefore at the highest X index.
            first_index = panel_count - k;
            next_index = panel_count - (k+1);

            cable_z_local = (k % 2 == 1)
                ? data_connector_z_bottom
                : data_connector_z_top;
            cable_z = panel_z_offset + cable_z_local;

            x1 = px(first_index) + panel_width/2;
            x2 = px(next_index) + panel_width/2;

            ribbon_cable_horizontal(x1,x2,cable_z);
            ribbon_cable_connector_end(x1,cable_z);
            ribbon_cable_connector_end(x2,cable_z);

            if(cable_clips_visible)
                translate([seam_center(next_index),din_back_y+yshift,cable_z])
                    din_rail_cable_clip_x();
        }
    }

    // Four outer corners.
    if(brackets_visible) {
        translate([hole_x(0,false),panel_back_y+yshift,hole_z_bottom]) corner_bracket_3d(false,false);
        translate([hole_x(0,false),panel_back_y+yshift,hole_z_top]) corner_bracket_3d(true,false);
        translate([hole_x(panel_count-1,true),panel_back_y+yshift,hole_z_bottom]) corner_bracket_3d(false,true);
        translate([hole_x(panel_count-1,true),panel_back_y+yshift,hole_z_top]) corner_bracket_3d(true,true);
    }

    if(bolts_visible)
        bracket_bolts_assembly(yshift);
}

// Standalone preview settings.
/* [Preview] */
show_brackets = true;
show_din_rail = true;
show_cable_clips = true;
show_ribbon_cables = true;
show_bolts = true;

hardware_assembly(
    brackets_visible=show_brackets,
    din_rail_visible=show_din_rail,
    cable_clips_visible=show_cable_clips,
    ribbon_cables_visible=show_ribbon_cables,
    bolts_visible=show_bolts
);
