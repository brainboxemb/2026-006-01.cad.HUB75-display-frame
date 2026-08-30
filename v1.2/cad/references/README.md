# V1.2 coordinate reference drawings

These standalone OpenSCAD files are the coordinate/fit verification layer between the physical HUB75 panel model and the printable couplers.

Every panel is defined once around its own local `(0,0)`. Component drawings only translate that canonical panel into the component-local coordinate system.

## Boundary layers

Each drawing can show four distinct panel boundaries:

1. **Nominal grid** — exact 160 × 320 mm portrait placement cell (320 × 160 mm landscape).
2. **Physical front outer** — measured physical panel envelope.
3. **Rear outer** — outside edge at the rear mounting plane after the housing taper.
4. **Rear inner edge** — inside boundary of the outer rear side/end rails. This is the critical second boundary for coupler fit.

Mounting-hole centres are shown from the same canonical panel coordinate model.

## Standalone drawings

- `panel_reference.scad` — one panel around panel-local `(0,0)`.
- `middle_reference.scad` — two adjacent panels; middle bridge origin on their nominal seam.
- `horizontal_edge_reference.scad` — two adjacent panels; origin where the nominal seam meets the nominal top edge.
- `corner_left_reference.scad` — top-left nominal panel corner at component `(0,0)`.
- `corner_right_reference.scad` — top-right nominal panel corner at component `(0,0)`.

Bottom edge/corner placement is the mirrored form of the top references.

## Grid

All files are standalone Customizer entrypoints. They reuse the **same shared grid implementation** as the normal top-level CAD inspection views (`components/_lib/reference_grid.scad`).

Each reference file exposes:

```scad
show_grid = true;
grid_major = 10;
grid_show_half = true;
```

so the grid can be enabled/disabled even when opening only a file from this directory.
