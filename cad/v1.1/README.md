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
- adjacent modules use asymmetric dovetail-style interlocks: the female/pocket module owns 5 mm across the nominal grid line, the male module is cut back 5 mm, and the dovetail spans 10 mm total depth;
- separate seam joiners use the existing HUB75 screw pairs to connect neighbouring panels and locate into the printed modules;
- four related red shades are repeated across the OpenSCAD assembly view to make neighbouring frame modules and four-module crossings easier to distinguish;
- the top and bottom module rows include two integrated snap clips per module;
- two continuous 800 mm aluminium tubes (Ø10 × 1 mm wall) snap into those clips to add longitudinal stiffness and alignment;
- the top and bottom frame modules extend straight beyond the panel edges;
- in side view each circular tube clamp sits beside this straight extension, with a small overlap into the plate for a direct connection;
- the aluminium tube runs perpendicular to these extensions over the full 800 mm width;
- the structural clips occupy only short sections of the tube, so later front-border parts can use the free tube sections as their own clip interface;
- the remaining outside perimeter is kept available for that separate visible border.

The mounting holes follow the measured HUB75 mounting-hole positions. The internal printed joints are deliberately offset from the nominal 160 mm grid: one module owns 5 mm across the grid line, while the mating module is cut back by the same amount. The puzzle feature then continues to 10 mm total depth. This means the printed structural seam no longer coincides exactly with the HUB75 panel/grid seam.

At the horizontal centre joint the two nearby HUB75 screws are divided diagonally between the printed modules. At a four-module crossing the intended ownership is:

```text
A | B
--+--
C | D
```

The first screw belongs to **A** and the second screw belongs to **D**. Around the D-owned screw, D takes one continuous region from B and grows upward through the horizontal joint. A is left untouched by this transfer. At the lower corner, the D tab returns directly to the normal D/C boundary with one 45-degree transition; there is no separately dimensioned tongue into C. C receives the matching clearance notch. Each screw hole is therefore fully contained by one printed part instead of sitting on a module boundary.

The panel-seam joiners are compact rectangular connection plates with chamfered corners, using the existing HUB75 screw pairs and locating pins into the printed modules.

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

The current module joints use a 5 mm asymmetric ownership strip with a 10 mm total puzzle depth, so the real printed seam is offset from the nominal panel/grid boundary. The vertical panel seam joiner remains a single compact rectangular plate with chamfered corners.


## Dovetail joint update

The module interlock is now generated from one dovetail profile. The 45-degree flanks start directly at the narrow root and finish with a 1.5 mm straight tip. Female pockets are derived from the same profile with print clearance added, then transformed to the mating edge orientation. This keeps the male and female geometry complementary instead of constructing them independently.

At four-module intersections the middle screw pair is intentionally owned diagonally. The first screw is contained by A and the second by D. The D-owned region is one continuous profile: the main area replaces B around the second screw, then returns directly to the normal D/C boundary with a single 45-degree flank. A is not cut by this transition.


Current crossing refinement: A owns the first middle screw through the normal overlap; D owns the second through a tab into B. The lower corner of that tab tapers directly back to the normal D/C boundary with one 45-degree flank, without an extra tongue.

## Documentation renders

The official documentation views are defined inside the CAD project rather than in the CI workflow:

```text
renders/
├── front.scad
├── rear.scad
└── exploded.scad
```

This keeps the camera position and model visibility reproducible when renders are generated locally or by GitHub Actions.

The helper script renders all three images:

```bash
bash cad/v1.1/scripts/render_pngs.sh out/v1.1/png
```

It generates:

```text
out/v1.1/png/
├── hub75-display-frame-front.png
├── hub75-display-frame-rear.png
└── hub75-display-frame-exploded.png
```

The repository-level GitHub Actions workflow belongs at:

```text
.github/workflows/render-openscad-v1.1.yml
```

It can be run manually and also runs when files below `cad/v1.1/` change. The generated PNG files are committed back to `out/v1.1/png/` so they can be referenced directly by the repository README.

### Exploded view

The V1.1 exploded view now separates more than just the depth layers:

- HUB75 panels move forward;
- the ten printed frame modules fan out slightly in X and Z to expose their interlocking edges;
- panel-seam joiners move rearward as a separate layer;
- the top aluminium tube moves upward out of its clips;
- the bottom aluminium tube moves downward out of its clips.

`exploded_distance` in `main.scad` controls the complete exploded presentation from one parameter.
