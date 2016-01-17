/*******************************************************
*     Based on:
*     FB Aka HeartyGFX 2016
*     http://heartygfx.blogspot.com
*     OpenScad Parametric Box
********************************************************/

use <vitamins/hd44780.scad>
use <vitamins/gx16.scad>


include <conf/config.scad>

////////////////// - Box parameters - //////////////////////

//Back panel  
BPanel=1;// [0:No, 1:Yes]
//Front panel
FPanel=1;// [0:No, 1:Yes]
//Half shell
BShell=1;// [0:No, 1:Yes]
//Top shell
TShell=1;// [0:No, 1:Yes]
//- Front text
Text=1;// [0:No, 1:Yes]
  
/* [Hidden] */
// - Shell color  
  Color1 = [1,0.2,0];       
// - Panels color    
  Color2 = "Black";    



/////////// - Generic rounded box - //////////

module RoundBox($a=main_box_length, $b=main_box_width, $c=main_box_height){// Cube bords arrondis
                    $fn=main_box_resolution;            
                    translate([0,main_box_roundness,main_box_roundness]){  
                    minkowski (){                                              
                        cube ([$a-(main_box_length/2),$b-(2*main_box_roundness),$c-(2*main_box_roundness)], center = false);
                        rotate([0,90,0]){    
                        cylinder(r=main_box_roundness,h=main_box_length/2, center = false);
                            } 
                        }
                    }
                }// End of RoundBox Module

      
////////////////////////////////// - Module Shell - //////////////////////////////////         
module Shell( top = 0){//Coque - Shell  
    main_box_thickness = main_box_thickness*2;  
    difference(){    
        difference(){//sides decoration
            union(){    
                     difference() {//soustraction de la forme centrale - Substraction rounded box
                      
                        difference(){//soustraction cube median - Median cube slicer
                            union() {//union               
                            difference(){//Coque    
                                RoundBox();
                                translate([main_box_thickness/2,main_box_thickness/2,main_box_thickness/2]){     
                                        RoundBox($a=main_box_length-main_box_thickness, $b=main_box_width-main_box_thickness, $c=main_box_height-main_box_thickness);
                                        }
                                        }//Fin diff Coque                            
                                difference(){//largeur Rails        
                                     translate([main_box_thickness+m,main_box_thickness/2,main_box_thickness/2]){// Rails
                                          RoundBox($a=main_box_length-((2*main_box_thickness)+(2*m)), $b=main_box_width-main_box_thickness, $c=main_box_height-(main_box_thickness*2));
                                                          }//fin Rails
                                     translate([((main_box_thickness+m/2)*1.55),main_box_thickness/2,main_box_thickness/2]){
                                          RoundBox($a=main_box_length-((main_box_thickness*3)+2*m), $b=main_box_width-main_box_thickness, $c=main_box_height-main_box_thickness);
                                                    }           
                                                }//Fin largeur Rails
                                    }//Fin union                                   
                               translate([-main_box_thickness,-main_box_thickness,main_box_height/2]){// Cube à soustraire
                                    cube ([main_box_length+100, main_box_width+100, main_box_height], center=false);
                                            }                                            
                                      }//fin soustraction cube median - End Median cube slicer
                               translate([-main_box_thickness/2,main_box_thickness,main_box_thickness]){// Forme de soustraction centrale 
                                    RoundBox($a=main_box_length+main_box_thickness, $b=main_box_width-main_box_thickness*2, $c=main_box_height-main_box_thickness);       
                                    }                          
                                }                                          


                difference(){// Fixation box legs
                    union(){
                        translate([3.9*main_box_thickness,main_box_thickness,main_box_height/2]){
                            rotate([90,0,0]){
                                    $fn=6;
                                    cylinder(d=16,main_box_thickness/2);
                                    }   
                            }
                            
                       translate([main_box_length-3.9*main_box_thickness,main_box_thickness,main_box_height/2]){
                            rotate([90,0,0]){
                                    $fn=6;
                                    cylinder(d=16,main_box_thickness/2);
                                    }   
                            }

                        }
                            translate([4,main_box_thickness+main_box_roundness,main_box_height/2-57]){   
                             rotate([45,0,0]){
                                   cube([main_box_length,40,40]);    
                                  }
                           }
                           translate([0,-(main_box_thickness*1.46),main_box_height/2]){
                                cube([main_box_length,main_box_thickness*2,10]);
                           }
                    } //Fin fixation box legs
            }

        union(){// outbox sides decorations //todo: make slots for just one half
            slot = main_box_top_slots * top;
            for(i=[0:main_box_thickness + slot/2:main_box_length/4]){
                for(j=[0,-1]){
                    x = (abs(10 - main_box_length * -j)) + i + 2*i*j;
                    translate([x ,main_box_width-0.6 - slot,0]){
                        cube([3,main_box_thickness + slot,main_box_height/4]);
                    }  
                    
                    translate([x ,-main_box_thickness+0.6,0]){
                        cube([3,main_box_thickness + slot,main_box_height/4]);
                    } 
                 }   
             }// fin de for
        }//fin union decoration
     }//fin difference decoration


            union(){ //sides holes
                $fn=50;
                translate([2.6*main_box_thickness+5,20,main_box_height/2+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([main_box_length-(3.9*main_box_thickness),20,main_box_height/2+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([2.6*main_box_thickness+5,main_box_width+5,main_box_height/2-4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([main_box_length-(3.9*main_box_thickness),main_box_width+5,main_box_height/2-4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
            }//fin de sides holes

        }//fin de difference holes
}// fin coque 

////////////////////////////// - Experiment - ///////////////////////////////////////////
          


///////////////////////////////// - Module Front/Back Panels - //////////////////////////
                            
module Panels(){//Panels
    color(Color2){
        translate([main_box_thickness+m,m/2,m/2]){
             difference(){
                  translate([0,main_box_thickness,main_box_thickness]){ 
                     RoundBox(main_box_length,main_box_width-((main_box_thickness*2)+m),main_box_height-((main_box_thickness*2)+m));}
                  translate([main_box_thickness,-5,0]){
                     cube([main_box_length,main_box_width+10,main_box_height]);}
                     }
                }
         }
}


///////////////////////////////////// - Main - ///////////////////////////////////////
module box(){
    if(BPanel==1)
    //Back Panel
    translate ([-m/2,0,0]){
        difference(){
            Panels();
            
            //cables
            rotate([0,-90,0]) translate([(main_box_height)/4,(main_box_width)/1.1,-5]) cylinder(r=3, h=5);
            
            //power plug
            rotate([0,-90,0]) translate([(main_box_height - power_plug_height)/2,(main_box_width - power_plug_width)/10,-5]) cube([power_plug_height, power_plug_width, 3]);
        }
    }
    if(FPanel==1)
    //Front Panel
    rotate([0,0,180]){
        translate([-main_box_length-m/2,-main_box_width,0]){   
            difference(){
                Panels();
                //display
                rotate([0,-90,0]) translate([(main_box_height-display_height)/2,(main_box_width-display_width)/1.25,-6]) cube([display_height + m, display_width + m, 5]);
                //plug
                rotate([0,-90,0]) translate([(main_box_height)/4,(main_box_width)/10,-5]) cylinder(r=8 + m, h=5);
                //button
                rotate([0,-90,0]) translate([(main_box_height)/1.5,(main_box_width)/8,-5]) cylinder(r=3 + m, h=5);
            }
           }
       }

    if(Text==1)
    // Front text
    color(Color1){     
         translate([main_box_length-(main_box_thickness),main_box_thickness*4,(main_box_height-(main_box_thickness*4+(main_box_font_size/2)))]){// x,y,z
              rotate([90,0,90]){
                  linear_extrude(height = layer_height * main_box_font_layers){
                  text(main_box_text, font = str(main_box_font, ":style=",  main_box_font_style), size = main_box_font_size,  valign ="center", halign ="left");
                            }
                     }
             }
    }


    if(BShell==1)
    // Bottom shell
    color(Color1){ 
    Shell();
    }


    if(TShell==1)
    // Top Shell
    color( Color1,1){
        translate([0,main_box_width,main_box_height+0.2]){
            rotate([0,180,180]){
                    Shell(1);
                    }
            }
    }
}

module box_assembly(){
    box();
    rotate([0,0,180]){
        translate([-main_box_length-m/2,-main_box_width,0]){ 
                rotate([0,-90,0]) translate([(main_box_height-display_pcb_height)/1.93,(main_box_width-display_pcb_width)/1.215,-display_depth - 1])display(); //TODO: fix position
                color("Silver") rotate([0,-90,0]) translate([(main_box_height)/4,(main_box_width)/10,-10]) gx16();
                color("White") rotate([0,-90,0]) translate([(main_box_height)/1.5,(main_box_width)/8,-5]) cylinder(r=5 + m, h=10, $fn=32);
        }
    }
    
    
}

module box_stl(){
    if(TShell == 1){
        rotate([0,180,0]) box();
    }
    else if (Text == 1 || FPanel ==1 || BPanel == 1){
        rotate([0,-90,0]) box();
    }
    else {
        box();
    }
}

if(make_stl == 1){
    box_stl();
}
else {
    box_assembly();
}
