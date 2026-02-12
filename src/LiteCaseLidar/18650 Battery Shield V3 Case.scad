
//18650 Battery Shield V3 Case


// Welches Teil soll gerendert werden?
// "top" = Oberseite, "bottom" = Unterseite, "both" = beide Teile nebeneinander
part = "top"; // Optionen: "top", "bottom", "both"

$fn=50;

// Radius für Kantenrundung
kantenradius = 2;

// V3 Dimensionen
length = 100;
width = 30;
holelength = 3;
holewidth = 2.5;

// Abstand zwischen den Teilen wenn beide angezeigt werden
spacing = 10;

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

module topcase() {
    difference() {
        
        // Abgerundeter Aussenkörper mit minkowski
        minkowski() {
            translate([-2 + kantenradius, -2 + kantenradius, -2]) 
                cube([length + 4 - 2*kantenradius, width + 4 - 2*kantenradius, 23 - kantenradius]);
            cylinder(r=kantenradius, h=kantenradius);
        }
        
        // Innerer Hohlraum
        translate([0,0,0]) cube([length,width,24]);
        
        // Dünnere Wand oben
        translate([5.5,2,0])cube([length-10.5,width-4,26]);
        
        // USB-Port V3
        translate([-4,7,13])cube([10,15,8]);
        
        // Power Button
        translate([7.5,-2,15.5])cube([8.5,5,5.5]);        
        
        // Schraubenlöcher V3
        translate([holelength,holewidth,-4])cylinder(5,6.5/2,6.5/2);
        translate([holelength,width-holewidth,-4])cylinder(5,6.5/2,6.5/2);
        translate([length-holelength,holewidth,-4])cylinder(5,6.5/2,6.5/2);
        translate([length-holelength,width-holewidth,-4])cylinder(5,6.5/2,6.5/2);
        translate([holelength,holewidth,-4])cylinder(30,4/2,4/2);
        translate([holelength,width-holewidth,-4])cylinder(30,4/2,4/2);
        translate([length-holelength,holewidth,-4])cylinder(30,4/2,4/2);
        translate([length-holelength,width-holewidth,-4])cylinder(30,4/2,4/2);
    }
}

module bottomcase() {
    difference() {
        union() {
            difference() {
                // Abgerundeter Aussenkörper mit minkowski
                minkowski() {
                    translate([-2 + kantenradius, -2 + kantenradius, -2]) 
                        cube([length + 4 - 2*kantenradius, width + 4 - 2*kantenradius, 9 - kantenradius]);
                    cylinder(r=kantenradius, h=kantenradius);
                }
                
                cube([length,width,10]);
                
                // USB-Port
                translate([length-15.5,width-2,2])cube([10,5,6]);
                
                // Zusätzliches Loch 1 (29x52.5mm)
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
            
            // Schraubenhalterung V3
            cube([6.5,6.5,5]);
            translate([0,width-6.5,0]) cube([6.5,6.5,5]);
            translate([length-5.5,0,0]) cube([6.5,6.5,5]);
            translate([length-5.5,width-6.5,0]) cube([6.5,6.5,5]);
        }
        
        // Schraubenlöcher V3
        translate([holelength,holewidth,0]) cylinder(6,3.5/2,3.5/2);
        translate([holelength,width-holewidth,0]) cylinder(6,3.5/2,3.5/2);
        translate([length-holelength,holewidth,0]) cylinder(6,3.5/2,3.5/2);
        translate([length-holelength,width-holewidth,0]) cylinder(6,3.5/2,3.5/2);
        
        // Mutterneinsatz
        translate([holelength,holewidth,-2]) rotate(90)cylinder(3,7/2,7/2,$fn=6);
        translate([holelength,width-holewidth,-2]) rotate(90)cylinder(3,7/2,7/2,$fn=6);
        translate([length-holelength,holewidth,-2]) rotate(90)cylinder(3,7/2,7/2,$fn=6);
        translate([length-holelength,width-holewidth,-2]) rotate(90)cylinder(3,7/2,7/2,$fn=6);
    }
}