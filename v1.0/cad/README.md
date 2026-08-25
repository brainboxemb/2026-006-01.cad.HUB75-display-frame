# HUB75 Display Frame — Modular OpenSCAD Project

The model and documentation were developed with the assistance of ChatGPT.

This version deliberately narrows the project to the aluminium HUB75 display frame and the parts mounted directly to that frame.

The former wooden enclosure, EPDM/plexiglass enclosure stack, top-cap parts and plastic handle have been removed. This project now contains only the active modular frame model; the old monolithic/legacy source is no longer included.

## Structure

```text
.
├── main.scad
├── config/
│   └── project_config.scad
├── components/
│   ├── ... individual frame-related parts ...
│   └── _lib/
│       └── fasteners.scad
├── assemblies/
│   ├── frame_assembly.scad
│   ├── panels_assembly.scad
│   ├── hardware_assembly.scad
│   ├── frame_system_assembly.scad
│   └── ... optional frame-mounted electronics ...
```

## Working model

- Open `main.scad` for the active frame model.
- The default `frame_system` view shows the aluminium frame, HUB75 panels and their mechanical mounting hardware.
- ESP32 and power-supply assemblies remain available as optional frame-mounted subsystems, but are hidden by default while the mechanical frame is being developed.
- Open any file in `components/` to render and tune that part independently.
- Open any file in `assemblies/` to inspect a subassembly independently.
- Shared dimensions and mounting interfaces live in `config/project_config.scad`.
- Placement belongs in assemblies, not in component geometry.

## Current scope

The active design now focuses on:

- 20 × 20 mm aluminium extrusion frame;
- five HUB75 panels;
- panel-to-frame brackets;
- vertical TS35 DIN rails at panel seams;
- cable clips and ribbon-cable routing;
- fasteners associated with those frame-mounted parts.

The enclosure can be reconsidered later, after the frame concept has been developed further.

## OpenSCAD entry points

`view_mode` is deliberately the first Customizer section in `main.scad`, so changing the active view is the first control shown when working with the complete model.

Assemblies are loaded by `main.scad` with `use <...>`. Visibility settings from `main.scad` are passed explicitly into the assemblies, so controls such as `show_esp32`, `show_power_supply`, `show_brackets` and `show_bolts` work reliably. Each assembly can still contain its own standalone preview settings without affecting the complete model. No special `assembly_library` parameter is required.

## Documentation renders

V1.0 contains fixed OpenSCAD camera files under `renders/` so local and CI-generated documentation images use the same viewpoints.

```text
renders/
├── front.scad
├── front_angled.scad
├── rear.scad
├── rear_angled.scad
├── exploded_rear.scad
└── exploded_rear_angled.scad
```

The exploded view keeps the aluminium frame as the reference layer, moves the HUB75 panels toward the front and moves the frame-mounted hardware toward the rear.

From the repository root, the official PNG set can be generated with:

```bash
bash cad/v1.0/scripts/render_pngs.sh out/v1.0/png
```

The script creates:

```text
hub75-display-frame-front.png
hub75-display-frame-front-angled.png
hub75-display-frame-rear.png
hub75-display-frame-rear-angled.png
hub75-display-frame-exploded-rear.png
hub75-display-frame-exploded-rear-angled.png
```
