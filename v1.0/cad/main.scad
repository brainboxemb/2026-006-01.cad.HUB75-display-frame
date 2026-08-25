// HUB75 display frame - modular main entry point
// Focus: aluminium frame and frame-mounted HUB75 hardware.

/* [View] */
view_mode = "frame_system"; // [frame_system, exploded, render_front, render_rear, render_exploded, frame_only, panels_only, hardware_only, din_rail_only, cable_clips_only, esp32_only, power_supply_only, hole_check, print_seam_bracket_bottom, print_seam_bracket_top, print_corner_bracket, print_cable_clip, print_esp32_mount, print_esp32_clamp_cap, print_power_supply_din_clip, print_power_supply_top_bracket, print_power_supply_bottom_bracket]

show_brackets = true;
show_din_rail = true;
show_cable_clips = true;
show_ribbon_cables = true;
show_orientation = true;
show_panel_numbers = true;
show_in_out_labels = true;
show_bolts = true;

// Optional while working on the mechanical frame.
show_esp32 = false;
show_power_supply = false;

/* [Exploded view] */
exploded_distance = 45; // [10:5:100]


include <config/project_config.scad>

use <assemblies/display_assembly.scad>
use <assemblies/frame_assembly.scad>
use <assemblies/panels_assembly.scad>
use <assemblies/bracket_bolts_assembly.scad>
use <assemblies/hardware_assembly.scad>
use <assemblies/esp32_assembly.scad>
use <assemblies/power_supply_assembly.scad>
use <assemblies/frame_system_assembly.scad>

use <components/din_rail_cable_clip.scad>
use <components/seam_bracket.scad>
use <components/corner_bracket.scad>
use <components/matrixportal_mount.scad>
use <components/matrixportal_clamp_cap.scad>
use <components/din_rail.scad>
use <components/power_supply_din_rail_clip.scad>
use <components/power_supply_top_bracket.scad>
use <components/power_supply_bottom_bracket.scad>

if(view_mode=="print_cable_clip") {
    rotate([90,0,0]) din_rail_cable_clip_x();
} else if(view_mode=="print_seam_bracket_bottom") {
    rotate([-90,0,0]) seam_bracket_3d(false);
} else if(view_mode=="print_seam_bracket_top") {
    rotate([-90,0,0]) seam_bracket_3d(true);
} else if(view_mode=="print_corner_bracket") {
    rotate([-90,0,0]) corner_bracket_3d(false,false);
} else if(view_mode=="print_esp32_mount") {
    rotate([-90,0,0]) matrixportal_simple_mount();
} else if(view_mode=="print_esp32_clamp_cap") {
    rotate([-90,0,0]) matrixportal_clamp_cap();
} else if(view_mode=="print_power_supply_din_clip") {
    power_supply_din_rail_clip();
} else if(view_mode=="print_power_supply_top_bracket") {
    power_supply_top_bracket();
} else if(view_mode=="print_power_supply_bottom_bracket") {
    power_supply_bottom_bracket();
} else if(view_mode=="exploded" || view_mode=="render_exploded") {
    display_assembly(
        brackets_visible=show_brackets,
        din_rail_visible=show_din_rail,
        cable_clips_visible=show_cable_clips,
        ribbon_cables_visible=show_ribbon_cables,
        orientation_visible=show_orientation,
        panel_numbers_visible=show_panel_numbers,
        in_out_labels_visible=show_in_out_labels,
        bolts_visible=show_bolts,
        esp32_visible=show_esp32,
        power_supply_visible=show_power_supply,
        explode_distance=exploded_distance
    );
} else if(view_mode=="render_front" || view_mode=="render_rear") {
    display_assembly(
        brackets_visible=true,
        din_rail_visible=true,
        cable_clips_visible=true,
        ribbon_cables_visible=true,
        orientation_visible=false,
        panel_numbers_visible=false,
        in_out_labels_visible=false,
        bolts_visible=true,
        esp32_visible=false,
        power_supply_visible=false
    );
} else if(view_mode=="frame_only") {
    frame_assembly();
} else if(view_mode=="panels_only") {
    panels_assembly(
        orientation_visible=show_orientation,
        panel_numbers_visible=show_panel_numbers,
        in_out_labels_visible=show_in_out_labels
    );
} else if(view_mode=="hardware_only") {
    hardware_assembly(
        brackets_visible=show_brackets,
        din_rail_visible=show_din_rail,
        cable_clips_visible=show_cable_clips,
        ribbon_cables_visible=show_ribbon_cables,
        bolts_visible=show_bolts
    );
} else if(view_mode=="din_rail_only") {
    for(i=[0:panel_count-2])
        translate([seam_center(i),din_back_y,din_z_start])
            din_rail_3d();
} else if(view_mode=="cable_clips_only") {
    for(i=[0:panel_count-2])
        for(frac=cable_clip_positions)
            translate([
                seam_center(i),
                din_back_y,
                din_z_start+frac*din_length-cable_clip_length/2
            ])
                din_rail_cable_clip_x();
} else if(view_mode=="esp32_only") {
    esp32_assembly(bolts_visible=show_bolts);
} else if(view_mode=="power_supply_only") {
    power_supply_assembly(bolts_visible=show_bolts);
} else if(view_mode=="hole_check") {
    %panels_assembly(
        orientation_visible=show_orientation,
        panel_numbers_visible=show_panel_numbers,
        in_out_labels_visible=show_in_out_labels
    );
    hardware_assembly(
        brackets_visible=show_brackets,
        din_rail_visible=show_din_rail,
        cable_clips_visible=show_cable_clips,
        ribbon_cables_visible=show_ribbon_cables,
        bolts_visible=show_bolts
    );

    // Yellow axes = CAD panel holes.
    for(i=[0:panel_count-1])
        for(x=[hole_x(i,false),hole_x(i,true)])
            for(z=[hole_z_bottom,hole_z_middle,hole_z_top])
                color([1,0.85,0,1])
                    translate([x,panel_front_y-2,z])
                        rotate([-90,0,0])
                            cylinder(h=panel_thickness+12,d=0.8,$fn=16);
} else {
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
}
