// Printable internal horizontal edge panel coupler.
// The physical part is identical; the top/bottom distinction is only assembly orientation.
include <../config/project_config.scad>
use <../assemblies/couplers_assembly.scad>

project_horizontal_edge_panel_coupler(direction="top", screw_row_z=panel_hole_z[2]);
