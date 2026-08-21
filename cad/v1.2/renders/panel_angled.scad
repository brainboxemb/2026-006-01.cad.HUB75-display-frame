// HUB75 Display Frame - V1.2
// Documentation render: individual HUB75 panel reference, angled rear view.
//
// Uses the light-grey standalone colour scheme so rear geometry is easier
// to inspect than with the normal black panel housing.

use <../components/hub75_panel.scad>

hub75_panel(
    show_orientation=true,
    show_connectors=true,
    body_color=[0.72, 0.72, 0.72, 1],
    front_color=[0.52, 0.52, 0.52, 1],
    pcb_color=[0.02, 0.20, 0.07, 1],
    connector_color=[0.06, 0.06, 0.06, 1]
);

$vpt = [79.85, 8, 159.855];
$vpr = [78, 0, 158];
$vpd = 850;
