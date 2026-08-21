// HUB75 P5 64 x 32 panel reference component
//
// Geometry reference:
// https://www.printables.com/model/792005-hub75-5mm-pitch-matrix-panel-model
//
// This component is intentionally self-contained.
// It does NOT include the project configuration.
//
// The project assembly can override all relevant dimensions explicitly,
// while opening this file directly provides usable defaults in the Customizer.
//
// Coordinate system:
// X = panel width
// Y = front to rear
// Z = panel height


/* [Panel size] */

// Datasheet dimensions - authoritative basic envelope.
panel_width = 159.70;
panel_height = 319.71;
panel_depth = 13.00;

// STEP nominal dimensions are retained only for scaling visual rear details.
reference_width = 160.00;
reference_height = 320.00;


/* [Panel depth] */

// Visual approximation retained from the STEP reference.
front_mask_depth = 1.75;
pcb_thickness = 1.00;

// Datasheet depth is authoritative.
mounting_plane_y = panel_depth;
max_depth = panel_depth;


/* [Mounting holes] */

// Datasheet mounting-hole positions in this project's portrait orientation.
hole_x_left = 7.85;
hole_x_right = 151.85;

hole_z_bottom = 7.855;
hole_z_middle = 159.855;
hole_z_top = 311.855;

hole_diameter = 3.00;

// Outer boss diameter is not specified by the supplied drawing.
// Keep the STEP-based visual approximation until physically measured.
boss_outer_diameter = 14.0;


/* [Rear frame] */

rear_frame_side_width_reference = 12.5;
rear_frame_end_width_reference = 12.5;
rear_frame_crossbar_width_reference = 8.0;

rear_crossbar_1_reference = 80.0;
rear_crossbar_2_reference = 160.0;
rear_crossbar_3_reference = 240.0;


/* [HUB75 connectors] */

data_connector_x_reference = 80.0135;

data_connector_z_bottom_reference = 44.10;
data_connector_z_top_reference = 264.60;

data_connector_width_reference = 27.94;
data_connector_height_reference = 9.50;

data_connector_depth = 10.64;
data_connector_front_y = 2.63;


/* [Power connector] */

power_connector_width = 12.0;
power_connector_height = 24.0;
power_connector_depth = 7.0;


/* [Standalone preview] */

preview_show_orientation = true;
preview_show_connectors = true;

// Light grey is easier to inspect than the original black housing.
preview_color_scheme = "light_gray"; // [light_gray, original]

preview_body_light_gray = [0.72, 0.72, 0.72, 1];
preview_front_light_gray = [0.52, 0.52, 0.52, 1];

preview_body_original = [0.08, 0.10, 0.09, 1];
preview_front_original = [0.015, 0.015, 0.015, 1];

preview_pcb_color = [0.02, 0.20, 0.07, 1];
preview_connector_color = [0.06, 0.06, 0.06, 1];


/* [Resolution] */

$fn = 48;


// -----------------------------------------------------------------------------
// Helper functions
// -----------------------------------------------------------------------------

function scale_x(value, width, reference_width) =
    value * width / reference_width;

function scale_z(value, height, reference_height) =
    value * height / reference_height;

function preview_body_color(scheme) =
    scheme == "light_gray"
        ? preview_body_light_gray
        : preview_body_original;

function preview_front_color(scheme) =
    scheme == "light_gray"
        ? preview_front_light_gray
        : preview_front_original;


// -----------------------------------------------------------------------------
// Geometry
// -----------------------------------------------------------------------------

module hub75_panel(
    width = panel_width,
    height = panel_height,

    reference_width_value = reference_width,
    reference_height_value = reference_height,

    front_mask_depth_value = front_mask_depth,
    pcb_thickness_value = pcb_thickness,
    mounting_plane_y_value = mounting_plane_y,
    max_depth_value = max_depth,

    hole_x_left_value = hole_x_left,
    hole_x_right_value = hole_x_right,

    hole_z_bottom_value = hole_z_bottom,
    hole_z_middle_value = hole_z_middle,
    hole_z_top_value = hole_z_top,

    hole_diameter_value = hole_diameter,
    boss_outer_diameter_value = boss_outer_diameter,

    rear_frame_side_width_ref = rear_frame_side_width_reference,
    rear_frame_end_width_ref = rear_frame_end_width_reference,
    rear_frame_crossbar_width_ref = rear_frame_crossbar_width_reference,

    rear_crossbar_1_ref = rear_crossbar_1_reference,
    rear_crossbar_2_ref = rear_crossbar_2_reference,
    rear_crossbar_3_ref = rear_crossbar_3_reference,

    data_connector_x_ref = data_connector_x_reference,
    data_connector_z_bottom_ref = data_connector_z_bottom_reference,
    data_connector_z_top_ref = data_connector_z_top_reference,
    data_connector_width_ref = data_connector_width_reference,
    data_connector_height_ref = data_connector_height_reference,
    data_connector_depth_value = data_connector_depth,
    data_connector_front_y_value = data_connector_front_y,

    power_connector_width_value = power_connector_width,
    power_connector_height_value = power_connector_height,
    power_connector_depth_value = power_connector_depth,

    show_orientation = true,
    show_connectors = true,

    body_color = preview_body_original,
    front_color = preview_front_original,
    pcb_color = preview_pcb_color,
    connector_color = preview_connector_color
) {
    // Mounting-hole positions are direct datasheet dimensions.
    // They are intentionally NOT scaled from the STEP reference.
    hole_x_positions = [
        hole_x_left_value,
        hole_x_right_value
    ];

    hole_z_positions = [
        hole_z_bottom_value,
        hole_z_middle_value,
        hole_z_top_value
    ];

    pcb_back_y =
        front_mask_depth_value
        + pcb_thickness_value;

    rear_frame_start_y =
        pcb_back_y;

    rear_frame_depth =
        mounting_plane_y_value
        - rear_frame_start_y;

    rear_rib_extra_depth =
        max_depth_value
        - mounting_plane_y_value;

    rear_frame_side_width =
        scale_x(
            rear_frame_side_width_ref,
            width,
            reference_width_value
        );

    rear_frame_end_width =
        scale_z(
            rear_frame_end_width_ref,
            height,
            reference_height_value
        );

    rear_frame_crossbar_width =
        scale_z(
            rear_frame_crossbar_width_ref,
            height,
            reference_height_value
        );

    rear_crossbar_z = [
        scale_z(
            rear_crossbar_1_ref,
            height,
            reference_height_value
        ),
        scale_z(
            rear_crossbar_2_ref,
            height,
            reference_height_value
        ),
        scale_z(
            rear_crossbar_3_ref,
            height,
            reference_height_value
        )
    ];

    data_connector_x =
        scale_x(
            data_connector_x_ref,
            width,
            reference_width_value
        );

    data_connector_z_bottom =
        scale_z(
            data_connector_z_bottom_ref,
            height,
            reference_height_value
        );

    data_connector_z_top =
        scale_z(
            data_connector_z_top_ref,
            height,
            reference_height_value
        );

    data_connector_width =
        scale_x(
            data_connector_width_ref,
            width,
            reference_width_value
        );

    data_connector_height =
        scale_z(
            data_connector_height_ref,
            height,
            reference_height_value
        );

    power_connector_x =
        width / 2;

    power_connector_z =
        height / 2;


    module mounting_boss(x, z) {
        difference() {
            color(body_color)
                translate([
                    x,
                    rear_frame_start_y,
                    z
                ])
                    rotate([-90, 0, 0])
                        cylinder(
                            h=
                                mounting_plane_y_value
                                - rear_frame_start_y,
                            d=boss_outer_diameter_value,
                            $fn=36
                        );

            translate([
                x,
                -0.2,
                z
            ])
                rotate([-90, 0, 0])
                    cylinder(
                        h=mounting_plane_y_value + 0.5,
                        d=hole_diameter_value,
                        $fn=30
                    );
        }
    }


    module rear_frame_structure() {
        color(body_color) {
            // Left rail
            translate([
                0,
                rear_frame_start_y,
                0
            ])
                cube([
                    rear_frame_side_width,
                    rear_frame_depth,
                    height
                ]);

            // Right rail
            translate([
                width - rear_frame_side_width,
                rear_frame_start_y,
                0
            ])
                cube([
                    rear_frame_side_width,
                    rear_frame_depth,
                    height
                ]);

            // Bottom rail
            translate([
                0,
                rear_frame_start_y,
                0
            ])
                cube([
                    width,
                    rear_frame_depth,
                    rear_frame_end_width
                ]);

            // Top rail
            translate([
                0,
                rear_frame_start_y,
                height - rear_frame_end_width
            ])
                cube([
                    width,
                    rear_frame_depth,
                    rear_frame_end_width
                ]);

            // Three crossbars -> four large open rear sections
            for(zc=rear_crossbar_z)
                translate([
                    0,
                    rear_frame_start_y,
                    zc - rear_frame_crossbar_width/2
                ])
                    cube([
                        width,
                        rear_frame_depth,
                        rear_frame_crossbar_width
                    ]);

            // Small extra-depth ribs to reflect maximum STEP envelope
            for(zc=rear_crossbar_z)
                translate([
                    rear_frame_side_width,
                    mounting_plane_y_value,
                    zc - rear_frame_crossbar_width/4
                ])
                    cube([
                        width - 2*rear_frame_side_width,
                        rear_rib_extra_depth,
                        rear_frame_crossbar_width/2
                    ]);
        }

        for(x=hole_x_positions)
            for(z=hole_z_positions)
                mounting_boss(x, z);
    }


    module hub75_data_connector(z) {
        color(connector_color)
            translate([
                data_connector_x
                    - data_connector_width/2,
                data_connector_front_y_value,
                z
                    - data_connector_height/2
            ])
                cube([
                    data_connector_width,
                    data_connector_depth_value,
                    data_connector_height
                ]);

        // Visual opening on the rear-facing side
        color([0.015, 0.015, 0.015, 1])
            translate([
                data_connector_x
                    - data_connector_width*0.39,
                data_connector_front_y_value
                    + data_connector_depth_value
                    - 0.4,
                z
                    - data_connector_height*0.31
            ])
                cube([
                    data_connector_width*0.78,
                    0.8,
                    data_connector_height*0.62
                ]);
    }


    module orientation_arrow() {
        color([0.85, 0.85, 0.85, 1])
            translate([
                width/2,
                mounting_plane_y_value + 0.3,
                height/2
            ])
                rotate([90, 0, 0])
                    linear_extrude(height=0.6)
                        polygon([
                            [-4, 18],
                            [ 4, 18],
                            [ 4, -5],
                            [10, -5],
                            [ 0, -18],
                            [-10, -5],
                            [-4, -5]
                        ]);
    }


    module power_connector_model() {
        color([0.05, 0.05, 0.05, 1])
            translate([
                power_connector_x
                    - power_connector_width_value/2,
                pcb_back_y + 1.0,
                power_connector_z
                    - power_connector_height_value/2
            ])
                cube([
                    power_connector_width_value,
                    power_connector_depth_value,
                    power_connector_height_value
                ]);

        for(pz=[-7.5, -2.5, 2.5, 7.5])
            color([0.45, 0.45, 0.42, 1])
                translate([
                    power_connector_x - 2.75,
                    pcb_back_y
                        + power_connector_depth_value
                        + 1.1,
                    power_connector_z
                        + pz
                        - 1.2
                ])
                    cube([
                        5.5,
                        0.7,
                        2.4
                    ]);
    }


    difference() {
        union() {
            // Front pixel housing
            color(front_color)
                cube([
                    width,
                    front_mask_depth_value,
                    height
                ]);

            // PCB
            color(pcb_color)
                translate([
                    0,
                    front_mask_depth_value,
                    0
                ])
                    cube([
                        width,
                        pcb_thickness_value,
                        height
                    ]);

            // Rear structural housing
            rear_frame_structure();

            if(show_connectors) {
                hub75_data_connector(
                    data_connector_z_bottom
                );

                hub75_data_connector(
                    data_connector_z_top
                );

                power_connector_model();
            }

            if(show_orientation)
                orientation_arrow();
        }

        // Six mounting holes through the complete model
        for(x=hole_x_positions)
            for(z=hole_z_positions)
                translate([
                    x,
                    -0.5,
                    z
                ])
                    rotate([-90, 0, 0])
                        cylinder(
                            h=max_depth_value + 1.0,
                            d=hole_diameter_value,
                            $fn=30
                        );
    }
}


// -----------------------------------------------------------------------------
// Standalone preview
// -----------------------------------------------------------------------------

hub75_panel(
    show_orientation=preview_show_orientation,
    show_connectors=preview_show_connectors,

    body_color=
        preview_body_color(
            preview_color_scheme
        ),

    front_color=
        preview_front_color(
            preview_color_scheme
        ),

    pcb_color=preview_pcb_color,
    connector_color=preview_connector_color
);
