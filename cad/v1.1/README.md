# HUB75 Display Frame — V1.1 CAD

The model and documentation were developed with the assistance of ChatGPT.

V1.1 develops a modular 3D-printed structural frame for five HUB75 panels, reinforced by continuous aluminium tubes along the top and bottom.

## First modular-frame concept

The first frame concept uses the nominal HUB75 dimensions as a structural grid:

- nominal HUB75 cell: 160 × 320 mm;
- printed structural module: 160 × 160 mm;
- five panels therefore form a 5 × 2 grid of ten printed modules;
- the measured panel PCB remains slightly smaller than the nominal grid;
- each module has a large central opening to reduce material and keep the rear connectors accessible;
- adjacent modules use puzzle-style interlocks;
- separate seam joiners use the existing HUB75 screw pairs to connect neighbouring panels and locate into the printed modules;
- two red shades are alternated in a checkerboard pattern in the OpenSCAD assembly view to make individual modules easier to distinguish;
- the top and bottom module rows include two integrated snap clips per module;
- two continuous 800 mm aluminium tubes (Ø10 × 1 mm wall) snap into those clips to add longitudinal stiffness and alignment;
- the top and bottom frame modules extend straight beyond the panel edges;
- in side view each circular tube clamp sits beside this straight extension, with a small overlap into the plate for a direct connection;
- the aluminium tube runs perpendicular to these extensions over the full 800 mm width;
- the structural clips occupy only short sections of the tube, so later front-border parts can use the free tube sections as their own clip interface;
- the remaining outside perimeter is kept available for that separate visible border.

The mounting holes follow the measured HUB75 mounting-hole positions. The middle screw row lies almost exactly on the 160 mm horizontal module seam. Instead of splitting those holes over two printed parts, the lower module now extends an angular puzzle-style key across the seam and the upper module receives a matching clearance pocket. Each middle-row screw hole is therefore fully contained in one printed module, without the narrow V-shaped points created by adjacent round bosses.

The panel-seam joiners have also been enlarged around the screw points and through the centre bridge so they act more clearly as structural connection plates.

## Structure

```text
.
├── main.scad
├── config/
│   └── project_config.scad
├── components/
│   ├── aluminium_stiffening_tube.scad
│   ├── frame_module.scad
│   ├── hub75_panel.scad
│   └── panel_seam_joiner.scad
└── assemblies/
    ├── display_assembly.scad
    ├── frame_modules_assembly.scad
    ├── panel_seam_joiners_assembly.scad
    ├── panels_assembly.scad
    └── stiffening_tubes_assembly.scad
```

Open `main.scad` for the complete V1.1 concept. The `exploded` view mode separates the HUB75 panels, printed frame modules and seam joiners along the depth axis. The stiffening tubes stay with the printed frame layer in the exploded view; their clamps are side-mounted to the straight top and bottom module extensions. `exploded_distance` controls the spacing. Individual component files can also be opened independently for tuning and inspection.


## Tube clamp orientation

The tube snap clamps are side-mounted to the straight frame extensions. In side view the clamp opening faces away from the plate extension, rather than upward or downward.


### Current joint refinement

The middle horizontal module seam now uses edge-connected trapezoidal screw tabs and matching cutouts, avoiding thin points at four-module intersections. The vertical panel seam joiner is a single compact rectangular plate with chamfered corners rather than two circular pads connected by a narrow bridge.
