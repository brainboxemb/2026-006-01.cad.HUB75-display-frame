// Shared 2D profile geometry for HUB75 V1.2 printed couplers.
//
// The middle PLUS and edge T use the same profile generator.  Arm thickness
// and, where necessary, arm position are supplied by the caller from the
// actual HUB75 rib geometry.

// Shared design specification for the V1.2 project coupler family.
// These are component-family properties, not project/assembly configuration.
function coupler_base_thickness_default() = 4.0;
function coupler_wall_thickness_default() = 5.0;
function coupler_fit_clearance_default() = 0.50;
function coupler_profile_size_default() = 100.0;
function coupler_profile_inside_radius_default() = 10.0;
function coupler_profile_outside_radius_default() = 6.0;
function coupler_guide_height_default() = 10.0;
function coupler_guide_end_rounding_default() = 1.5;
function coupler_screw_hole_diameter_default() = 3.4;
function coupler_reference_pocket_diameter_default() = 3.0;
function coupler_reference_pocket_depth_default() = 2.5;
function coupler_bushing_clearance_default() = 0.45;
function coupler_locator_pin_clearance_default() = 0.40;
function coupler_seam_wedge_width_default() = 3.0;
function coupler_seam_wedge_height_default() = 4.0;
function coupler_profile_side_material_default() = coupler_wall_thickness_default() + coupler_fit_clearance_default();

// Male locating interface for the panel's flush reinforcement bushing.
// The circular pad enters the recessed pocket and the centre pin enters the
// small blind hole.  These clearances are printable coupler choices; the
// mating dimensions themselves remain authoritative in hub75_panel.scad.
function coupler_reinforcement_pad_radial_clearance_default() = 0.30;
function coupler_reinforcement_pad_axial_clearance_default() = 0.10;
function coupler_reinforcement_pin_radial_clearance_default() = 0.20;
function coupler_reinforcement_pin_length_default() = 2.0;

module coupler_reinforcement_locator_y(
    recess_diameter,
    recess_depth,
    hole_diameter,
    pad_radial_clearance=coupler_reinforcement_pad_radial_clearance_default(),
    pad_axial_clearance=coupler_reinforcement_pad_axial_clearance_default(),
    pin_radial_clearance=coupler_reinforcement_pin_radial_clearance_default(),
    pin_length=coupler_reinforcement_pin_length_default(),
    fn=64
) {
    pad_d = max(0.2, recess_diameter - 2*pad_radial_clearance);
    pad_h = max(0.2, recess_depth - pad_axial_clearance);
    pin_d = max(0.2, hole_diameter - 2*pin_radial_clearance);

    // Local mounting plane is Y=0. Negative Y points into the panel.
    rotate([90,0,0])
        cylinder(d=pad_d, h=pad_h, $fn=fn);

    translate([0,-pad_h,0])
        rotate([90,0,0])
            cylinder(d=pin_d, h=pin_length, $fn=fn);
}

function coupler_profile_horizontal_arm_height_default() = 36.0;
function coupler_profile_vertical_arm_width_default() = 38.0;

// Shared decorative pocket raster defaults.  Keep these in the library so
// components opened standalone do not depend on project_config.scad scope.
function coupler_reference_pocket_pitch_default() = 10.0;
// By default the transverse lanes are derived from the actual arm thickness:
// approximately the 1/4 and 3/4 positions, snapped to a 2.5 mm grid.
// Supplying a numeric lane_offset still acts as an explicit override.
function coupler_reference_pocket_lane_offset_default() = undef;
function coupler_reference_pocket_lane_grid_default() = 2.5;
function coupler_reference_pocket_lane_fraction_default() = 0.25;
function coupler_reference_pocket_steps_default() = [2, 3, 4];
// Arms narrower than this use one centred pocket lane instead of forcing a
// 2 x 3 pattern into a narrow strip.  Wider arms keep two lanes at roughly
// the 1/4 and 3/4 positions.
function coupler_reference_two_lane_min_arm_default() = 30.0;
function coupler_reference_lane_signs_for_arm(
    arm_thickness,
    min_two_lane_arm=coupler_reference_two_lane_min_arm_default()
) = arm_thickness >= min_two_lane_arm ? [-1,1] : [0];

function coupler_reference_lane_offset_for_arm(
    arm_thickness,
    grid=coupler_reference_pocket_lane_grid_default(),
    fraction=coupler_reference_pocket_lane_fraction_default()
) = max(grid, round((arm_thickness*fraction)/grid)*grid);

module coupler_plus_profile_2d(
    width = coupler_profile_size_default(),
    height = coupler_profile_size_default(),
    horizontal_arm_height = coupler_profile_horizontal_arm_height_default(),
    vertical_arm_width = coupler_profile_vertical_arm_width_default(),
    inside_radius = coupler_profile_inside_radius_default(),
    outside_radius = coupler_profile_outside_radius_default(),
    horizontal_arm_center_z = 0,
    vertical_arm_center_x = 0
) {
    hw = width/2;
    hh = height/2;
    vx_left = vertical_arm_center_x - vertical_arm_width/2;
    vx_right = vertical_arm_center_x + vertical_arm_width/2;
    z_top = horizontal_arm_center_z + horizontal_arm_height/2;
    z_bot = horizontal_arm_center_z - horizontal_arm_height/2;

    ir = min(inside_radius,
             min(
                 min(hw-vx_right, vx_left+hw),
                 min(hh-z_top, z_bot+hh)
             ) - 0.01);
    or = min(outside_radius,
             min(vertical_arm_width, horizontal_arm_height)/2 - 0.01);
    steps = 20;

    pts = concat(
        [[vx_left+or, hh], [vx_right-or, hh]],
        [for (a=[90 : -90/steps : 0]) [vx_right-or + or*cos(a), hh-or + or*sin(a)]],
        [[vx_right, z_top+ir]],
        [for (a=[180 : 90/steps : 270]) [vx_right+ir + ir*cos(a), z_top+ir + ir*sin(a)]],
        [[hw-or, z_top]],
        [for (a=[90 : -90/steps : 0]) [hw-or + or*cos(a), z_top-or + or*sin(a)]],
        [[hw, z_bot+or]],
        [for (a=[0 : -90/steps : -90]) [hw-or + or*cos(a), z_bot+or + or*sin(a)]],
        [[vx_right+ir, z_bot]],
        [for (a=[90 : 90/steps : 180]) [vx_right+ir + ir*cos(a), z_bot-ir + ir*sin(a)]],
        [[vx_right, -hh+or]],
        [for (a=[0 : -90/steps : -90]) [vx_right-or + or*cos(a), -hh+or + or*sin(a)]],
        [[vx_left+or, -hh]],
        [for (a=[-90 : -90/steps : -180]) [vx_left+or + or*cos(a), -hh+or + or*sin(a)]],
        [[vx_left, z_bot-ir]],
        [for (a=[0 : 90/steps : 90]) [vx_left-ir + ir*cos(a), z_bot-ir + ir*sin(a)]],
        [[-hw+or, z_bot]],
        [for (a=[-90 : -90/steps : -180]) [-hw+or + or*cos(a), z_bot+or + or*sin(a)]],
        [[-hw, z_top-or]],
        [for (a=[180 : -90/steps : 90]) [-hw+or + or*cos(a), z_top-or + or*sin(a)]],
        [[vx_left-ir, z_top]],
        [for (a=[-90 : 90/steps : 0]) [vx_left-ir + ir*cos(a), z_top+ir + ir*sin(a)]],
        [[vx_left, hh-or]],
        [for (a=[180 : -90/steps : 90]) [vx_left+or + or*cos(a), hh-or + or*sin(a)]]
    );

    polygon(points=pts);
}

// Canonical top T: retain the complete horizontal arm and the inward vertical
// arm of the shared PLUS.  The horizontal arm may be offset from the screw-row
// origin, which is required because the physical HUB75 end rail is not centred
// on the edge mounting-hole row.
module coupler_t_profile_2d(
    direction = "top",
    width = coupler_profile_size_default(),
    height = coupler_profile_size_default(),
    horizontal_arm_height = coupler_profile_horizontal_arm_height_default(),
    vertical_arm_width = coupler_profile_vertical_arm_width_default(),
    inside_radius = coupler_profile_inside_radius_default(),
    outside_radius = coupler_profile_outside_radius_default(),
    horizontal_arm_center_z = 0
) {
    hw = width/2;
    hh = height/2;
    z_top = horizontal_arm_center_z + horizontal_arm_height/2;
    z_bot = horizontal_arm_center_z - horizontal_arm_height/2;
    eps = 1;

    intersection() {
        coupler_plus_profile_2d(
            width=width,
            height=height,
            horizontal_arm_height=horizontal_arm_height,
            vertical_arm_width=vertical_arm_width,
            inside_radius=inside_radius,
            outside_radius=outside_radius,
            horizontal_arm_center_z=horizontal_arm_center_z
        );

        if (direction == "top")
            translate([-hw-eps, -hh-eps])
                square([width+2*eps, z_top+hh+2*eps], center=false);
        else
            translate([-hw-eps, z_bot-eps])
                square([width+2*eps, hh-z_bot+2*eps], center=false);
    }
}

// Corner edge profile: same rounded PLUS language, cropped around one outer
// panel corner.  Kept centred for now; local corner reliefs remain handled by
// the corner component itself.
module coupler_corner_profile_2d(
    side = "left",
    direction = "top",
    width = coupler_profile_size_default(),
    height = coupler_profile_size_default(),
    horizontal_arm_height = coupler_profile_horizontal_arm_height_default(),
    vertical_arm_width = coupler_profile_vertical_arm_width_default(),
    inside_radius = coupler_profile_inside_radius_default(),
    outside_radius = coupler_profile_outside_radius_default(),
    outward_x = 27.0,
    outward_z = 27.0,
    horizontal_arm_center_z = 0,
    vertical_arm_center_x = 0
) {
    hw = width/2;
    hh = height/2;
    eps = 1;

    xmin = side == "left" ? -outward_x : -hw-eps;
    xmax = side == "left" ?  hw+eps     :  outward_x;
    zmin = direction == "top" ? -hh-eps : -outward_z;
    zmax = direction == "top" ?  outward_z : hh+eps;

    intersection() {
        coupler_plus_profile_2d(
            width=width,
            height=height,
            horizontal_arm_height=horizontal_arm_height,
            vertical_arm_width=vertical_arm_width,
            inside_radius=inside_radius,
            outside_radius=outside_radius,
            horizontal_arm_center_z=horizontal_arm_center_z,
            vertical_arm_center_x=vertical_arm_center_x
        );

        translate([xmin, zmin])
            square([xmax-xmin, zmax-zmin], center=false);
    }
}




// Shared STEP-inspired decorative pocket placement. Pocket centres use the
// same 5/10 mm reference system as the centre marks. The caller supplies the
// transverse lane offset, allowing each coupler arm to place its two columns
// at roughly 1/3 and 2/3 of the available arm width instead of using a fixed
// offset.
//
// axis: "x" places a strip along X, "z" along Z.
// direction_sign selects the arm direction. lane_signs selects one or both
// parallel lanes. Fractional step values are allowed (e.g. 2.5 = 25 mm on a
// 10 mm pitch).
module coupler_reference_pocket_strip_2d(
    axis="x",
    direction_sign=1,
    lane_signs=[-1,1],
    steps=[3,4],
    pitch=10.0,
    hole_d=3.0,
    lane_offset=undef,
    fn=48
) {
    lane_distance = is_undef(lane_offset) ? pitch/2 : lane_offset;

    for (step=steps)
        for (lane=lane_signs) {
            if (axis == "x")
                translate([direction_sign*step*pitch, lane*lane_distance])
                    circle(d=hole_d, $fn=fn);
            else
                translate([lane*lane_distance, direction_sign*step*pitch])
                    circle(d=hole_d, $fn=fn);
        }
}

// Shared screw-hole cutter with a small anti-elephant-foot relief on both
// faces of the base plate. The through bore remains cylindrical; only one
// print layer at each face is widened. This is a simple cylindrical relief,
// not a conical countersink.
function coupler_screw_relief_depth_default() = 0.20;
function coupler_screw_relief_radial_default() = 0.40;

module coupler_screw_hole_y(
    hole_diameter,
    plate_thickness,
    through_front_extra=0,
    relief_depth=coupler_screw_relief_depth_default(),
    relief_radial=coupler_screw_relief_radial_default(),
    fn=48
) {
    eps = 0.05;
    relief_d = hole_diameter + 2*relief_radial;
    rd = min(relief_depth, plate_thickness/2 - 0.05);

    // Main cylindrical bore. Axis runs from the visible rear face (+Y)
    // through the plate and optionally farther toward the panel (-Y).
    translate([0, plate_thickness + 0.25, 0])
        rotate([90,0,0])
            cylinder(
                d=hole_diameter,
                h=plate_thickness + through_front_extra + 0.50,
                $fn=fn
            );

    if (rd > 0 && relief_radial > 0) {
        // Rear/bed-side relief: one shallow cylindrical widened layer.
        translate([0, plate_thickness + eps, 0])
            rotate([90,0,0])
                cylinder(
                    h=rd + eps,
                    d=relief_d,
                    $fn=fn
                );

        // Panel-side relief: same shallow cylindrical widened layer.
        translate([0, rd, 0])
            rotate([90,0,0])
                cylinder(
                    h=rd + eps,
                    d=relief_d,
                    $fn=fn
                );
    }
}


// Shared through-hole cutter with the same shallow anti-elephant-foot relief
// used for screw holes.  y_max/y_min define the two physical faces of the
// material being pierced; the widened relief is only one shallow print layer
// deep at each face.
module coupler_through_hole_y_with_relief(
    hole_diameter,
    y_max,
    y_min,
    relief_depth=coupler_screw_relief_depth_default(),
    relief_radial=coupler_screw_relief_radial_default(),
    fn=48
) {
    eps = 0.05;
    span = y_max - y_min;
    relief_d = hole_diameter + 2*relief_radial;
    rd = min(relief_depth, max(0, span/2 - eps));

    // Main bore, with a tiny overshoot so boolean subtraction is robust.
    translate([0, y_max + eps, 0])
        rotate([90,0,0])
            cylinder(d=hole_diameter, h=span + 2*eps, $fn=fn);

    if (rd > 0 && relief_radial > 0) {
        // Relief at the y_max face.
        translate([0, y_max + eps, 0])
            rotate([90,0,0])
                cylinder(d=relief_d, h=rd + eps, $fn=fn);

        // Relief at the y_min face.
        translate([0, y_min + rd, 0])
            rotate([90,0,0])
                cylinder(d=relief_d, h=rd + eps, $fn=fn);
    }
}

// Shared shallow centre-reference marks for the visible rear face of couplers.
// The marks are deliberately dashed rather than continuous so they remain a
// visual measuring aid without creating a long structural groove.  A shallow
// recess is also friendly to upside-down printing: it becomes a few small
// open-to-bed gaps instead of unsupported islands.
function coupler_center_mark_depth_default() = 0.40;
// Major marks are every full centimetre. Minor marks are halfway between.
function coupler_center_mark_pitch_default() = 10.0;
function coupler_center_mark_dash_length_default() = 4.0;
function coupler_center_mark_minor_length_default() = 2.2;
function coupler_center_mark_dash_width_default() = 0.8;
function coupler_center_mark_cross_length_default() = 6.0;
function coupler_center_mark_edge_margin_default() = 4.0;
// Radial material kept completely free of engraving around a screw hole.
function coupler_center_mark_screw_keepout_default() = 3.0;

module coupler_center_marks_2d(
    span_x=100,
    span_z=100,
    pitch=coupler_center_mark_pitch_default(),
    dash_length=coupler_center_mark_dash_length_default(),
    dash_width=coupler_center_mark_dash_width_default(),
    cross_length=coupler_center_mark_cross_length_default(),
    minor_length=coupler_center_mark_minor_length_default(),
    keepout_points=[],
    keepout_radius=0
) {
    difference() {
        union() {
            // Small cross at the local X/Z origin.
            square([cross_length, dash_width], center=true);
            square([dash_width, cross_length], center=true);

            // X-axis marks. The tick itself is perpendicular to the X axis.
            // Full centimetres are longer; half-centimetres are shorter.
            for (x=[pitch/2:pitch/2:span_x/2]) {
                major = abs((x/pitch) - round(x/pitch)) < 0.001;
                tick_len = major ? dash_length : minor_length;
                translate([ x,0]) square([dash_width,tick_len],center=true);
                translate([-x,0]) square([dash_width,tick_len],center=true);
            }

            // Z-axis marks, likewise perpendicular to the Z axis.
            for (z=[pitch/2:pitch/2:span_z/2]) {
                major = abs((z/pitch) - round(z/pitch)) < 0.001;
                tick_len = major ? dash_length : minor_length;
                translate([0, z]) square([tick_len,dash_width],center=true);
                translate([0,-z]) square([tick_len,dash_width],center=true);
            }
        }

        // Do not let a reference mark nick the load-bearing material around
        // a mounting screw. Callers supply actual screw centres and a radius
        // based on the real hole diameter plus a material margin.
        if (keepout_radius > 0)
            for (p=keepout_points)
                translate(p) circle(r=keepout_radius, $fn=48);
    }
}
