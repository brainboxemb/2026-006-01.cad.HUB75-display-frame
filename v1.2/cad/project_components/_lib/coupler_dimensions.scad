// Shared project-derived dimensions for the V1.2 coupler family.
//
// These values deliberately live under project_components/_lib because they
// combine reusable component dimensions (HUB75 panel geometry) with the shared
// coupler-family design rules.  Edge and corner couplers must use these same
// functions so wall thickness and plate proportions cannot drift apart.

use <../../components/hub75_panel.scad>
include <../../config/project_config.scad>
use <coupler_profile.scad>

function coupler_project_side_material() =
    project_coupler_wall_thickness() + coupler_fit_clearance_default();

function coupler_project_panel_seam_gap() = max(0, hub75_panel_grid_gap_x());

// A positive blade between adjacent panel bodies is only legal when it fits
// inside the REAL free gap after clearance on both faces.  With the current
// panel (159.70 mm in a 160.00 mm cell) and 0.25 mm/side print clearance this
// correctly evaluates to zero: alignment is provided by the rear-rail guides
// and screw pattern, not by an impossible 3 mm seam wedge.
function coupler_project_seam_locator_width(clearance=coupler_fit_clearance_default()) =
    max(0, coupler_project_panel_seam_gap() - 2*clearance);

// Both edge and corner parts sit around the same physical top/bottom rear rail.
function coupler_project_horizontal_arm_height() =
    hub75_rear_end_rail_width() + 2*coupler_project_side_material();

// At an internal seam, two side rails face each other with the nominal panel
// pitch gap between them.  Only the two *outer* sides receive printed wall
// material; there is no fictitious wall inserted between the panels.
function coupler_project_edge_vertical_arm_width() =
    2*hub75_rear_side_rail_width()
    + coupler_project_panel_seam_gap()
    + 2*coupler_project_side_material();

// At an outside corner there is only one panel side rail.
function coupler_project_corner_vertical_arm_width() =
    hub75_rear_side_rail_width() + 2*coupler_project_side_material();

// Matching physical keep-out width at an internal seam.
function coupler_project_edge_seam_keepout_width() =
    2*hub75_rear_side_rail_width() + coupler_project_panel_seam_gap();
