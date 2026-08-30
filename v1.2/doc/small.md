# Coupler profile — Small

> The model and documentation were developed with the assistance of ChatGPT.

## Profile preset values

These are the fixed values selected by the `small` profile. The same fields are editable when `custom` is selected in the OpenSCAD Customizer.

| Setting | Value |
|---|---:|
| Profile envelope | 60 × 60 mm |
| Wall thickness | 2 mm |
| Guide height | 4 mm |
| Base thickness | 2 mm |
| Corner radius | 6 mm |
| Edge radius | 3 mm |
| Tube clip offset | 18 mm |

## Derived guide geometry

These values are **calculated**, not independent profile settings. They are shown only to make the geometry easier to verify.

| Derived value | Formula | Result |
|---|---|---:|
| Start of plate edge radius | `profile_size / 2 - edge_radius` | 27 mm |
| Plate-follow depth | `wall_thickness × 0.30` | 0.6 mm |
| Own cap depth | `wall_thickness × 0.70` | 1.4 mm |
| Maximum guide reach | radius start + follow + cap | 29 mm |

## Side by side

![V1.2 Small couplers side by side](../out/png/hub75-display-frame-couplers-small-side-by-side.png)

## Stacked

![V1.2 Small couplers stacked](../out/png/hub75-display-frame-couplers-small-stacked.png)

## Middle panel coupler

![V1.2 Small middle panel coupler](../out/png/hub75-display-frame-couplers-small-middle.png)

## Horizontal edge panel coupler

![V1.2 Small horizontal edge panel coupler](../out/png/hub75-display-frame-couplers-small-horizontal-edge.png)

## Left corner edge panel coupler

![V1.2 Small left corner edge panel coupler](../out/png/hub75-display-frame-couplers-small-corner-left.png)

## Right corner edge panel coupler

![V1.2 Small right corner edge panel coupler](../out/png/hub75-display-frame-couplers-small-corner-right.png)
