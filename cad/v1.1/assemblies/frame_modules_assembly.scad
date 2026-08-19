// HUB75 display frame - V1.1 printed frame-module assembly
//
// Ten 160 x 160 mm modules form a nominal 800 x 320 mm grid behind the five
// HUB75 panels. Puzzle joints are used only between modules; the outside edge
// stays available for the later visible border. The top and bottom rows extend straight beyond the panel edges and end
// in integrated snap clips for continuous aluminium tubes.

include <../config/project_config.scad>
use <../components/frame_module.scad>

module frame_modules_assembly(yshift=0) {
    for(column=[0:frame_grid_columns-1])
        for(row_index=[0:frame_grid_rows-1]) {
            is_left = column == 0;
            is_right = column == frame_grid_columns-1;
            is_bottom = row_index == 0;
            is_top = row_index == frame_grid_rows-1;

            // Checkerboard red shades are used only to make the individual
            // printed modules easier to distinguish in the assembly view.
            visual_row = frame_grid_rows - 1 - row_index;
            module_color = ((column + visual_row) % 2 == 0)
                ? color_frame_module_r1
                : color_frame_module_r2;

            translate([
                column * frame_module_size,
                frame_module_y + yshift,
                row_index * frame_module_size
            ])
                frame_module(
                    row = row_index == 0 ? "lower" : "upper",
                    left_edge = is_left ? "none" : "female",
                    right_edge = is_right ? "none" : "male",
                    bottom_edge = is_bottom ? "none" : "female",
                    top_edge = is_top ? "none" : "male",
                    tube_clip_edge = is_top ? "top" : (is_bottom ? "bottom" : "none"),
                    module_color = module_color
                );
        }
}

/* [Preview] */
frame_modules_assembly();
