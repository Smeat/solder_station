include <config.scad>

gx16_r = 8;
gx16_h = 15.5;

module gx16(){
    difference(){
        cylinder(r= 8, h=gx16_h, $fn=64);
        
        translate([0,0,gx16_h/2 + 0.1]) cylinder(r=7, h = gx16_h/2);
    }
    
    if(solder_plug_middle_pin == 1) translate([0,0,gx16_h/2 + 0.1]) cylinder(r=0.5, h=gx16_h/2 - 1, $fn=32);
    
    radius = 4;
    for(i = [0:solder_plug_pins - solder_plug_middle_pin - 1]){

        grad = i * (360/(solder_plug_pins - solder_plug_middle_pin));
        x = cos(grad) * radius;
        y = sin(grad) * radius;
        translate([x,y,gx16_h/2 + 0.1]) cylinder(r=0.5, h=gx16_h/2 - 1, $fn=32);
    }
    
    translate([-7,0,7.75]) cylinder(r=0.5, h= gx16_h/2, $fn=32);
}


gx16();