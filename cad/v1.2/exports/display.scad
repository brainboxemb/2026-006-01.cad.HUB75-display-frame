// HUB75 Display Frame - V1.2
// STL export entry point: complete display assembly.
//
// The GitHub export action can export every *.scad file in exports/ without
// needing to know assembly internals. This entry point exports the assembled
// five-panel display including couplers and aluminium stiffening tubes.

use <../assemblies/display_assembly.scad>

display_assembly(
    panels_visible=true,
    couplers_visible=true,
    stiffening_tubes_visible=true,
    orientation_visible=false,
    panel_numbers_visible=false,
    in_out_labels_visible=false,
    explode_distance=0
);
