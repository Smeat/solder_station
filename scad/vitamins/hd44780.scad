include <../conf/config.scad>

lcd_width = 76;
lcd_height = 26;

module display(){
    // pcb
    color("Green")cube([display_pcb_height, display_pcb_width, 1]);

    //display
    translate([(display_pcb_height - display_height)/2, (display_pcb_width- display_width)/2, 1/2]){
        color("Black") cube([display_height, display_width, display_depth]);
        color("Blue") translate([(display_height - lcd_height)/2,(display_width - lcd_width)/2,display_depth - 0.9]) cube([lcd_height, lcd_width, 1]);
    }
    
    
}

display();