// STL export entry - V1.2 left corner edge panel coupler
include <../config/project_config.scad>
use <../components/hub75_panel.scad>
use <../assemblies/couplers_assembly.scad>

// Canonical top-left printable variant. Bottom use is obtained by assembly orientation.
project_corner_edge_panel_coupler(side="left", direction="top", screw_row_z=hub75_panel_hole_z_top());
