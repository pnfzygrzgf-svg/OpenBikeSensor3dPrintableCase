include <../../variables.scad>
use <../../lib/Round-Anything/polyround.scad>
use <../../lib/utils.scad>

HUGE = 1000;

// ========== BATTERIE-SHIELD PARAMETER ==========
$fn=50;
kantenradius = 2;

// V3 Dimensionen
battery_length = 100;
battery_width = 30;
holelength = 3;
holewidth = 2.5;

// Position des Battery-Shields relativ zur Halterung
battery_offset_x = 40;  // Links/Rechts verschieben
battery_offset_y = -2;  // Vor/Zurück verschieben
battery_offset_z = -50;  // Höhe anpassen

// Rotation des Battery-Shields
battery_rotate_x = 0;  // Rotation um X-Achse (Kippen vorwärts/rückwärts)
battery_rotate_y = 270;  // Rotation um Y-Achse (Kippen links/rechts)
battery_rotate_z = 90;  // Rotation um Z-Achse (Drehen horizontal)

// Verlängerung der Wände für besseren Ausschnitt (in mm)
wall_extension = 20;  // Erhöhe diesen Wert für mehr Ausschnitt im Mount

// ========== BATTERY SHIELD MODULE ==========
module topcase_body() {
    // Abgerundeter Aussenkörper mit minkowski
    minkowski() {
        translate([-2 + kantenradius, -2 + kantenradius, -2]) 
            cube([battery_length + 4 - 2*kantenradius, battery_width + 4 - 2*kantenradius, 23 - kantenradius]);
        cylinder(r=kantenradius, h=kantenradius);
    }
}

// Erweiterte Außenwand für Ausschnitt im Mount (höhere Wände)
module topcase_body_extended() {
    minkowski() {
        translate([-2 + kantenradius, -2 + kantenradius, -2]) 
            cube([battery_length + 4 - 2*kantenradius, battery_width + 4 - 2*kantenradius, 23 - kantenradius + wall_extension]);
        cylinder(r=kantenradius, h=kantenradius);
    }
}

module topcase_cutouts() {
    // Innerer Hohlraum
    translate([0,0,0]) cube([battery_length,battery_width,24]);
    
    // Dünnere Wand oben
    translate([5.5,2,0])cube([battery_length-10.5,battery_width-4,26]);
    
    // USB-Port V3
    translate([-4,7,13])cube([10,15,8]);
    
    // Power Button
    translate([7.5,-2,15.5])cube([8.5,5,5.5]);        
    
    // Schraubenlöcher V3
    translate([holelength,holewidth,-4])cylinder(5,6.5/2,6.5/2);
    translate([holelength,battery_width-holewidth,-4])cylinder(5,6.5/2,6.5/2);
    translate([battery_length-holelength,holewidth,-4])cylinder(5,6.5/2,6.5/2);
    translate([battery_length-holelength,battery_width-holewidth,-4])cylinder(5,6.5/2,6.5/2);
    translate([holelength,holewidth,-4])cylinder(30,4/2,4/2);
    translate([holelength,battery_width-holewidth,-4])cylinder(30,4/2,4/2);
    translate([battery_length-holelength,holewidth,-4])cylinder(30,4/2,4/2);
    translate([battery_length-holelength,battery_width-holewidth,-4])cylinder(30,4/2,4/2);
}

module topcase() {
    difference() {
        topcase_body();
        topcase_cutouts();
    }
}

// ========== SATTELSTÜTZEN-HALTERUNG ==========
module SeatPostMountBase() {
  union() {
    translate([0, SeatPostMount_stop_plate_thickness, MountRail_total_height])
    MountRail(MountRail_clearance);
    
    // Stop plate
    mirror([0, 1, 0])
    rotate([90, 0, 0])
    linear_extrude(SeatPostMount_stop_plate_thickness)
    polygon(polyRound([
      [0, 0, 0],
      [-SeatPostMount_stop_plate_width/2, 0, 2],
      [-SeatPostMount_stop_plate_width/2, HUGE+MountRail_total_height, 0],
      [SeatPostMount_stop_plate_width/2, HUGE+MountRail_total_height, 0],
      [SeatPostMount_stop_plate_width/2, 0, 2],
    ], fn=$pfn));
    
    // Main holder chunk
    translate([0, SeatPostMount_stop_plate_thickness, MountRail_total_height])
    mirror([0, 1, 0])
    rotate([90, 0, 0])
    linear_extrude(MountRail_width)
    polygon(polyRound([
      [0, 0, 0],
      [-MountRail_plate_width/2+MountRail_clearance, 0, 0],
      [-SeatPostMount_stop_plate_width/2, 4, 20],
      [-SeatPostMount_stop_plate_width/2, HUGE, 0],
      [SeatPostMount_stop_plate_width/2, HUGE, 0],
      [SeatPostMount_stop_plate_width/2, 4, 20],
      [MountRail_plate_width/2-MountRail_clearance, 0, 0],
    ], fn=$pfn));
  }
}

module SeatPostMountCutout(diameter, angle, length, cutaway) {
  width = cutaway ? SeatPostMount_width : (MountRail_width + SeatPostMount_stop_plate_thickness);
  translate([0, width/2, max(MountRail_total_height, length) + diameter/cos(angle)/2 + SeatPostMount_stop_plate_width/2 * sin(angle)]) {
    rotate([0, -90+angle, 0]) {
      union () {
        cylinder(d=diameter, h=200, center=true, $fn=$fn*4);
        translate([0, -HUGE/2, -HUGE/2])
        cube(HUGE);
        translate([-diameter/2+SeatPostMount_channel_depth, -20, -105])
        cube([50, 40, 210]);
        for (i = [-1, 1]) {
          w = 9;
          translate([0, 0, i*16-angle/4])
          difference() {
            cylinder(r=diameter/2+7, h=w, center=true);
            cylinder(r=diameter/2+3, h=w, center=true);
          }
        }
      }
    }
  }
  if (cutaway) {
    cutaway_width = MountRail_width - SeatPostMount_width + SeatPostMount_stop_plate_thickness;
    translate([-100, SeatPostMount_width, cutaway_width + MountRail_total_height]) {
      union() {
        cube([200, cutaway_width * 2, 100]);
        translate([0, cutaway_width, 0])
        rotate([0,90, 0])
        cylinder(r=cutaway_width, h=200);
      }
    }
  }
}

module SeatPostMount(diameter=0, cutaway=false) {
  difference() {
    SeatPostMountBase();
    SeatPostMountCutout(
      diameter=SeatPostMount_diameter,
      length=SeatPostMount_long_length,
      angle=SeatPostMount_angle,
      cutaway=true
    );
  }
}

// Hilfsfunktion: Battery-Körper in World-Koordinaten (normale Version)
module battery_in_world_space() {
    translate([battery_offset_x, battery_offset_y, battery_offset_z])
    rotate([battery_rotate_x, battery_rotate_y, battery_rotate_z])
    topcase_body();
}

// Hilfsfunktion: Battery-Körper mit verlängerten Wänden (für Ausschnitt im Mount)
module battery_extended_in_world_space() {
    translate([battery_offset_x, battery_offset_y, battery_offset_z])
    rotate([battery_rotate_x, battery_rotate_y, battery_rotate_z])
    topcase_body_extended();
}

// Hilfsfunktion: Mount-Basis in World-Koordinaten
module mount_in_world_space() {
    if (orient_for_printing) {
        rotate([90, 0, 0])
        SeatPostMountBase();
    } else {
        rotate([0, -90, -180])
        SeatPostMountBase();
    }
}

// Modul: Überschneidung zwischen Mount und Battery (mit verlängerten Wänden)
// Dies schneidet NUR aus dem Mount, nicht aus dem Battery-Case
module intersection_volume() {
    intersection() {
        mount_in_world_space();
        battery_extended_in_world_space();
    }
}

// ========== KOMBINIERTES MODUL ==========
module SeatPostMountWithBattery() {
    union() {
        // Sattelstützen-Halterung MINUS Überschneidung (mit verlängerten Wänden)
        difference() {
            if (orient_for_printing) {
                rotate([90, 0, 0])
                SeatPostMount();
            } else {
                rotate([0, -90, -180])
                SeatPostMount();
            }
            intersection_volume();
        }
        
        // Batterie-Shield OHNE Überschneidung (behält alle Wände)
        translate([battery_offset_x, battery_offset_y, battery_offset_z])
        rotate([battery_rotate_x, battery_rotate_y, battery_rotate_z])
        topcase();
    }
}

// ========== RENDERING ==========
SeatPostMountWithBattery();