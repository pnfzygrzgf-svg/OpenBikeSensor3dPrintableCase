// ============================================================
// LiteCaseLidar Deckel + 18650 Battery Shield V3 Bottom
// ============================================================
use <../../lib/Round-Anything/polyround.scad>
// ============================================================
// CONFIG
// ============================================================
$fn = 40;
// Welches Teil rendern?
render_part = "combined";  
// Optionen:
// "litecaselidar_bottom" = nur LiteCaseLidar Unterteil
// "battery_bottom" = nur Battery Shield Unterteil
// "combined" = LiteCaseLidar mit Battery Shield oben drauf
// "both" = beide nebeneinander
// "preview" = LiteElectronics Preview
// Battery Shield Position auf LiteCaseLidar (nur für "combined")
battery_offset_x = -42;      // X-Verschiebung
battery_offset_y = -15;      // Y-Verschiebung  
battery_offset_z = 10;     // Z-Verschiebung (Höhe über LiteCaseLidar)
battery_rotation_x = 0;    // Rotation um X-Achse in Grad
battery_rotation_y = 0;    // Rotation um Y-Achse in Grad
battery_rotation_z = 0;    // Rotation um Z-Achse in Grad
// Abstand zwischen Teilen wenn "both"
parts_spacing = 120;
// ============================================================
// TF-LUNA CONFIG
// ============================================================
tfluna_file             = "tfluna.stl";
tfluna_scale            = [1, 1, 1];
tfluna_rot_common       = [90, 0, -180];
tfluna_mirror_axis      = [0, 0, 1];
tfluna_pos_offset_m     = [0,  2, 15];
tfluna_pos_offset_p     = [0, -2, 15];
tfluna_cutter_scale_up  = 1.1;
show_tfluna_preview     = true;
tfluna_preview_alpha    = 0.55;
tfluna_preview_color    = "orange";
// ============================================================
// THROUGH-BOHRUNGEN (OVAL) CONFIG
// ============================================================
through_enable          = true;
through_preview         = true;
through_base_pos        = [23.8, 0, 20.6];
through_offset          = [0, 0, 5];
through_oval_length     = 25;
through_d               = 14;
through_sep_vec         = [1, 0, 0];
through_clearance       = 0.0;
through_axis            = "y";
through_h               = 50;
// ============================================================
// LITECASELIDAR PARAMETERS
// ============================================================
corner_x = 24;
boardcorner_x = 17;
boardcorner_y = 23;
square_x = 5;
lite_l = 45;
lite_w = 80 - 18;
Lite_PCB_Dimensions = [44, 29.2, 1.7];
Lite_ESP_socket_dimensions = [38, 2.54, 9 + Lite_PCB_Dimensions[2] + 1.8];
Lite_transducer_position       = [23.8, 0, 20.6];
Lite_transducer_variance       = 1.2;
Lite_transducer_diameter       = 16 + Lite_transducer_variance;
Lite_transducer_diameter_small = 12.5 + Lite_transducer_variance;
Lite_ESP_position   = [0, 0, -16.2];
Lite_ESP_dimensions = [53, 29, 4.8];
Lite_USB = [55, 0, -14.5];
Lite_screwmount_top    = 4;
Lite_screwmount_bottom = 6;
Lite_screwmount_height = Lite_screwmount_top + Lite_screwmount_bottom;
sensor_x = -Lite_transducer_position[2] + 0.5;
sensor_y =  Lite_transducer_position[0];
// ============================================================
// BATTERY SHIELD V3 PARAMETERS
// ============================================================
kantenradius = 2;
toleranz = 0.1;
length = 100;
width = 30;
holelength = 2;
holewidth = 2;
// ============================================================
// HELPERS
// ============================================================
function angle_three_points_2d(pa, pb, pc) =
  asin(cross(pb - pa, pb - pc) / (norm(pb - pa) * norm(pb - pc)));
module rounded_cube(x, y, z, r, r2, center = true) {
  t = center ? -[x/2, y/2, z/2] : [0, 0, 0];
  translate(t)
    polyRoundExtrude(
      [[0,0,max(r,r2)], [0,y,max(r,r2)], [x,y,max(r,r2)], [x,0,max(r,r2)]],
      z, r, r2
    );
}
// ============================================================
// LITECASELIDAR SHELL GEOMETRY
// ============================================================
module SidePolygon() {
  corners = [
    [square_x,  -lite_w/2, 9],
    [-corner_x, -0,
      (corner_x - boardcorner_x) /
      (1 / sin(angle_three_points_2d([0,0], [-corner_x,-0], [square_x, lite_w/2])) - 1)
    ],
    [square_x,   lite_w/2, 9],
    [lite_l,     lite_w/2, 5],
    [lite_l,    -lite_w/2, 5]
  ];
  translate([sensor_x, sensor_y]) polygon(polyRound(corners, fn = 150));
}
module MidPolygon() {
  corners = [
    [square_x,       -lite_w/2, 5],
    [-boardcorner_x, -boardcorner_y, 5],
    [-boardcorner_x,  boardcorner_y, 5],
    [square_x,        lite_w/2, 5],
    [lite_l,          lite_w/2, 5],
    [lite_l,         -lite_w/2, 5]
  ];
  translate([sensor_x, sensor_y]) polygon(polyRound(corners));
}
module LidCutter() {
  translate([40, 0, Lite_ESP_position[2] + 0.8]) cube([120, 90, 0.1], center = true);
}
module Box() {
  hull() for (i = [-1, 1]) {
    translate([0, 0, i*9  - (i+1)/2])  linear_extrude(1) MidPolygon();
    translate([0, 0, i*18 - (i+1)/2])  linear_extrude(1) SidePolygon();
  }
}
// ============================================================
// LITECASELIDAR ELECTRONICS
// ============================================================
module ESP() {
  difference() {
    color("black") translate([24.6, 0, 0.2]) cube(Lite_ESP_dimensions, center = true);
    for (i = [-1, 1]) for (j = [-1, 1])
      translate([i*24.6 + 22.6, j*12.5 - 2.5, -4.7]) cube([4, 5, 5]);
  }
}
module USB_hole() {
  translate(Lite_USB) {
    translate([0, 0, -2.25]) rounded_cube(45, 12.5, 8, 0, 0, center = true);
    rounded_cube(45, 10, 20, 2.5, 0, center = true);
  }
}
module UltrasonicCarrier(i, h = 30) {
  translate([0, 0, -h/2 + 34/2]) {
    color("blue") translate([23.9, i*7.3, 17.99]) cube([42.5, 1.4, h], center = true);
    hull() {
      translate([Lite_transducer_position[0], 0, 14.99]) cube([42.5, 21.5, h], center = true);
      translate([Lite_transducer_position[0], 0, 16.99]) cube([42.5, 16.5, h], center = true);
      translate([Lite_transducer_position[0], 0, 10.99]) cube([49.5, 18.5, h], center = true);
    }
    intersection() {
      translate([0, 0, +h/2 - 34/2])
        hull() {
          translate(Lite_transducer_position - [0, 8*i, 100]) rotate([i*90, 0, 0])
            cylinder(d1 = Lite_transducer_diameter + 12, d2 = Lite_transducer_diameter, h = 8.5);
          translate(Lite_transducer_position - [0, 8*i, 0]) rotate([i*90, 0, 0])
            cylinder(d1 = Lite_transducer_diameter + 12, d2 = Lite_transducer_diameter, h = 8.5);
        }
      color("blue") translate([23.9, i*7, 17.99]) cube([41.5, 60, h + 14], center = true);
    }
  }
}
module Screwbump(size = 6, hole_diameter = 3.8, height = 6, bottom = true, toppart = 2.1, insert = 4) {
  outer_polygon = [[size,0,0], [-size,0,0], [-size,size,size], [0,3*size,size], [size,size,size]];
  difference() {
    hull() {
      translate([0,0,0])        polyRoundExtrude(outer_polygon, 1, 0, 0);
      translate([0,0,height-1]) polyRoundExtrude(outer_polygon, 1, 0, 0);
      if (bottom) translate([0,-0.01,1.3*height]) rotate([90,0,0]) cylinder(d = size, h = 0.1);
    }
    translate([0, size, toppart])  cylinder(d = insert, h = height - toppart);
    translate([0, size, -0.01])    cylinder(d = hole_diameter, h = toppart);
  }
}
// ============================================================
// TF-LUNA
// ============================================================
module _tfluna_import(cutter=false) {
  s = cutter ? [tfluna_cutter_scale_up, tfluna_cutter_scale_up, tfluna_cutter_scale_up] : [1,1,1];
  scale(tfluna_scale) scale(s) import(tfluna_file, convexity = 10);
}
module TFLuna_at_old_tube_pos(i, cutter=false) {
  local_off = (i < 0) ? tfluna_pos_offset_m : tfluna_pos_offset_p;
  pos = Lite_transducer_position - [0, 8*i, 0] + local_off;
  translate(pos)
    rotate(tfluna_rot_common)
      if (i > 0) mirror(tfluna_mirror_axis) _tfluna_import(cutter=cutter);
      else       _tfluna_import(cutter=cutter);
}
module TFLuna_pair(cutter=false) {
  for (i = [-1, 1]) {
    if (cutter) render() TFLuna_at_old_tube_pos(i, cutter=true);
    else        TFLuna_at_old_tube_pos(i, cutter=false);
  }
}
// ============================================================
// THROUGH-BOHRUNGEN (OVAL)
// ============================================================
module ThroughOval() {
  base = through_base_pos + through_offset;
  d = through_d + 2*through_clearance;
  L = through_oval_length + 2*through_clearance;
  half = (L - d) / 2;
  function vnorm(v) = v / max(norm(v), 1e-9);
  v = vnorm(through_sep_vec) * half;
  module oriented_cyl(pos) {
    if (through_axis == "x")
      translate(pos) rotate([0, 90, 0]) cylinder(d=d, h=through_h, center=true);
    else if (through_axis == "y")
      translate(pos) rotate([90, 0, 0]) cylinder(d=d, h=through_h, center=true);
    else
      translate(pos) cylinder(d=d, h=through_h, center=true);
  }
  hull() {
    oriented_cyl(base + v);
    oriented_cyl(base - v);
  }
}
// ============================================================
// LITE ELECTRONICS ASSEMBLY
// ============================================================
module LiteElectronics(onlyboards = false) {
  color("green") translate(-[0, Lite_PCB_Dimensions[1]/2, Lite_PCB_Dimensions[2]])
    cube(Lite_PCB_Dimensions, center=false);
  color("green") translate(-[0.2, Lite_PCB_Dimensions[1]/2 + 0.2, Lite_PCB_Dimensions[2] + 14])
    cube(Lite_PCB_Dimensions + [0.4, 0.4, 14], center=false);
  for (i = [-1, 1])
    color("darkgrey")
      translate([3.5,
                 i*Lite_PCB_Dimensions[1]/2 - (i+1)*Lite_ESP_socket_dimensions[1]/2 - i*0.45,
                 -Lite_ESP_socket_dimensions[2] + 1.8])
        cube(Lite_ESP_socket_dimensions);
  translate(Lite_ESP_position) ESP();
  hull() {
    translate([24.6, 0, Lite_ESP_position[2] - 2])   cube([45, 29, 1], center=true);
    translate([24.6, 0, Lite_ESP_position[2] - 4.3]) cube([45, 18.5, 5.01], center=true);
  }
  hull() {
    translate([24.6, 0, Lite_ESP_position[2] - 2])   cube([Lite_ESP_dimensions[0], 20, 0.5], center=true);
    translate([25.,  0, Lite_ESP_position[2] - 4.3]) cube([45, 18.5, 0.1], center=true);
  }
  for (i = [-1, 1]) UltrasonicCarrier(i, h = 50);
  USB_hole();
  if ($preview && show_tfluna_preview)
    color(tfluna_preview_color, tfluna_preview_alpha) TFLuna_pair(cutter=false);
  if ($preview && through_preview && through_enable)
    color("red", 0.4) ThroughOval();
}
// ============================================================
// LITECASELIDAR CASE
// ============================================================
module lite_case() {
  difference() {
    union() {
      translate([-7, 0, Lite_ESP_position[2] + 0.8 + 0.05 - Lite_screwmount_top])
        rotate([0, 0, 90])
          Screwbump(size=4, hole_diameter=3.2, height=Lite_screwmount_height, bottom=true, toppart=Lite_screwmount_top);
      translate([lite_w - 7.3, 12, Lite_ESP_position[2] + 0.8 + 0.05 - Lite_screwmount_top])
        rotate([0, 0, -90])
          Screwbump(size=4, hole_diameter=3.2, height=Lite_screwmount_height, bottom=true, toppart=Lite_screwmount_top);
      translate([lite_w - 7.3, -12, Lite_ESP_position[2] + 0.8 + 0.05 - Lite_screwmount_top])
        rotate([0, 0, -90])
          Screwbump(size=4, hole_diameter=3.2, height=Lite_screwmount_height, bottom=true, toppart=Lite_screwmount_top);
      rotate([90, 90, 0]) Box();
      difference() {
        translate(Lite_USB + [0, 0, -3.5 - 1.6 + 1]) {
          rounded_cube(1, 16.5, 6.5, 0, 1.5, center=true);
          difference() {
            rounded_cube(1, 15, 6.5, 0, 1.5, center=true);
            translate([8, -20, -5]) cube([4, 60, 20]);
          }
        }
        translate(Lite_USB + [10, 0, 0]) cube([4, 20, 12.5], center=true);
      }
    }
    LiteElectronics();
    LidCutter();
    TFLuna_pair(cutter=true);
    if (through_enable) ThroughOval();
  }
}
// ============================================================
// BATTERY SHIELD V3 BOTTOM CASE (aktualisiert)
// ============================================================
module battery_bottomcase() {
    difference() {
        union() {
            difference() {
                // Abgerundeter Aussenkörper – Boden 3mm (z=-3)
                minkowski() {
                    translate([-2 + kantenradius, -2 + kantenradius, -3]) 
                        cube([length + 4 - 2*kantenradius, width + 4 - 2*kantenradius, 9 - kantenradius]);
                    cylinder(r=kantenradius, h=kantenradius);
                }
                
                // Innenraum
                translate([-toleranz, -toleranz, 0])
                    cube([length + 2*toleranz, width + 2*toleranz, 10]);
                
                // USB-Port
                translate([length-15.5, width-2, 2]) cube([10, 5, 6]);
                
                // Zusätzliches Loch 1
                loch_rotation = 90;
                loch_links_rechts = -30;
                loch_hoch_runter = 0;
                loch_z = -27;
                
                translate([length/2 + loch_links_rechts, width/2 + loch_hoch_runter, 19 + loch_z]) 
                    rotate([0, 0, loch_rotation]) 
                    translate([-29/2, -0, 0]) 
                    cube([29, 10, 10]);
                
                // Zusätzliches Loch 2
                loch2_breite = 10;
                loch2_tiefe = 15;
                loch2_rotation = 90;
                loch2_links_rechts = 35;
                loch2_hoch_runter = 0;
                loch2_z = -27;
                
                translate([length/2 + loch2_links_rechts, width/2 + loch2_hoch_runter, 19 + loch2_z]) 
                    rotate([0, 0, loch2_rotation]) 
                    translate([-loch2_breite/2, -loch2_tiefe/2, 0]) 
                    cube([loch2_breite, loch2_tiefe, 10]);
            }
            
            // Schraubenhalterung V3 – Zylinder
            translate([holelength, holewidth, 0])              cylinder(h=5, r=3.5);
            translate([holelength, width-holewidth, 0])        cylinder(h=5, r=3.5);
            translate([length-holelength, holewidth, 0])       cylinder(h=5, r=3.5);
            translate([length-holelength, width-holewidth, 0]) cylinder(h=5, r=3.5);
        }
        
        // Schraubenlöcher V3
        translate([holelength, holewidth, 0])              cylinder(6, 3.5/2 + toleranz, 3.5/2 + toleranz);
        translate([holelength, width-holewidth, 0])        cylinder(6, 3.5/2 + toleranz, 3.5/2 + toleranz);
        translate([length-holelength, holewidth, 0])       cylinder(6, 3.5/2 + toleranz, 3.5/2 + toleranz);
        translate([length-holelength, width-holewidth, 0]) cylinder(6, 3.5/2 + toleranz, 3.5/2 + toleranz);
        
        // Mutterneinsatz M3 SW5.5, Tiefe 3mm
        translate([holelength, holewidth, -3])              rotate(90) cylinder(3, 5.5/2 + toleranz, 5.5/2 + toleranz, $fn=6);
        translate([holelength, width-holewidth, -3])        rotate(90) cylinder(3, 5.5/2 + toleranz, 5.5/2 + toleranz, $fn=6);
        translate([length-holelength, holewidth, -3])       rotate(90) cylinder(3, 5.5/2 + toleranz, 5.5/2 + toleranz, $fn=6);
        translate([length-holelength, width-holewidth, -3]) rotate(90) cylinder(3, 5.5/2 + toleranz, 5.5/2 + toleranz, $fn=6);
    }
}
// ============================================================
// RENDER LOGIC
// ============================================================
if (render_part == "litecaselidar_bottom") {
  rotate([0, 180, 0]) translate([-30, 0, -Lite_ESP_position[2] - 0.8])
    difference() {
      lite_case();
      translate([40, 0, Lite_ESP_position[2] + 0.8 + 49.95]) cube([120, 90, 100], center = true);
    }
  for (i = [-8, 8]) translate([-40, i, 0]) cylinder(r = 4, h = 0.2);
}
if (render_part == "battery_bottom") {
  battery_bottomcase();
}
if (render_part == "combined") {
  rotate([0, 180, 0]) translate([-30, 0, -Lite_ESP_position[2] - 0.8])
    difference() {
      lite_case();
      translate([40, 0, Lite_ESP_position[2] + 0.8 + 49.95]) cube([120, 90, 100], center = true);
    }
  translate([battery_offset_x, battery_offset_y, battery_offset_z])
    rotate([battery_rotation_x, battery_rotation_y, battery_rotation_z])
      battery_bottomcase();
}
if (render_part == "both") {
  rotate([0, 180, 0]) translate([-30, 0, -Lite_ESP_position[2] - 0.8])
    difference() {
      lite_case();
      translate([40, 0, Lite_ESP_position[2] + 0.8 + 49.95]) cube([120, 90, 100], center = true);
    }
  for (i = [-8, 8]) translate([-40, i, 0]) cylinder(r = 4, h = 0.2);
  translate([parts_spacing, 0, 0]) battery_bottomcase();
}
if (render_part == "preview" || $preview) {
  translate([80, 0, 0]) LiteElectronics();
}