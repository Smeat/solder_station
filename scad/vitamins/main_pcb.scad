include <../conf/config.scad>

main_pcb_width = 64;
main_pcb_height = 67;

main_pcb_hole1_offset_x = 5;
main_pcb_hole1_offset_y = 5;

main_pcb_hole2_offset_x = 5;
main_pcb_hole2_offset_y = 5;

main_pcb_hole3_offset_x = 5;
main_pcb_hole3_offset_y = 5;


module main_pcb_holes(){
    translate([main_pcb_hole1_offset_x,main_pcb_hole1_offset_y,-2]) cylinder(r=1.5, h=5, $fn=32);
    
    translate([main_pcb_width + 3 - main_pcb_hole2_offset_x,main_pcb_hole2_offset_y,-2]) cylinder(r=1.5, h=5, $fn=32);
    
    
    translate([ main_pcb_hole3_offset_x, main_pcb_height - 3 - main_pcb_hole3_offset_y,-2]) cylinder(r=1.5, h=5, $fn=32);
}

module main_pcb(){
    difference(){
        cube([main_pcb_height,main_pcb_width,1.5]);
        main_pcb_holes(); 
    }
}

main_pcb();