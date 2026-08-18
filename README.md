# HUB75 Display Frame

> The model and documentation were developed with the assistance of ChatGPT.

This repository contains the OpenSCAD development of a frame for five HUB75 LED matrix panels.

The design uses a modular OpenSCAD structure with separate components and assemblies. Individual parts can be opened, rendered and tuned independently, while the complete construction can be viewed from `main.scad`.

> **Project status:** Concept development  
> V1.0 explores a frame based on 20 × 20 mm aluminium extrusion and is mainly retained as a reference concept. Active development is moving towards V1.1, in which the aluminium extrusion is replaced by a fully 3D-printed structural frame.

## V1.0

### Inspiration

The aluminium-frame approach in V1.0 was inspired by the Instructables project [**Simple Extruded Aluminum Frame for LED Panels**](https://www.instructables.com/Simple-Extruded-Aluminum-Frame-for-LED-Panels/), created by **NotLikeALeafOnTheWind**.

[![Simple Extruded Aluminum Frame for LED Panels - Instructables reference](_images/instructables_simple-extrued-aluminum-frame_w320.webp)](https://www.instructables.com/Simple-Extruded-Aluminum-Frame-for-LED-Panels/)

*Source: [Instructables / NotLikeALeafOnTheWind — Simple Extruded Aluminum Frame for LED Panels](https://www.instructables.com/Simple-Extruded-Aluminum-Frame-for-LED-Panels/). The image is included as a visual reference to the original project. Copyright remains with the original creator.*

### Concept

V1.0 explores an aluminium-extrusion-based structure for supporting the HUB75 panels and the components mounted directly to that structure.

The concept includes:

- a 20 × 20 mm aluminium extrusion frame;
- five HUB75 LED matrix panels;
- panel mounting brackets;
- TS35 DIN rails positioned around the panel seams;
- cable clips and ribbon-cable routing;
- frame-mounted fasteners;
- optional ESP32 mounting;
- optional power-supply mounting.

V1.0 is a concept drawing and is primarily retained as a reference for this construction approach.

The OpenSCAD model is stored in:

```text
cad/v1.0/
```

### Renders

Reference renders generated from the OpenSCAD model are stored in:

```text
out/v1.0/png/
```

#### Front view

![HUB75 display frame V1.0 - front view](out/v1.0/png/hub75-display-frame-front.png)

#### Rear view

![HUB75 display frame V1.0 - rear view](out/v1.0/png/hub75-display-frame-rear.png)

### CAD structure

The V1.0 OpenSCAD model is divided into configuration, individual components and assemblies.

```text
cad/v1.0/
├── main.scad
├── config/
│   └── project_config.scad
├── components/
│   ├── ...
│   └── _lib/
│       └── fasteners.scad
└── assemblies/
    ├── frame_assembly.scad
    ├── panels_assembly.scad
    ├── hardware_assembly.scad
    ├── frame_system_assembly.scad
    └── ...
```

Open `cad/v1.0/main.scad` to view and configure the complete model.

Files in `components/` can be opened directly in OpenSCAD to render and tune individual parts without loading the complete assembly.

Files in `assemblies/` combine these components into functional parts of the complete construction and can also be viewed independently.

## V1.1

### Concept

V1.1 continues the development with a different structural approach.

The 20 × 20 mm aluminium extrusion used in V1.0 is removed. Instead, the intention is to develop the complete structural frame as a 3D-printed construction.

Development of this version is stored in:

```text
cad/v1.1/
```

## Repository structure

```text
.
├── README.md
├── _images/
│   └── instructables_simple-extrued-aluminum-frame_w320.webp
├── cad/
│   ├── v1.0/
│   │   └── ...
│   └── v1.1/
│       └── ...
└── out/
    ├── v1.0/
    │   └── png/
    │       ├── hub75-display-frame-v1.0-front.png
    │       └── hub75-display-frame-v1.0-rear.png
    └── v1.1/
        └── ...
```