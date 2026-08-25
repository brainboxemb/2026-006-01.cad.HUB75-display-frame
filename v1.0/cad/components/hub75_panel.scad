// HUB75 display case component: hub75_panel
include <../config/project_config.scad>

module hub75_connector_model(x,z,label_text="") {
    color([0.08,0.08,0.08,1])
        translate([x,panel_thickness+0.2,z])
            cube([18,5,11],center=true);

}

module orientatie_pijl() {
    // Base orientation of panel 1, viewed from the rear:
    // IN at the top, OUT at the bottom, so data flows downward.
    // Each following panel is rotated 180 degrees.
    color([0.85,0.85,0.85,1])
    translate([panel_width/2,panel_thickness+0.5,panel_height/2])
    rotate([90,0,0])
    linear_extrude(height=0.8)
        polygon([
            [-4,18],
            [ 4,18],
            [ 4,-5],
            [10,-5],
            [ 0,-18],
            [-10,-5],
            [-4,-5]
        ]);
}

module panel_number_model(n, show_number=true) {
    if(show_number)
        color([1.0,0.75,0.1,1])
        translate([panel_width/2,panel_thickness+0.6,panel_height/2+35])
        rotate([90,0,0])
        linear_extrude(height=0.9)
            text(str(n),size=20,halign="center",valign="center");
}

module power_connector_model(x,z) {
    // Vereenvoudigde verticale 4-polige voedingsconnector.
    color([0.05,0.05,0.05,1])
        translate([x,panel_thickness+0.4,z])
            cube([
                power_connector_width,
                power_connector_depth,
                power_connector_height
            ],center=true);

    // Four vertical contact openings.
    for(pz=[-7.5,-2.5,2.5,7.5])
        color([0.45,0.45,0.42,1])
            translate([x,panel_thickness+power_connector_depth+0.2,z+pz])
                cube([5.5,0.8,2.4],center=true);
}

module rear_text(x,z,content,size=7,color_value=[0.95,0.95,0.95,1]) {
    color(color_value)
    translate([x,panel_thickness+7,z])
    rotate([90,0,0])
    mirror([1,0,0])
    linear_extrude(height=0.9)
        text(content,size=size,halign="center",valign="center");
}

module panel_3d(chain_number=1, show_orientation=true) {
    verschil_start = 3;
    difference() {
        union() {
            color([0.015,0.015,0.015,1]) translate([1,0,1]) cube([panel_width-2,1.5,panel_height-2]);
            color(color_pcb) translate([0,1.5,0]) cube([panel_width,1.5,panel_height]);
            color(color_panel) {
                difference() {
                    translate([0,3,0]) cube([panel_width,panel_thickness-3,panel_height]);
                    translate([3,2.9,3]) cube([panel_width-6,panel_thickness,panel_height-6]);
                }
                for(x=[panel_width/4,panel_width/2,3*panel_width/4]) translate([x-1.5,3,0]) cube([3,panel_thickness-3,panel_height]);
                for(z=[panel_height/5,2*panel_height/5,3*panel_height/5,4*panel_height/5]) translate([0,3,z-1.5]) cube([panel_width,panel_thickness-3,3]);
                for(x=panel_hole_x) for(z=panel_hole_z)
                    translate([x,3,z]) rotate([-90,0,0]) cylinder(h=panel_thickness-3,d=10,$fn=24);
            }
            // Basisoriëntatie: IN top, OUT bottom.
            hub75_connector_model(panel_width/2,data_connector_z_top,"IN");
            hub75_connector_model(panel_width/2,data_connector_z_bottom,"OUT");
            power_connector_model(power_connector_x,power_connector_z);
            if(show_orientation) orientatie_pijl();
        }
        for(x=panel_hole_x) for(z=panel_hole_z)
            translate([x,-0.5,z]) rotate([-90,0,0]) cylinder(h=panel_thickness+1,d=panel_hole_diameter,$fn=24);
    }
}

/* [Standalone preview] */
preview_chain_number = 1; // [1:5]
preview_orientation = true;
panel_3d(preview_chain_number, preview_orientation);
