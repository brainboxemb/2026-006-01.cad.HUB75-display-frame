// HUB75 V1.2 - canonical panel fit geometry
//
// This is the single coordinate/fit adapter between hub75_panel.scad and all
// mating project geometry.  The physical panel remains authoritative in
// hub75_panel.scad; this file only expresses those dimensions in a consistent
// panel-centred coordinate system and derives seam/corner fit coordinates.
//
// Local axes used by the project:
//   X = panel width (portrait: nominal 160 mm)
//   Z = panel height (portrait: nominal 320 mm)
//   panel centre = (0,0)
//
// Keep these four boundaries distinct:
//   nominal placement cell -> exact assembly raster
//   front outer            -> physical front/body envelope
//   rear outer             -> physical rear envelope after taper
//   rear inner             -> opening edge / inner side of rear rail

use <../hub75_panel.scad>

// ---- Canonical half extents -------------------------------------------------
function hub75_fit_nominal_half_x() = hub75_panel_nominal_width()/2;
function hub75_fit_nominal_half_z() = hub75_panel_nominal_height()/2;
function hub75_fit_front_outer_half_x() = hub75_panel_width()/2;
function hub75_fit_front_outer_half_z() = hub75_panel_height()/2;
function hub75_fit_rear_outer_half_x() = hub75_panel_width()/2 - hub75_rear_outer_inset_x();
function hub75_fit_rear_outer_half_z() = hub75_panel_height()/2 - hub75_rear_outer_inset_z();

// The bay opening stays vertical while the outside wall tapers inward.  These
// are therefore also equal to rear_outer_half - rail_width_at_mounting_plane.
function hub75_fit_rear_inner_half_x() =
    hub75_panel_width()/2 - hub75_rear_side_rail_width();
function hub75_fit_rear_inner_half_z() =
    hub75_panel_height()/2 - hub75_rear_end_rail_width();

function hub75_fit_rear_side_rail_width() =
    hub75_fit_rear_outer_half_x() - hub75_fit_rear_inner_half_x();
function hub75_fit_rear_end_rail_width() =
    hub75_fit_rear_outer_half_z() - hub75_fit_rear_inner_half_z();

// ---- Gaps on the exact nominal raster --------------------------------------
function hub75_fit_front_seam_gap_x() =
    2*(hub75_fit_nominal_half_x() - hub75_fit_front_outer_half_x());
function hub75_fit_front_seam_gap_z() =
    2*(hub75_fit_nominal_half_z() - hub75_fit_front_outer_half_z());
function hub75_fit_rear_seam_gap_x() =
    2*(hub75_fit_nominal_half_x() - hub75_fit_rear_outer_half_x());
function hub75_fit_rear_seam_gap_z() =
    2*(hub75_fit_nominal_half_z() - hub75_fit_rear_outer_half_z());

// Internal vertical panel seam: two rear side rails facing each other.
function hub75_fit_internal_seam_keepout_width_x() =
    2*hub75_fit_rear_side_rail_width() + hub75_fit_rear_seam_gap_x();

// ---- Mounting-hole positions in component-local coordinate systems ---------
// Middle/horizontal-edge couplers bridge two panels side by side and use the
// nominal seam as local X=0.
function hub75_fit_seam_left_hole_x() =
    -hub75_panel_nominal_width()/2 + hub75_panel_hole_x_right_centered();
function hub75_fit_seam_right_hole_x() =
     hub75_panel_nominal_width()/2 + hub75_panel_hole_x_left_centered();

// Nominal top/bottom edge in a panel-centred reference drawing.
function hub75_fit_nominal_edge_z(direction="top") =
    (direction == "top" ? 1 : -1) * hub75_fit_nominal_half_z();

// Physical rear end-rail centre in panel-centred coordinates.
function hub75_fit_rear_end_rail_center_z(direction="top") =
    (direction == "top" ? 1 : -1)
    * (hub75_fit_rear_outer_half_z() - hub75_fit_rear_end_rail_width()/2);

// Horizontal-edge component is screw-row centred in Z.  Return the nominal
// edge and rear rail centre relative to that screw-row origin.
function hub75_fit_edge_screw_row_z(direction="top") =
    direction == "top"
        ? hub75_panel_hole_z_top_centered()
        : hub75_panel_hole_z_bottom_centered();
function hub75_fit_edge_nominal_reference_z(direction="top") =
    hub75_fit_nominal_edge_z(direction) - hub75_fit_edge_screw_row_z(direction);
function hub75_fit_edge_rear_end_rail_center_z(direction="top") =
    hub75_fit_rear_end_rail_center_z(direction) - hub75_fit_edge_screw_row_z(direction);
function hub75_fit_edge_rear_outer_edge_z(direction="top") =
    (direction == "top" ? 1 : -1) * hub75_fit_rear_outer_half_z()
    - hub75_fit_edge_screw_row_z(direction);

// Corner component uses its corner mounting screw as local (0,0).
function hub75_fit_corner_screw_x(side="left") =
    side == "left" ? hub75_panel_hole_x_left_centered() : hub75_panel_hole_x_right_centered();
function hub75_fit_corner_screw_z(direction="top") =
    direction == "top" ? hub75_panel_hole_z_top_centered() : hub75_panel_hole_z_bottom_centered();
function hub75_fit_corner_nominal_reference_x(side="left") =
    (side == "left" ? -hub75_fit_nominal_half_x() : hub75_fit_nominal_half_x())
    - hub75_fit_corner_screw_x(side);
function hub75_fit_corner_nominal_reference_z(direction="top") =
    hub75_fit_nominal_edge_z(direction) - hub75_fit_corner_screw_z(direction);
function hub75_fit_corner_side_rail_center_x(side="left") =
    (side == "left" ? -1 : 1)
    * (hub75_fit_rear_outer_half_x() - hub75_fit_rear_side_rail_width()/2)
    - hub75_fit_corner_screw_x(side);
function hub75_fit_corner_end_rail_center_z(direction="top") =
    hub75_fit_rear_end_rail_center_z(direction) - hub75_fit_corner_screw_z(direction);
function hub75_fit_corner_rear_outer_edge_x(side="left") =
    (side == "left" ? -1 : 1) * hub75_fit_rear_outer_half_x()
    - hub75_fit_corner_screw_x(side);
function hub75_fit_corner_rear_outer_edge_z(direction="top") =
    (direction == "top" ? 1 : -1) * hub75_fit_rear_outer_half_z()
    - hub75_fit_corner_screw_z(direction);

// Convenient public checks for references/tests.
function hub75_fit_rear_outer_width() = 2*hub75_fit_rear_outer_half_x();
function hub75_fit_rear_outer_height() = 2*hub75_fit_rear_outer_half_z();
