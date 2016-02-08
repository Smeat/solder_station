include <../conf/config.scad>

lcd_width = 76;
lcd_height = 26;

module display_holes(){
    for(i = [0,1]){
        for(j = [0,1]){
                translate([display_pcb_height * j + 2 * (j ? -1 : 1),display_pcb_width * i + 2 * (i ? -1 : 1),-2]) cylinder(r=screw_radius, h=5, $fn=32);
        }
    }
    
}

module display(){
    // pcb
    difference(){
        color("Green")cube([display_pcb_height, display_pcb_width, 1]);
        display_holes();
    }

    //display
    translate([(display_pcb_height - display_height)/2, (display_pcb_width- display_width)/2, 1/2]){
        color("Black") cube([display_height, display_width, display_depth]);
        color("Blue") translate([(display_height - lcd_height)/2,(display_width - lcd_width)/2,display_depth - 0.9]) cube([lcd_height, lcd_width, 1]);
    }
    
    
}

display();
