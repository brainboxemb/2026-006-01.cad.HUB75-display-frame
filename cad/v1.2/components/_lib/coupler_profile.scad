// Shared 2D profile geometry for HUB75 V1.2 printed couplers.
//
// The middle PLUS and edge T use the same profile generator.  Arm thickness
// and, where necessary, arm position are supplied by the caller from the
// actual HUB75 rib geometry.

function coupler_profile_size_default() = 100.0;
function coupler_profile_horizontal_arm_height_default() = 36.0;
function coupler_profile_vertical_arm_width_default() = 38.0;
function coupler_profile_inside_radius_default() = 10.0;
function coupler_profile_outside_radius_default() = 6.0;

module coupler_plus_profile_2d(
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
    vx = vertical_arm_width/2;
    z_top = horizontal_arm_center_z + horizontal_arm_height/2;
    z_bot = horizontal_arm_center_z - horizontal_arm_height/2;

    ir = min(inside_radius,
             min(hw-vx, min(hh-z_top, z_bot+hh)) - 0.01);
    or = min(outside_radius,
             min(vertical_arm_width, horizontal_arm_height)/2 - 0.01);
    steps = 20;

    pts = concat(
        [[-vx+or, hh], [vx-or, hh]],
        [for (a=[90 : -90/steps : 0]) [vx-or + or*cos(a), hh-or + or*sin(a)]],
        [[vx, z_top+ir]],
        [for (a=[180 : 90/steps : 270]) [vx+ir + ir*cos(a), z_top+ir + ir*sin(a)]],
        [[hw-or, z_top]],
        [for (a=[90 : -90/steps : 0]) [hw-or + or*cos(a), z_top-or + or*sin(a)]],
        [[hw, z_bot+or]],
        [for (a=[0 : -90/steps : -90]) [hw-or + or*cos(a), z_bot+or + or*sin(a)]],
        [[vx+ir, z_bot]],
        [for (a=[90 : 90/steps : 180]) [vx+ir + ir*cos(a), z_bot-ir + ir*sin(a)]],
        [[vx, -hh+or]],
        [for (a=[0 : -90/steps : -90]) [vx-or + or*cos(a), -hh+or + or*sin(a)]],
        [[-vx+or, -hh]],
        [for (a=[-90 : -90/steps : -180]) [-vx+or + or*cos(a), -hh+or + or*sin(a)]],
        [[-vx, z_bot-ir]],
        [for (a=[0 : 90/steps : 90]) [-vx-ir + ir*cos(a), z_bot-ir + ir*sin(a)]],
        [[-hw+or, z_bot]],
        [for (a=[-90 : -90/steps : -180]) [-hw+or + or*cos(a), z_bot+or + or*sin(a)]],
        [[-hw, z_top-or]],
        [for (a=[180 : -90/steps : 90]) [-hw+or + or*cos(a), z_top-or + or*sin(a)]],
        [[-vx-ir, z_top]],
        [for (a=[-90 : 90/steps : 0]) [-vx-ir + ir*cos(a), z_top+ir + ir*sin(a)]],
        [[-vx, hh-or]],
        [for (a=[180 : -90/steps : 90]) [-vx+or + or*cos(a), hh-or + or*sin(a)]]
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
    outward_z = 27.0
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
            outside_radius=outside_radius
        );

        translate([xmin, zmin])
            square([xmax-xmin, zmax-zmin], center=false);
    }
}
