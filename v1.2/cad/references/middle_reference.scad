// HUB75 V1.2 - MIDDLE bridge reference
// Two portrait panels side by side. Coupler local (0,0) is the midpoint of
// their nominal vertical seam.
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
show_panel_origins = true;
show_legend = true;

pitch_x = ref_panel_nominal_width();
left_center  = [-pitch_x/2, 0];
right_center = [ pitch_x/2, 0];
view_w = 370;
view_h = 370;

if(show_grid)
    color([0.75,0.80,0.88,0.35])
        hub75_reference_grid_2d(view_w, view_h, grid_major, grid_show_half);

for(c=[left_center,right_center]) {
    if(show_nominal) color([0.10,0.45,1.00,1]) hub75_nominal_cell_2d(c);
    if(show_front_outer) color([0.10,0.75,0.20,1]) hub75_physical_front_outline_2d(c);
    if(show_rear_outer) color([0.95,0.25,0.10,1]) hub75_rear_outer_outline_2d(c);
    if(show_rear_inner) color([0.80,0.10,0.75,1]) hub75_rear_inner_edge_lines_2d(c);
    if(show_mounting_holes) color("black") hub75_mounting_holes_2d(c);
    if(show_panel_origins) color("black") hub75_panel_origin_2d(c, false);
}

color("black") {
    ref_vline(0, -175, 175, 0.85);
    ref_cross([0,0], 8, 0.85);
    ref_label("MIDDLE (0,0)", [4,8], 4.0, "left", "bottom");
    ref_label("panel L (-80,0)", [-80,-168], 3.0, "center", "top");
    ref_label("panel R (+80,0)", [80,-168], 3.0, "center", "top");
    ref_label(str("front seam gap ", ref_panel_grid_gap_x(), " mm"), [4,24], 3.0, "left");
    ref_label(str("rear seam gap ", ref_panel_rear_grid_gap_x(), " mm"), [4,18], 3.0, "left");
}
if(show_legend) hub75_reference_legend_2d([-175,180]);
