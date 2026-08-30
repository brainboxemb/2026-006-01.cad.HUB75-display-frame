// HUB75 V1.2 - TOP RIGHT corner reference
// Coupler local (0,0) is the nominal top-right panel corner. The panel itself
// remains canonical and centred at (-80,-160) in this component-local view.
use <_lib/panel_reference_2d.scad>

/* [Reference grid] */
show_grid = true;
grid_major = 10;
grid_show_half = true;

/* [Layers] */
show_nominal = true;
show_front_outer = true;
show_rear_outer = true;
show_rear_inner = true;
show_mounting_holes = true;
show_panel_origin = true;
show_legend = true;

panel_center = [-ref_panel_nominal_width()/2, -ref_panel_nominal_height()/2];
view_w = 210;
view_h = 370;

if(show_grid)
    color([0.75,0.80,0.88,0.35])
        hub75_reference_grid_2d(view_w, view_h, grid_major, grid_show_half);

if(show_nominal) color([0.10,0.45,1.00,1]) hub75_nominal_cell_2d(panel_center);
if(show_front_outer) color([0.10,0.75,0.20,1]) hub75_physical_front_outline_2d(panel_center);
if(show_rear_outer) color([0.95,0.25,0.10,1]) hub75_rear_outer_outline_2d(panel_center);
if(show_rear_inner) color([0.80,0.10,0.75,1]) hub75_rear_inner_edge_lines_2d(panel_center);
if(show_mounting_holes) color("black") hub75_mounting_holes_2d(panel_center);
if(show_panel_origin) color("black") hub75_panel_origin_2d(panel_center, false);

color("black") {
    ref_vline(0,-330,10,0.85);
    ref_hline(-170,10,0,0.85);
    ref_cross([0,0],8,0.85);
    ref_label("CORNER RIGHT / TOP (0,0)", [-4,8], 4.0, "right", "bottom");
    ref_label("panel center (-80,-160)", [-80,-328], 3.0, "center", "top");
}
if(show_legend) hub75_reference_legend_2d([-95,15]);
