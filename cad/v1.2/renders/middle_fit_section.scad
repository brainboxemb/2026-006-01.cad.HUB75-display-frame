// HUB75 Display Frame - V1.2
// Documentation render: middle seam coupler fit section at 5 mm depth.

use <../assemblies/middle_coupler_fit_section.scad>

middle_coupler_fit_section(
    depth=5.0,
    crop_width=145.0,
    crop_height=115.0
);

$vpt = [0, 9.5, 0];
$vpr = [72, 0, 180];
$vpd = 190;
