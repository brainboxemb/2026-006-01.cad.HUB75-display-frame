// Generic visual reference grid helper.
//
// Intended for diagnostic/model-inspection views only.  A view chooses the
// plane position and visible X/Z extents; the grid itself is not tied to a
// HUB75 panel and can therefore be reused by future fit/debug views.
module reference_grid_xz(
    width,
    height,
    y,
    major=10,
    show_half=true,
    depth=0.12,
    minor_line_width=0.18,
    major_line_width=0.28,
    axis_line_width=0.45
) {
    half = major / 2;

    module grid_v(x, w, c)
        color(c)
            translate([x-w/2, y, -height/2])
                cube([w, depth, height]);

    module grid_h(z, w, c)
        color(c)
            translate([-width/2, y, z-w/2])
                cube([width, depth, w]);

    if(show_half) {
        for(x=[-floor((width/2)/half)*half : half : floor((width/2)/half)*half])
            if(abs(x) > 0.001 && abs((x/major)-round(x/major)) > 0.001)
                grid_v(x, minor_line_width, [0.15,0.35,0.85,0.35]);

        for(z=[-floor((height/2)/half)*half : half : floor((height/2)/half)*half])
            if(abs(z) > 0.001 && abs((z/major)-round(z/major)) > 0.001)
                grid_h(z, minor_line_width, [0.15,0.35,0.85,0.35]);
    }

    for(x=[-floor((width/2)/major)*major : major : floor((width/2)/major)*major])
        if(abs(x) > 0.001)
            grid_v(x, major_line_width, [0.10,0.25,0.75,0.55]);

    for(z=[-floor((height/2)/major)*major : major : floor((height/2)/major)*major])
        if(abs(z) > 0.001)
            grid_h(z, major_line_width, [0.10,0.25,0.75,0.55]);

    grid_v(0, axis_line_width, [0.90,0.10,0.10,0.85]);
    grid_h(0, axis_line_width, [0.90,0.10,0.10,0.85]);
}

// 2D companion of the X/Z inspection grid above.
//
// This deliberately lives in the SAME shared grid library as
// reference_grid_xz(), so standalone engineering-reference drawings and the
// normal 3D inspection views use one grid implementation/convention.
// In a 2D reference drawing OpenSCAD X maps to project X and OpenSCAD Y maps
// to project Z.
module reference_grid_2d(
    width,
    height,
    major=10,
    show_half=true,
    minor_line_width=0.12,
    major_line_width=0.22,
    axis_line_width=0.40
) {
    half = major / 2;

    module grid_v(x, w)
        translate([x-w/2, -height/2]) square([w, height]);

    module grid_h(y, w)
        translate([-width/2, y-w/2]) square([width, w]);

    if(show_half) {
        for(x=[-floor((width/2)/half)*half : half : floor((width/2)/half)*half])
            if(abs(x) > 0.001 && abs((x/major)-round(x/major)) > 0.001)
                grid_v(x, minor_line_width);

        for(y=[-floor((height/2)/half)*half : half : floor((height/2)/half)*half])
            if(abs(y) > 0.001 && abs((y/major)-round(y/major)) > 0.001)
                grid_h(y, minor_line_width);
    }

    for(x=[-floor((width/2)/major)*major : major : floor((width/2)/major)*major])
        if(abs(x) > 0.001)
            grid_v(x, major_line_width);

    for(y=[-floor((height/2)/major)*major : major : floor((height/2)/major)*major])
        if(abs(y) > 0.001)
            grid_h(y, major_line_width);

    grid_v(0, axis_line_width);
    grid_h(0, axis_line_width);
}
