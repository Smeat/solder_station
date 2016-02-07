include <../conf/config.scad>


module power_pcb_holes(){
       for(i = [0,1]){
            for(j = [0,1]){
                translate([(power_pcb_height) * i + power_pcb_hole_dist*(i ? -1 : 1),power_pcb_width * j + power_pcb_hole_dist*(j ? -1 : 1),-2.5]) cylinder(r=1.5, h= 5, $fn=32);
                
            }
        }
}


module power_pcb(){
   difference(){
        cube([power_pcb_height,power_pcb_width,28]);
        power_pcb_holes();
    }
}

power_pcb();