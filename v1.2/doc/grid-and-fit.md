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

The middle and horizontal-edge couplers use the same shared calculation. The locator is centred exactly on the nominal 160 mm grid seam. It is mostly parallel-sided, with only a short lead-in taper at the insertion tip; the earlier full-height wedge is intentionally avoided.

The selected small/medium/large coupler profile changes plate, wall and guide dimensions, but it does not move the nominal grid or scale the physical print clearance.


## Rear fit verification view

The full rear fit verification render deliberately hides the front pixel face and PCB of each HUB75 panel. Only the rear structural panel frame is shown in grey. This makes the individual panel perimeter, nominal seams and coupler engagement visible instead of merging the five panels into one large grey rectangle.


## Local XY fit cross-sections

The middle and horizontal-edge diagnostic cross-sections are cut with a thin slab **parallel to the XY plane** at a fixed Z coordinate. The Z station is chosen just inboard of the horizontal coupler arm. This exposes the seam locator and panel rear profile instead of showing a vertical XZ/YZ section.

These views are intended to verify:

- the locator centre is exactly on the nominal seam;
- equal clearance exists to the physical panel geometry on both sides;
- the locator width follows the rear seam gap rather than the front body gap;
- guide and cut-out geometry still follows the physical panel after grid-position changes.
