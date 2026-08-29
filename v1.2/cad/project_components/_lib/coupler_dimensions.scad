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

function coupler_project_front_seam_gap() = max(0, hub75_panel_grid_gap_x());
function coupler_project_rear_seam_gap() = max(0, hub75_panel_rear_grid_gap_x());

// The locator engages the gap at the REAR mounting plane, not the front/body
// envelope.  The rear housing tapers inward, giving about 2.80 mm free space
// at a nominal 160 mm seam.  Subtract equal print clearance on both mating
// faces to get the printable locator width.
function coupler_project_seam_locator_width(clearance=coupler_fit_clearance_default()) =
    max(0, coupler_project_rear_seam_gap() - 2*clearance);

// Both edge and corner parts sit around the same physical top/bottom rear rail.
function coupler_project_horizontal_arm_height() =
    hub75_rear_end_rail_width() + 2*coupler_project_side_material();

// At an internal seam, two side rails face each other with the nominal panel
// pitch gap between them.  Only the two *outer* sides receive printed wall
// material; there is no fictitious wall inserted between the panels.
function coupler_project_edge_vertical_arm_width() =
    2*hub75_rear_side_rail_width()
    + coupler_project_rear_seam_gap()
    + 2*coupler_project_side_material();

// At an outside corner there is only one panel side rail.
function coupler_project_corner_vertical_arm_width() =
    hub75_rear_side_rail_width() + 2*coupler_project_side_material();

// Matching physical keep-out width at an internal seam.
function coupler_project_edge_seam_keepout_width() =
    2*hub75_rear_side_rail_width() + coupler_project_rear_seam_gap();
