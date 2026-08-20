// HUB75 V1.0 documentation/display assembly
//
// Normal geometry is identical to the original frame_system_assembly.
// The exploded view separates the three main construction layers:
// aluminium frame, HUB75 panels and rear frame-mounted hardware.

include <../config/project_config.scad>
use <frame_assembly.scad>
use <panels_assembly.scad>
use <hardware_assembly.scad>
use <esp32_assembly.scad>
use <power_supply_assembly.scad>

module display_assembly(
    yshift=0,
    brackets_visible=true,
    din_rail_visible=true,
    cable_clips_visible=true,
    ribbon_cables_visible=true,
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false,
    bolts_visible=true,
    esp32_visible=false,
    power_supply_visible=false,
    explode_distance=0
) {
    exploded = explode_distance > 0;
    layer_distance = explode_distance;

    // Structural aluminium frame remains the reference layer.
    frame_assembly(yshift=yshift);

    // Front layer: HUB75 panels.
    panels_assembly(
        yshift=yshift-(exploded ? layer_distance : 0),
        orientation_visible=orientation_visible,
        panel_numbers_visible=panel_numbers_visible,
        in_out_labels_visible=in_out_labels_visible
    );

    // Rear layer: brackets, DIN rails, cable clips, ribbon cables and bolts.
    hardware_assembly(
        yshift=yshift+(exploded ? layer_distance : 0),
        brackets_visible=brackets_visible,
        din_rail_visible=din_rail_visible,
        cable_clips_visible=cable_clips_visible,
        ribbon_cables_visible=ribbon_cables_visible,
        bolts_visible=bolts_visible
    );

    // Optional assemblies, when enabled, move behind the main hardware layer.
    if(esp32_visible)
        esp32_assembly(
            yshift=yshift+(exploded ? layer_distance*1.65 : 0),
            bolts_visible=bolts_visible
        );

    if(power_supply_visible)
        power_supply_assembly(
            yshift=yshift+(exploded ? layer_distance*1.65 : 0),
            bolts_visible=bolts_visible
        );
}

/* [Preview] */
preview_explode_distance = 0; // [0:5:100]

display_assembly(explode_distance=preview_explode_distance);
