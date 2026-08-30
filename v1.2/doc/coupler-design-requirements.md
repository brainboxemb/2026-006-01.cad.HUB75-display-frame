# V1.2 coupler design requirements

This document is the design contract for the printable HUB75 coupler family.
The OpenSCAD implementation should be checked against these rules before local
geometry is adjusted.

## 1. Authoritative panel geometry

`components/hub75_panel.scad` is the authoritative source for the physical HUB75
panel. Couplers must not copy panel dimensions or reconstruct the same panel
edge independently.

All coupler fit geometry is derived through the shared panel-fit layer:

- nominal 160 × 320 mm portrait placement grid;
- physical front outer contour;
- physical rear outer contour;
- physical rear inner/opening contour;
- mounting-hole and locator positions.

The nominal grid determines placement. The physical rear geometry determines
fit. Those two coordinate systems must never be substituted for each other.

## 2. One shared coupler profile system

The named profiles define only their basic envelope dimensions:

| Profile | Size | Wall | Guide height | Base |
|---|---:|---:|---:|---:|
| Small | 60 mm | 2 mm | 4 mm | 2 mm |
| Medium | 80 mm | 4 mm | 6 mm | 3 mm |
| Large | 100 mm | 6 mm | 10 mm | 4 mm |

Shape dimensions are derived parametrically from those effective values. Do not
put separate small/medium/large correction values in the middle, horizontal-edge
or corner component files.

## 3. Plate shape

The plate has two visually different radii:

- `corner_radius`: concave transition from an arm into the central body;
- `edge_radius`: convex radius at the free end of an arm.

The plate must remain large enough to support the complete fitted guide. A guide
must never hang outside its supporting plate because the source envelope was
cropped too early.

## 4. Guide fit

The guide is derived from the actual rear panel keep-out plus the configured
print clearance. It is not independently positioned from the plate.

The same physical rear edge must produce the same fit clearance in middle,
horizontal-edge and corner couplers.

## 5. Guide free-end shape

The guide must never end in a square cut or a sharp kink.

At a free plate end the construction is:

1. the straight guide continues to the start of the plate `edge_radius`;
2. it follows the plate curve for **30% of the guide-wall width**;
3. from that transition point the remaining **70% of the guide-wall width** is
   used as the axial depth of the guide's own smooth rounded cap;
4. the own cap joins the straight/following guide tangentially;
5. the complete result is intersected with the authoritative fitted shell, so
   the end-shaping operation can remove material but can never add material
   outside the plate or into the panel keep-out.

The 30/70 split is based on **guide-wall width**. It is not a percentage of
profile size and not a percentage of plate radius.

## 6. Guide length

`guide_length` is an outcome, not an independent percentage of profile size.

The important derived locations are:

- start of the plate edge radius: `profile_size / 2 - edge_radius`;
- plate-follow depth: `guide_wall × 0.30`;
- guide-cap depth: `guide_wall × 0.70`;
- guide transition: radius start + plate-follow depth;
- maximum guide reach: transition + guide-cap depth.

## 7. Tube clips

Tube-clip placement is a separate physical design requirement. It is derived
from the available plate envelope, half clip width and an explicit edge margin.
Reducing the coupler profile must not leave the tube clip protruding simply
because a medium/large offset was retained.

## 8. Component consistency

Middle, horizontal-edge and corner couplers must use the same shared helpers for:

- panel fit coordinates;
- plate radii;
- guide-wall clearance;
- guide free-end construction;
- tube-clip envelope rules where applicable.

A component may transform or crop the shared geometry for its topology, but it
must not redefine the underlying fit dimensions.

## 9. Verification before accepting a geometry change

At minimum check:

- small middle coupler, angled view;
- small horizontal-edge coupler, angled view;
- small corner coupler, angled view;
- medium middle coupler as a regression check;
- XY fit cross sections for middle and horizontal edge;
- the full rear-fit verification render.

The reference drawings remain the coordinate-system check. The angled and
cross-section renders are the printable-geometry check.
