// HUB75 V1.2 - standalone canonical panel coordinate reference
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
show_origin = true;
show_legend = true;

view_w = 210;
view_h = 370;

if (show_grid)
    color([0.75,0.80,0.88,0.35])
        hub75_reference_grid_2d(view_w, view_h, grid_major, grid_show_half);

if (show_nominal) color([0.10,0.45,1.00,1]) hub75_nominal_cell_2d();
if (show_front_outer) color([0.10,0.75,0.20,1]) hub75_physical_front_outline_2d();
if (show_rear_outer) color([0.95,0.25,0.10,1]) hub75_rear_outer_outline_2d();
if (show_rear_inner) color([0.80,0.10,0.75,1]) hub75_rear_inner_edge_lines_2d();
if (show_mounting_holes) color("black") hub75_mounting_holes_2d();
if (show_origin) color("black") hub75_panel_origin_2d();

if (show_legend)
    hub75_reference_legend_2d([-96, 180]);

color("black") {
    ref_label("PANEL REFERENCE", [0, 174], 4.0, "center", "top");
    ref_label(str("nominal: ", ref_panel_nominal_width(), " x ", ref_panel_nominal_height()), [0,-170], 3.0);
    ref_label(str("front: ", ref_panel_front_width(), " x ", ref_panel_front_height()), [0,-175], 3.0);
    ref_label(str("rear: ", ref_panel_rear_width(), " x ", ref_panel_rear_height()), [0,-180], 3.0);
}
