//vitamin config
display_pcb_height = 60;
display_pcb_width = 100;

display_height = 40;
display_width = 97;
display_depth = 10;

power_plug_height = 47;
power_plug_width = 27;

solder_plug_pins = 8;
solder_plug_middle_pin = 1;

//for all

layer_height = 0.2;

// main_box config

// - Text you want
  main_box_text = "Solder Station";           
// - Font size  
  main_box_font_size = 5;                 
// - Font  
  main_box_font="Ubuntu"; 
  main_box_font_style="Standard"; // [Standard, Bold, Italic, etc] See Fontlist for more
  main_box_font_layers=3;
  
  // - Length  
  main_box_length = 100;       
// - Width
  main_box_width = 140;                     
// - Height  
  main_box_height = 75;                                       
// - Round corner diameter  
  main_box_roundness = 7;//[0.1:12] 
// - Round smoothness  
  main_box_resolution = 50;//[1:100] 
// - Thickness  
  main_box_thickness = 2;//[1:5]
// - Marging
  m = 0.5;
  
  main_box_top_slots = 5;
  
  main_box_button_r = 6.8/2;
  
  
power_pcb_width = 106;
power_pcb_height = 57;

power_pcb_hole_dist = 4;

main_pcb_pos_y = 10;
main_pcb_pos_x = 25;

include <active_userconfig.scad>