// HUB75 display case component: matrixportal_s3
include <../config/project_config.scad>

module matrixportal_s3_model() {
    color([0.10,0.24,0.38,1]) cube([esp_board_length,esp_board_thickness,esp_board_width]);
    color([0.65,0.67,0.70,1]) translate([-2.5,-1.2,esp_board_width/2-5]) cube([7,4,10]);
    color([0.12,0.12,0.12,1]) translate([8,esp_board_thickness,3]) cube([esp_board_length-25,5.5,esp_board_width-6]);
    // antenna zone on the outer right side
    color([0.82,0.65,0.22,1]) translate([esp_board_length-18,esp_board_thickness+0.1,4]) cube([16,0.8,esp_board_width-8]);
}

/* [Standalone preview] */
matrixportal_s3_model();
