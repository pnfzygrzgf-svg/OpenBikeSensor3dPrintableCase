L = 49.55;
B = 20.00;
H = 2.00;

steg    = 6.30;
flansch = 12;

r = 0.3;      

cutW = (B - steg)/2;
cutL = L - 2*flansch;

module profile2d() {
  difference() {
    square([L, B], center=false);

    // linke Tasche
    translate([flansch, 0])
      square([cutL, cutW], center=false);

    // rechte Tasche
    translate([flansch, B - cutW])
      square([cutL, cutW], center=false);
  }
}

// Abrundung
linear_extrude(height=H, center=false)
offset(r=r) offset(delta=-r)
profile2d();
