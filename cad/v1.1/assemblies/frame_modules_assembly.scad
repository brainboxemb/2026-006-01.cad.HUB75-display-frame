// HUB75 display frame - V1.1 printed frame-module assembly
//
// Ten modules use 160 x 160 mm nominal origins to form an 800 x 320 mm grid.
// Internal joints are deliberately asymmetric: the female/pocket side owns
// 5 mm across the nominal grid line. The male side is cut back by 5 mm and its
// puzzle keys span the full 10 mm joint region.
// The outside edge stays available for the later visible border. The top and
// bottom rows extend straight beyond the panel edges and end in integrated
// snap clips for continuous aluminium tubes.

include <../config/project_config.scad>
use <../components/frame_module.scad>

module frame_modules_assembly(yshift=0, explode_gap=0) {
    grid_center_column = (frame_grid_columns - 1) / 2;
    grid_center_row = (frame_grid_rows - 1) / 2;

    for(column=[0:frame_grid_columns-1])
        for(row_index=[0:frame_grid_rows-1]) {
            is_left = column == 0;
            is_right = column == frame_grid_columns-1;
            is_bottom = row_index == 0;
            is_top = row_index == frame_grid_rows-1;

            // Four related red shades are repeated as a 2 x 2 pattern.
            // In the usual rear view this reads as:
            //   R1 R2 R1 R2 R1
            //   R3 R4 R3 R4 R3
            module_color = row_index == frame_grid_rows-1
                ? (column % 2 == 0 ? color_frame_module_r1 : color_frame_module_r2)
                : (column % 2 == 0 ? color_frame_module_r3 : color_frame_module_r4);

            // In exploded view the tiles fan out from the centre of the 5 x 2
            // grid. This exposes the dovetail edges without changing the normal
            // assembly coordinates.
            explode_x = (column - grid_center_column) * explode_gap;
            explode_z = (row_index - grid_center_row) * explode_gap;

            translate([
                column * frame_module_size + explode_x,
                frame_module_y + yshift,
                row_index * frame_module_size + explode_z
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
preview_explode_gap = 0; // [0:2:30]
frame_modules_assembly(explode_gap=preview_explode_gap);
