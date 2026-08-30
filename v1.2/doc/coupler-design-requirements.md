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

The named profiles explicitly define the same design settings that are exposed
when `custom` is selected. This keeps fixed presets and custom mode conceptually
consistent.

| Profile | Size | Wall | Guide height | Base | Corner radius | Edge radius | Tube clip offset |
|---|---:|---:|---:|---:|---:|---:|---:|
| Small | 60 mm | 2 mm | 4 mm | 2 mm | 6 mm | 3 mm | 18 mm |
| Medium | 80 mm | 4 mm | 6 mm | 3 mm | 8 mm | 4 mm | 25 mm |
| Large | 100 mm | 6 mm | 10 mm | 4 mm | 10 mm | 5 mm | 25 mm |

These are **profile settings**. Derived geometry such as the start of the plate
edge radius, guide transition, plate-follow depth, cap depth and maximum guide
reach must be calculated from these settings. They are not extra Customizer
controls and must not be stored as a second set of small/medium/large constants
in individual component files.

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

The shared rounded-end split is based on **guide-wall width**. It is not a percentage of
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

Tube-clip placement is a separate physical design requirement and is an explicit
profile/custom setting. The selected offset must still be validated against the
available plate envelope so a smaller profile cannot leave a clip unsupported or
unnecessarily protruding.

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

## Guide end geometry

The guide is derived from the same rounded plate profile as the coupler body. After subtracting the authoritative HUB75 rear keep-out plus print clearance, the exposed thin-guide ends are softly rounded. The guide follows the plate edge into its radius and terminates smoothly, without a square cut, wedge, cusp, or separate analytic cap. The same construction is used for small, medium and large; only the resolved profile dimensions change.

### Local free-end rounding

Guide-end rounding must be a **local** operation. The fitted guide shell remains authoritative over its full length. Only the free-end zone may be rounded; a shrink/expand operation must never be applied to the complete guide because that can erase the thin `small` guide. Both the outside and inside guide contours must turn around the free plate end; a square inner end face is not acceptable.

The rounded cap must be constructed as a **positive local mask/cap** over the authoritative fitted shell. `offset(delta=-r)` is forbidden for guide-end shaping, including inside a local end zone.
