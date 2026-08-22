// HUB75 Display Frame - V1.2
// Documentation render: full rear fit section, cut 5 mm into the panel rear.

use <../assemblies/rear_fit_section.scad>

rear_fit_section(
    depth=5.0,
    show_panel_numbers=false,
    show_io_labels=false
);

$vpt = [400, 9.5, 160];
$vpr = [90, 0, 180];
$vpd = 1200;
