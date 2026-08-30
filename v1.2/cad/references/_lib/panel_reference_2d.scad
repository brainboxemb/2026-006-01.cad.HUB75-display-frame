// HUB75 V1.2 - canonical 2D panel reference geometry
//
// The panel itself is always centred at local (0,0). Reference drawings for
// middle/edge/corner couplers ONLY translate this canonical geometry into the
// component-local coordinate system. They must never recalculate panel edges.
//
// 2D axis mapping:
//   OpenSCAD X -> project/panel X
//   OpenSCAD Y -> project/panel Z
//
// Four reference boundaries are intentionally kept separate:
//   1. exact nominal placement cell (160 x 320 portrait / 320 x 160 landscape)
//   2. actual physical front/body outside edge
//   3. actual rear-plane outside edge after the housing taper
//   4. actual rear-frame INNER edge (start of the electronics opening)
//
// The fourth line is essential for coupler fitting: it defines the real width
// of the rear side/end rail together with the rear outer edge.

use <../../components/hub75_panel.scad>
use <../../components/_lib/panel_fit_geometry.scad>
use <../../components/_lib/reference_grid.scad>

ref_line_width = 0.45;
ref_major_line_width = 0.70;
ref_inner_line_width = 0.55;
ref_text_size = 4.0;
ref_small_text_size = 3.0;
ref_cross_size = 5.0;

module ref_rect_outline(size=[10,10], width=ref_line_width) {
    difference() {
        square(size, center=true);
        square([max(0.01,size[0]-2*width), max(0.01,size[1]-2*width)], center=true);
    }
}

module ref_hline(x1, x2, y, width=ref_line_width) {
    translate([(x1+x2)/2, y]) square([abs(x2-x1), width], center=true);
}

module ref_vline(x, y1, y2, width=ref_line_width) {
    translate([x, (y1+y2)/2]) square([width, abs(y2-y1)], center=true);
}

module ref_cross(point=[0,0], size=ref_cross_size, width=ref_major_line_width) {
    translate(point) {
        square([size, width], center=true);
        square([width, size], center=true);
    }
}

module ref_label(value, at=[0,0], size=ref_text_size, halign="center", valign="center", rot=0) {
    translate(at)
        rotate(rot)
            text(value, size=size, halign=halign, valign=valign, font="Liberation Sans");
}

module ref_hole(center=[0,0], diameter=3.0, ring=0.55) {
    translate(center)
        difference() {
            circle(d=diameter + 2*ring, $fn=36);
            circle(d=diameter, $fn=36);
        }
}

// ---- Canonical coordinates -------------------------------------------------
function ref_panel_nominal_width() = 2*hub75_fit_nominal_half_x();
function ref_panel_nominal_height() = 2*hub75_fit_nominal_half_z();
function ref_panel_front_width() = 2*hub75_fit_front_outer_half_x();
function ref_panel_front_height() = 2*hub75_fit_front_outer_half_z();
function ref_panel_rear_width() = 2*hub75_fit_rear_outer_half_x();
function ref_panel_rear_height() = 2*hub75_fit_rear_outer_half_z();

// Inner edges of the OUTER rear frame, expressed around panel local (0,0).
// The bay openings remain vertical while the outer housing tapers inward, so
// these opening coordinates are referenced to the physical front/body size.
function ref_panel_rear_inner_x() = hub75_fit_rear_inner_half_x();
function ref_panel_rear_inner_z() = hub75_fit_rear_inner_half_z();

function ref_panel_grid_gap_x() = hub75_fit_front_seam_gap_x();
function ref_panel_grid_gap_z() = hub75_fit_front_seam_gap_z();
function ref_panel_rear_grid_gap_x() = hub75_fit_rear_seam_gap_x();
function ref_panel_rear_grid_gap_z() = hub75_fit_rear_seam_gap_z();
function ref_panel_rear_side_rail_width_at_mounting_plane() = hub75_fit_rear_side_rail_width();
function ref_panel_rear_end_rail_width_at_mounting_plane() = hub75_fit_rear_end_rail_width();

// ---- Four panel boundary layers -------------------------------------------
module hub75_nominal_cell_2d(center=[0,0], line_width=ref_major_line_width) {
    translate(center)
        ref_rect_outline([ref_panel_nominal_width(), ref_panel_nominal_height()], line_width);
}

module hub75_physical_front_outline_2d(center=[0,0], line_width=ref_line_width) {
    translate(center)
        ref_rect_outline([ref_panel_front_width(), ref_panel_front_height()], line_width);
}

// Backward-compatible name used by V118/V119 drawings.
module hub75_physical_body_outline_2d(center=[0,0], line_width=ref_line_width)
    hub75_physical_front_outline_2d(center, line_width);

module hub75_rear_outer_outline_2d(center=[0,0], line_width=ref_line_width) {
    translate(center)
        ref_rect_outline([ref_panel_rear_width(), ref_panel_rear_height()], line_width);
}

// Backward-compatible alias.
module hub75_rear_mounting_outline_2d(center=[0,0], line_width=ref_line_width)
    hub75_rear_outer_outline_2d(center, line_width);

// The critical INNER boundaries of the outside rear rail. This is deliberately
// represented as four lines rather than a fictitious rectangular opening: the
// real panel has four bays and three middle ribs. For coupler fitting at an
// outside side/end rail these four coordinates are the mechanically relevant
// reference lines.
module hub75_rear_inner_edge_lines_2d(center=[0,0], line_width=ref_inner_line_width) {
    ix = ref_panel_rear_inner_x();
    iz = ref_panel_rear_inner_z();
    span_x = ref_panel_front_width()/2;
    span_z = ref_panel_front_height()/2;

    translate(center) {
        ref_vline(-ix, -iz,  iz, line_width);
        ref_vline( ix, -iz,  iz, line_width);
        ref_hline(-ix, ix, -iz, line_width);
        ref_hline(-ix, ix,  iz, line_width);
    }
}

module hub75_mounting_holes_2d(center=[0,0]) {
    xs = [hub75_panel_hole_x_left_centered(), hub75_panel_hole_x_right_centered()];
    zs = [
        hub75_panel_hole_z_bottom_centered(),
        hub75_panel_hole_z_middle_centered(),
        hub75_panel_hole_z_top_centered()
    ];
    for (x=xs)
        for (z=zs)
            ref_hole([center[0]+x, center[1]+z], hub75_panel_hole_diameter());
}

module hub75_panel_origin_2d(center=[0,0], label=true) {
    ref_cross(center);
    if (label)
        ref_label("panel (0,0)", [center[0]+4, center[1]+4], ref_small_text_size, "left", "bottom");
}

// Reusable standalone grid wrapper. The implementation is shared with the
// top-level 3D reference grid (components/_lib/reference_grid.scad).
module hub75_reference_grid_2d(width, height, major=10, show_half=true) {
    reference_grid_2d(width=width, height=height, major=major, show_half=show_half);
}

// Preview layer composition. Colours are only for OpenSCAD/PNG preview; DXF
// remains geometry-only, but every contour has a distinct line thickness.
module hub75_panel_reference_layers_2d(center=[0,0], show_origin=false) {
    color([0.10,0.45,1.00,1]) hub75_nominal_cell_2d(center);
    color([0.10,0.75,0.20,1]) hub75_physical_front_outline_2d(center);
    color([0.95,0.25,0.10,1]) hub75_rear_outer_outline_2d(center);
    color([0.80,0.10,0.75,1]) hub75_rear_inner_edge_lines_2d(center);
    color("black") hub75_mounting_holes_2d(center);
    if(show_origin)
        color("black") hub75_panel_origin_2d(center);
}

module hub75_panel_reference_2d(center=[0,0], show_origin=true) {
    hub75_nominal_cell_2d(center);
    hub75_physical_front_outline_2d(center);
    hub75_rear_outer_outline_2d(center);
    hub75_rear_inner_edge_lines_2d(center);
    hub75_mounting_holes_2d(center);
    if (show_origin)
        hub75_panel_origin_2d(center);
}

module hub75_reference_axes_2d(extent_x=200, extent_z=360, label=true) {
    ref_hline(-extent_x/2, extent_x/2, 0, ref_line_width);
    ref_vline(0, -extent_z/2, extent_z/2, ref_line_width);
    ref_cross([0,0], ref_cross_size*1.4, ref_major_line_width);
    if (label) {
        ref_label("X=0", [3, extent_z/2-6], ref_small_text_size, "left", "top");
        ref_label("Z=0", [extent_x/2-3, 3], ref_small_text_size, "right", "bottom");
    }
}

module hub75_reference_legend_2d(at=[0,0]) {
    x = at[0]; y = at[1];
    color([0.10,0.45,1.00,1]) { ref_hline(x, x+12, y, 0.70); ref_label("nominal grid", [x+15,y], 2.8, "left", "center"); }
    color([0.10,0.75,0.20,1]) { ref_hline(x, x+12, y-5, 0.45); ref_label("physical front outer", [x+15,y-5], 2.8, "left", "center"); }
    color([0.95,0.25,0.10,1]) { ref_hline(x, x+12, y-10, 0.45); ref_label("rear outer", [x+15,y-10], 2.8, "left", "center"); }
    color([0.80,0.10,0.75,1]) { ref_hline(x, x+12, y-15, 0.55); ref_label("rear inner edge", [x+15,y-15], 2.8, "left", "center"); }
}
