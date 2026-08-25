// HUB75 frame-system assembly
// Mechanical focus: aluminium frame, HUB75 panels and frame-mounted hardware.
include <../config/project_config.scad>
use <frame_assembly.scad>
use <panels_assembly.scad>
use <hardware_assembly.scad>
use <esp32_assembly.scad>
use <power_supply_assembly.scad>

module frame_system_assembly(
    yshift=0,
    brackets_visible=true,
    din_rail_visible=true,
    cable_clips_visible=true,
    ribbon_cables_visible=true,
    orientation_visible=true,
    panel_numbers_visible=true,
    in_out_labels_visible=true,
    bolts_visible=true,
    esp32_visible=false,
    power_supply_visible=false
) {
    frame_assembly(yshift);

    panels_assembly(
        yshift=yshift,
        orientation_visible=orientation_visible,
        panel_numbers_visible=panel_numbers_visible,
        in_out_labels_visible=in_out_labels_visible
    );

    hardware_assembly(
        yshift=yshift,
        brackets_visible=brackets_visible,
        din_rail_visible=din_rail_visible,
        cable_clips_visible=cable_clips_visible,
        ribbon_cables_visible=ribbon_cables_visible,
        bolts_visible=bolts_visible
    );

    if(esp32_visible)
        esp32_assembly(yshift=yshift, bolts_visible=bolts_visible);

    if(power_supply_visible)
        power_supply_assembly(yshift=yshift, bolts_visible=bolts_visible);
}

// Standalone preview settings.
/* [Preview] */
show_brackets = true;
show_din_rail = true;
show_cable_clips = true;
show_ribbon_cables = true;
show_orientation = true;
show_panel_numbers = true;
show_in_out_labels = true;
show_bolts = true;
show_esp32 = false;
show_power_supply = false;

frame_system_assembly(
    brackets_visible=show_brackets,
    din_rail_visible=show_din_rail,
    cable_clips_visible=show_cable_clips,
    ribbon_cables_visible=show_ribbon_cables,
    orientation_visible=show_orientation,
    panel_numbers_visible=show_panel_numbers,
    in_out_labels_visible=show_in_out_labels,
    bolts_visible=show_bolts,
    esp32_visible=show_esp32,
    power_supply_visible=show_power_supply
);
