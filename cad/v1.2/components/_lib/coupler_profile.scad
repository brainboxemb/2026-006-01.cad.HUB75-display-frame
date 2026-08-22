// Shared 2D profile geometry for HUB75 V1.2 printed couplers.
//
// The middle PLUS and upper/lower T share one profile generator.
// The 100 mm envelope and fillet logic are shared; arm thicknesses are
// supplied by the caller from the actual HUB75 rib widths.

function coupler_profile_size_default() = 100.0;
function coupler_profile_horizontal_arm_height_default() = 36.0;
function coupler_profile_vertical_arm_width_default() = 38.0;
function coupler_profile_inside_radius_default() = 18.0;
function coupler_profile_outside_radius_default() = 12.0;

module coupler_plus_profile_2d(
    width = coupler_profile_size_default(),
    height = coupler_profile_size_default(),
    horizontal_arm_height = coupler_profile_horizontal_arm_height_default(),
    vertical_arm_width = coupler_profile_vertical_arm_width_default(),
    inside_radius = coupler_profile_inside_radius_default(),
    outside_radius = coupler_profile_outside_radius_default()
) {
    hw = width/2;
    hh = height/2;
    vx = vertical_arm_width/2;
    hy = horizontal_arm_height/2;

    ir = min(inside_radius, min(hw-vx, hh-hy) - 0.01);
    or = min(outside_radius, min(vertical_arm_width, horizontal_arm_height)/2 - 0.01);
    steps = 20;

    pts = concat(
        [[-vx+or, hh], [vx-or, hh]],
        [for (a=[90 : -90/steps : 0]) [vx-or + or*cos(a), hh-or + or*sin(a)]],
        [[vx, hy+ir]],
        [for (a=[180 : 90/steps : 270]) [vx+ir + ir*cos(a), hy+ir + ir*sin(a)]],
        [[hw-or, hy]],
        [for (a=[90 : -90/steps : 0]) [hw-or + or*cos(a), hy-or + or*sin(a)]],
        [[hw, -hy+or]],
        [for (a=[0 : -90/steps : -90]) [hw-or + or*cos(a), -hy+or + or*sin(a)]],
        [[vx+ir, -hy]],
        [for (a=[90 : 90/steps : 180]) [vx+ir + ir*cos(a), -hy-ir + ir*sin(a)]],
        [[vx, -hh+or]],
        [for (a=[0 : -90/steps : -90]) [vx-or + or*cos(a), -hh+or + or*sin(a)]],
        [[-vx+or, -hh]],
        [for (a=[-90 : -90/steps : -180]) [-vx+or + or*cos(a), -hh+or + or*sin(a)]],
        [[-vx, -hy-ir]],
        [for (a=[0 : 90/steps : 90]) [-vx-ir + ir*cos(a), -hy-ir + ir*sin(a)]],
        [[-hw+or, -hy]],
        [for (a=[-90 : -90/steps : -180]) [-hw+or + or*cos(a), -hy+or + or*sin(a)]],
        [[-hw, hy-or]],
        [for (a=[180 : -90/steps : 90]) [-hw+or + or*cos(a), hy-or + or*sin(a)]],
        [[-vx-ir, hy]],
        [for (a=[-90 : 90/steps : 0]) [-vx-ir + ir*cos(a), hy+ir + ir*sin(a)]],
        [[-vx, hh-or]],
        [for (a=[180 : -90/steps : 90]) [-vx+or + or*cos(a), hh-or + or*sin(a)]]
    );

    polygon(points=pts);
}

// Canonical top T: retain the complete horizontal arm and the lower vertical
// arm of the shared PLUS.  The bottom T is its exact mirror.
module coupler_t_profile_2d(
    direction = "top",
    width = coupler_profile_size_default(),
    height = coupler_profile_size_default(),
    horizontal_arm_height = coupler_profile_horizontal_arm_height_default(),
    vertical_arm_width = coupler_profile_vertical_arm_width_default(),
    inside_radius = coupler_profile_inside_radius_default(),
    outside_radius = coupler_profile_outside_radius_default()
) {
    hw = width/2;
    hh = height/2;
    hy = horizontal_arm_height/2;
    eps = 1;

    intersection() {
        coupler_plus_profile_2d(
            width=width,
            height=height,
            horizontal_arm_height=horizontal_arm_height,
            vertical_arm_width=vertical_arm_width,
            inside_radius=inside_radius,
            outside_radius=outside_radius
        );

        if (direction == "top")
            // Keep everything up to the outside edge of the horizontal bar.
            translate([-hw-eps, -hh-eps])
                square([width+2*eps, hh+hy+2*eps], center=false);
        else
            // Exact mirror for the lower edge coupler.
            translate([-hw-eps, -hy-eps])
                square([width+2*eps, hh+hy+2*eps], center=false);
    }
}


// Corner edge profile: exact same rounded PLUS language, cropped around one
// outer panel corner.  The screw row remains the local origin.  Inboard reach
// is one half of the shared 100 mm envelope; outward reach is limited by the
// caller so the printed part stays within the allowed display overhang.
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
