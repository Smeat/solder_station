include <../conf/config.scad>


solder_handle_radius =8;
solder_handle_length1 = 100;
solder_handle_length2 = 60;
solder_handle_length = solder_handle_length1 + solder_handle_length2;
solder_handle_end_radius = solder_handle_radius * 1.2;
solder_handle_end_width = 5;

solder_tip_radius = 5.5/2;
solder_tip_length = 139;

module tip(){
    color("Silver"){
        cylinder(r= solder_tip_radius, h = solder_tip_length, $fn=64);
        translate([0,0,solder_tip_length])cylinder(r=solder_tip_radius * 0.9, r2 = 0.2, h=12, $fn=64);
    }
}


module handle(){
    union(){
        color("Blue") cylinder(r=solder_handle_radius, h = solder_handle_length1);
        color("Black"){
            translate ([0,0,solder_handle_length1]) cylinder(r= solder_handle_radius, h = solder_handle_length2);
            translate ([0,0, solder_handle_length]) cylinder(r = solder_handle_end_radius, h = solder_handle_end_width);
        }
    }
    
}

module fx9501(){
    union(){
        handle();
        translate([0,0, solder_handle_length - 100])tip();
    }
}

fx9501();