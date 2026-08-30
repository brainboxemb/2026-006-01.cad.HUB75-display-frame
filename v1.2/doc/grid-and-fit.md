# Grid and fit rules

The V1.2 coupler family uses two different geometric references deliberately:

- **Nominal panel grid:** exactly 160 × 320 mm in this portrait assembly. Panel centres and all coupler reference/seam positions are placed on this grid.
- **Physical panel geometry:** 159.70 × 319.71 mm plus the STEP-derived rear housing taper. This geometry is used only for local fit, guide and locator dimensions.

## Rear seam locator

The seam rib/locator does **not** use the 0.30 mm front/body gap. It engages at the rear mounting plane, where the housing has tapered inward by the STEP-derived outer inset. Therefore the usable rear seam is larger.

For the current panel model:

- nominal X pitch: 160.00 mm
- physical body width: 159.70 mm
- rear outer inset: about 1.248 mm per side
- rear seam gap: about 2.80 mm
- print clearance: 0.25 mm per mating side
- locator width: about 2.30 mm

The middle and horizontal-edge couplers use the same shared calculation. The locator is centred exactly on the nominal 160 mm grid seam. Its maximum width at the coupler base comes from the physical rear seam minus the fixed print clearance. From that base width the complete locator height tapers symmetrically toward a narrower insertion tip; there is no separate straight body plus short lead-in section.

The selected small/medium/large coupler profile changes plate, wall and guide dimensions, but it does not move the nominal grid or scale the physical print clearance.



## Rear mounting-plane rail fit

Coupler guide clearance is evaluated against the **actual rail footprint at the rear mounting plane**, not against the wider rail dimensions at the start of the tapered rear housing. The bay openings remain vertical while the outside housing tapers inward, so the outer side/end rails become narrower at the mating face.

For the current panel model this means approximately:

- rear outer inset X: 1.248 mm
- rear outer inset Z: 1.249 mm
- side rail at mounting plane: 12.50 - 1.248 = **11.252 mm**
- normal end rail at mounting plane: 10.75 - 1.249 = **9.501 mm**
- internal X-seam rail keep-out: 2 × 11.252 + 2.795 = **25.300 mm**

Earlier guide code used the 12.50 mm and 10.75 mm reference widths directly at the rear face. That made the keep-out too large by about 1.25 mm at each outside rail face and made corner/edge fits appear inconsistent. Middle, horizontal-edge and corner couplers now derive their mating keep-outs from the same rear-plane dimensions, while retaining the fixed 0.25 mm printable clearance per mating side.

## Rear fit verification view

The full rear fit verification render deliberately hides the front pixel face and PCB of each HUB75 panel. Only the rear structural panel frame is shown in grey. This makes the individual panel perimeter, nominal seams and coupler engagement visible instead of merging the five panels into one large grey rectangle.


## Local XY fit cross-sections

The middle and horizontal-edge diagnostic cross-sections are cut with a thin slab **parallel to the XY plane** at a fixed Z coordinate. The Z station is chosen just inboard of the horizontal coupler arm. This exposes the seam locator and panel rear profile instead of showing a vertical XZ/YZ section.

These views are intended to verify:

- the locator centre is exactly on the nominal seam;
- equal clearance exists to the physical panel geometry on both sides;
- the locator width follows the rear seam gap rather than the front body gap;
- guide and cut-out geometry still follows the physical panel after grid-position changes.


## Canonical 2D coordinate references

Before changing coupler fit geometry, the V1.2 model now exposes standalone 2D engineering references under `v1.2/cad/references/`. Every panel remains centred around its own local `(0,0)` and component references only translate that canonical model.

The drawings distinguish four boundaries which must not be mixed:

1. nominal 160 × 320 mm portrait grid cell;
2. physical front/body outside contour;
3. physical rear outside contour at the mounting plane;
4. physical rear **inner rail edge**, i.e. the start of the electronics opening.

The rear outer and rear inner boundaries together define the real mating rail width used by coupler keep-outs. The reference set includes panel, middle, horizontal-edge, top-left corner and top-right corner coordinate views.

All reference entrypoints reuse the same shared reference-grid implementation as the top-level CAD views. The grid remains independently switchable from the Customizer when a reference `.scad` file is opened directly.

## Canonical panel fit coordinates

All mating geometry now passes through `cad/components/_lib/panel_fit_geometry.scad`.
`hub75_panel.scad` remains the authoritative physical panel model; the fit
adapter only translates that model into one shared panel-centred coordinate
system for the middle, horizontal-edge and corner couplers and for the 2D
reference drawings.

The adapter keeps the nominal placement cell, physical front outer edge, rear
outer edge and rear inner/opening edge separate.  Component files should not
reconstruct those boundaries with local offsets.
