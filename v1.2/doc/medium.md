# Coupler profile — Medium

> The model and documentation were developed with the assistance of ChatGPT.

## Profile preset values

These are the fixed values selected by the `medium` profile. The same fields are editable when `custom` is selected in the OpenSCAD Customizer.

| Setting | Value |
|---|---:|
| Profile envelope | 80 × 80 mm |
| Wall thickness | 4 mm |
| Guide height | 6 mm |
| Base thickness | 3 mm |
| Corner radius | 8 mm |
| Edge radius | 4 mm |
| Tube clip offset | 25 mm |

## Derived guide geometry

These values are **calculated**, not independent profile settings. They are shown only to make the geometry easier to verify.

| Derived value | Formula | Result |
|---|---|---:|
| Start of plate edge radius | `profile_size / 2 - edge_radius` | 36 mm |
| Plate-follow depth | `wall_thickness × 0.30` | 1.2 mm |
| Own cap depth | `wall_thickness × 0.70` | 2.8 mm |
| Maximum guide reach | radius start + follow + cap | 40 mm |

## Side by side

![V1.2 Medium couplers side by side](../out/png/hub75-display-frame-couplers-medium-side-by-side.png)

## Stacked

![V1.2 Medium couplers stacked](../out/png/hub75-display-frame-couplers-medium-stacked.png)

## Middle panel coupler

![V1.2 Medium middle panel coupler](../out/png/hub75-display-frame-couplers-medium-middle.png)

## Horizontal edge panel coupler

![V1.2 Medium horizontal edge panel coupler](../out/png/hub75-display-frame-couplers-medium-horizontal-edge.png)

## Left corner edge panel coupler

![V1.2 Medium left corner edge panel coupler](../out/png/hub75-display-frame-couplers-medium-corner-left.png)

## Right corner edge panel coupler

![V1.2 Medium right corner edge panel coupler](../out/png/hub75-display-frame-couplers-medium-corner-right.png)
