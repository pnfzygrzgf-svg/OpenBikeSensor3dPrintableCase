// SPDX-License-Identifier: LGPL-3.0-or-later
// SPDX-FileCopyrightText: OpenBikeSensor contributors

//18650 Battery Shield V3 Case with StandardMount Adapter
// Kombiniert das Battery Shield Case mit einem Montage-Adapter

use <../../lib/Round-Anything/polyround.scad>
use <../Mounting/StandardMountAdapter.scad>

// ====== KONFIGURATION ======

part = "top_with_mount"; 
// Optionen: 
// "top" = nur Oberseite
// "bottom" = nur Unterseite
// "both" = beide Teile nebeneinander
// "top_with_mount" = Oberseite mit Montage-Adapter
// "bottom_with_mount" = Unterseite mit Montage-Adapter
// "adapter_only" = nur Montage-Adapter

adapter_position = "center";
adapter_offset_x = 0;
adapter_offset_y = 0;
adapter_offset_z = 2;
adapter_rotation_x = 0;
adapter_rotation_y = 180;
adapter_rotation_z = 90;

adapter_screwholes = false;
adapter_channels = false;
adapter_twoholes = true;

// ====== ABMESSUNGEN ======

$fn=50;

kantenradius = 2;
toleranz = 0.1;

length = 100;
width = 30;
holelength = 2;
holewidth = 2;

spacing = 10;

// ====== HAUPTLOGIK ======

if (part == "top" || part == "both") {
    topcase();
}

if (part == "bottom") {
    bottomcase();
}

if (part == "both") {
    translate([0, width + spacing, 0])
        bottomcase();
}

if (part == "bottom_with_mount") {
    bottomcase_with_adapter();
}

if (part == "top_with_mount") {
    topcase_with_adapter();
}

if (part == "adapter_only") {
    StandardMountAdapter(
        channels = adapter_channels, 
        screwholes = adapter_screwholes, 
        twoholes = adapter_twoholes
    );
}

// ====== MODULE ======

module topcase() {
    translate([0, 0, 2])
    difference() {
        
        minkowski() {
            translate([-2 + kantenradius, -2 + kantenradius, -2]) 
                cube([length + 4 - 2*kantenradius, width + 4 - 2*kantenradius, 23 - kantenradius]);
            cylinder(r=kantenradius, h=kantenradius);
        }
        
        // Innerer Hohlraum
        translate([-toleranz, -toleranz, 0])
            cube([length + 2*toleranz, width + 2*toleranz, 24]);
        
        // Dünnere Wand oben
        translate([5.5 - toleranz, 2 - toleranz, 0])
            cube([length - 10.5 + 2*toleranz, width - 4 + 2*toleranz, 26]);
        
        // USB-Port V3
        translate([-4, 7, 13]) cube([10, 15, 8]);
        
        // Power Button
        translate([7.5, -2, 15.5]) cube([8.5, 5, 5.5]);
        
        // Nur Schaftbohrungen, Kopf liegt auf
        translate([holelength, holewidth, -4])               cylinder(30, 3.5/2 + toleranz, 3.5/2 + toleranz);
        translate([holelength, width-holewidth, -4])         cylinder(30, 3.5/2 + toleranz, 3.5/2 + toleranz);
        translate([length-holelength, holewidth, -4])        cylinder(30, 3.5/2 + toleranz, 3.5/2 + toleranz);
        translate([length-holelength, width-holewidth, -4])  cylinder(30, 3.5/2 + toleranz, 3.5/2 + toleranz);
    }
}

module bottomcase() {
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

module bottomcase_with_adapter() {
    union() {
        bottomcase();
        
        x_pos = adapter_position == "left" ? 10 : 
                adapter_position == "right" ? length - 24 - 10 : 
                length/2;
        
        translate([x_pos + adapter_offset_x, width/2 + adapter_offset_y, adapter_offset_z])
        rotate([adapter_rotation_x, adapter_rotation_y, adapter_rotation_z])
        StandardMountAdapter(
            channels = adapter_channels, 
            screwholes = adapter_screwholes, 
            twoholes = adapter_twoholes
        );
    }
}

module topcase_with_adapter() {
    union() {
        topcase();
        
        x_pos = adapter_position == "left" ? 10 : 
                adapter_position == "right" ? length - 24 - 10 : 
                length/2;
        
        translate([x_pos + adapter_offset_x, width/2 + adapter_offset_y, adapter_offset_z])
        rotate([adapter_rotation_x, adapter_rotation_y, adapter_rotation_z])
        StandardMountAdapter(
            channels = adapter_channels, 
            screwholes = adapter_screwholes, 
            twoholes = adapter_twoholes
        );
    }
}