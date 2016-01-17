/*******************************************************
*     Based on:
*     FB Aka HeartyGFX 2016
*     http://heartygfx.blogspot.com
*     OpenScad Parametric Box
********************************************************/

use <hd44780.scad>
use <gx16.scad>


include <config.scad>

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
// - Text you want
  txt = "Solder Station";           
// - Font size  
  TxtSize = 5;                 
// - Font  
  Font="Ubuntu"; 
  Font_style="Standard"; // [Standard, Bold, Italic, etc] See Fontlist for more
// - Length  
  Length = 80;       
// - Width
  Width = 140;                     
// - Height  
  Height = 75;                                       
// - Round corner diameter  
  Round = 7;//[0.1:12] 
// - Round smoothness  
  Resolution = 50;//[1:100] 
// - Thickness  
  Thick = 2;//[1:5]
// - Marging
  m = 0.5;
  
/* [Hidden] */
// - Shell color  
  Color1 = [1,0.2,0];       
// - Panels color    
  Color2 = "Black";    



/////////// - Generic rounded box - //////////

module RoundBox($a=Length, $b=Width, $c=Height){// Cube bords arrondis
                    $fn=Resolution;            
                    translate([0,Round,Round]){  
                    minkowski (){                                              
                        cube ([$a-(Length/2),$b-(2*Round),$c-(2*Round)], center = false);
                        rotate([0,90,0]){    
                        cylinder(r=Round,h=Length/2, center = false);
                            } 
                        }
                    }
                }// End of RoundBox Module

      
////////////////////////////////// - Module Shell - //////////////////////////////////         

module Shell(){//Coque - Shell  
    Thick = Thick*2;  
    difference(){    
        difference(){//sides decoration
            union(){    
                     difference() {//soustraction de la forme centrale - Substraction rounded box
                      
                        difference(){//soustraction cube median - Median cube slicer
                            union() {//union               
                            difference(){//Coque    
                                RoundBox();
                                translate([Thick/2,Thick/2,Thick/2]){     
                                        RoundBox($a=Length-Thick, $b=Width-Thick, $c=Height-Thick);
                                        }
                                        }//Fin diff Coque                            
                                difference(){//largeur Rails        
                                     translate([Thick+m,Thick/2,Thick/2]){// Rails
                                          RoundBox($a=Length-((2*Thick)+(2*m)), $b=Width-Thick, $c=Height-(Thick*2));
                                                          }//fin Rails
                                     translate([((Thick+m/2)*1.55),Thick/2,Thick/2]){
                                          RoundBox($a=Length-((Thick*3)+2*m), $b=Width-Thick, $c=Height-Thick);
                                                    }           
                                                }//Fin largeur Rails
                                    }//Fin union                                   
                               translate([-Thick,-Thick,Height/2]){// Cube à soustraire
                                    cube ([Length+100, Width+100, Height], center=false);
                                            }                                            
                                      }//fin soustraction cube median - End Median cube slicer
                               translate([-Thick/2,Thick,Thick]){// Forme de soustraction centrale 
                                    RoundBox($a=Length+Thick, $b=Width-Thick*2, $c=Height-Thick);       
                                    }                          
                                }                                          


                difference(){// Fixation box legs
                    union(){
                        translate([3.9*Thick,Thick,Height/2]){
                            rotate([90,0,0]){
                                    $fn=6;
                                    cylinder(d=16,Thick/2);
                                    }   
                            }
                            
                       translate([Length-3.9*Thick,Thick,Height/2]){
                            rotate([90,0,0]){
                                    $fn=6;
                                    cylinder(d=16,Thick/2);
                                    }   
                            }

                        }
                            translate([4,Thick+Round,Height/2-57]){   
                             rotate([45,0,0]){
                                   cube([Length,40,40]);    
                                  }
                           }
                           translate([0,-(Thick*1.46),Height/2]){
                                cube([Length,Thick*2,10]);
                           }
                    } //Fin fixation box legs
            }

        union(){// outbox sides decorations
            for(i=[0:Thick:Length/4]){

                translate([(Length-10) - i,-Thick+0.6,0]){
                    cube([3,Thick,Height/4]);
                    }
                    
                translate([10+i,-Thick+0.6,0]){
                    cube([3,Thick,Height/4]);
                    }    
                    
                translate([10+i,Width-0.6,0]){
                    cube([3,Thick,Height/4]);
                    } 
                    
                translate([(Length-10) - i,Width-0.6,0]){
                    cube([3,Thick,Height/4]);
                    }    
                
                    }// fin de for
                }//fin union decoration
            }//fin difference decoration


            union(){ //sides holes
                $fn=50;
                translate([2.6*Thick+5,20,Height/2+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([Length-(3.9*Thick),20,Height/2+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([2.6*Thick+5,Width+5,Height/2-4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([Length-(3.9*Thick),Width+5,Height/2-4]){
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
        translate([Thick+m,m/2,m/2]){
             difference(){
                  translate([0,Thick,Thick]){ 
                     RoundBox(Length,Width-((Thick*2)+m),Height-((Thick*2)+m));}
                  translate([Thick,-5,0]){
                     cube([Length,Width+10,Height]);}
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
            rotate([0,-90,0]) translate([(Height)/4,(Width)/1.1,-5]) cylinder(r=3, h=5);
            
            //power plug
            rotate([0,-90,0]) translate([(Height - power_plug_height)/2,(Width - power_plug_width)/10,-5]) cube([power_plug_height, power_plug_width, 3]);
        }
    }
    if(FPanel==1)
    //Front Panel
    rotate([0,0,180]){
        translate([-Length-m/2,-Width,0]){   
            difference(){
                Panels();
                //display
                rotate([0,-90,0]) translate([(Height-display_height)/2,(Width-display_width)/1.25,-6]) cube([display_height + m, display_width + m, 5]);
                //plug
                rotate([0,-90,0]) translate([(Height)/4,(Width)/10,-5]) cylinder(r=8 + m, h=5);
                //button
                rotate([0,-90,0]) translate([(Height)/1.5,(Width)/8,-5]) cylinder(r=3 + m, h=5);
            }
           }
       }

    if(Text==1)
    // Front text
    color(Color1){     
         translate([Length-(Thick),Thick*4,(Height-(Thick*4+(TxtSize/2)))]){// x,y,z
              rotate([90,0,90]){
                  linear_extrude(height = 0.25){
                  text(txt, font = str(Font, ":style=",  Font_style), size = TxtSize,  valign ="center", halign ="left");
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
        translate([0,Width,Height+0.2]){
            rotate([0,180,180]){
                    Shell();
                    }
            }
    }
}

module box_assembly(){
    box();
    rotate([0,0,180]){
        translate([-Length-m/2,-Width,0]){ 
                rotate([0,-90,0]) translate([(Height-display_pcb_height)/1.93,(Width-display_pcb_width)/1.215,-display_depth - 1])display(); //TODO: fix position
                color("Silver") rotate([0,-90,0]) translate([(Height)/4,(Width)/10,-10]) gx16();
                color("White") rotate([0,-90,0]) translate([(Height)/1.5,(Width)/8,-5]) cylinder(r=5 + m, h=10, $fn=32);
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