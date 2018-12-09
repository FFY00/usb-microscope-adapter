/// Variables

$fn = 80;

// Base
base_width = 30;
base_height = 55;
base_tickness = 12;

base_holes_offset = 8;
base_holes_diameter = 3;

// Clamp
clamp_diameter = 31.5;
clamp_opening = 4;
clamp_tickness = 3;
clamp_height = 14;

// Other
base_clamp_offset = 13;

/// Helper functions

module screw_hole(d = 3, height = 30) {
    hull() {
        // Down small
        translate([0, -height/2, 0])
            sphere(d = d / 1.4, center = true);

        // Up small
        translate([0, height/2, 0])
            sphere(d = d / 1.4, center = true);

        // Down big
        translate([0, -height/2 + d, 0])
            sphere(d = d, center = true);

        // Up big
        translate([0, height/2 - d, 0])
            sphere(d = d, center = true);
    }
}

/// Model

// Calculate base hole positions
base_hole_radius = base_holes_diameter / 2;
base_hole_down = base_holes_offset + base_hole_radius;
base_hole_center = base_height / 2;
base_hole_up = base_height - base_holes_offset - base_hole_radius;

module clamp(height){
    difference() {
        union(){
            difference(){
                hull(){
                    translate([0, base_tickness/2 + 0.5, height/2]) rotate([90, 0, 0])
                        cube([base_width, height, 1], center = true);

                    linear_extrude(height)
                        translate([0, base_tickness/2 + base_clamp_offset + clamp_diameter/2, 0])
                            circle(d = clamp_diameter + clamp_tickness*2, $fn=200);
                }

                linear_extrude(height)
                    translate([0, base_tickness/2 + base_clamp_offset + clamp_diameter/2, 0])
                        circle(d = clamp_diameter, $fn=200);
            }

            linear_extrude(height)
                translate([0, base_tickness/2 + base_clamp_offset +  clamp_diameter +3])
                    square([6 + clamp_tickness*2, 6], center = true);
        }

        linear_extrude(height)
            translate([0, base_tickness/2 + base_clamp_offset +  clamp_diameter +3])
                square([6, 10], center = true);
    }
}

difference(){
    union(){
        // Base
        linear_extrude(base_height)
            square([base_width, base_tickness], center = true);

        // Clamp
        clamp(clamp_height);

        // Smooth Ramp
        intersection(){
            translate([0, 0, clamp_height])
                clamp(15);

            difference(){
                translate([0, (base_tickness + base_clamp_offset + clamp_diameter + 9)/2, clamp_height])
                    linear_extrude(20)
                        square([clamp_diameter + clamp_tickness + 3, base_clamp_offset + clamp_diameter + 9], center = true);

                translate([0, base_tickness/2 + 30, clamp_height + 15]) rotate([0, 90, 0])
                    linear_extrude(clamp_diameter + clamp_tickness + 3, center = true)
                            resize([30, 60]) circle();

                translate([0, base_tickness/2 + 40, clamp_height])
                    linear_extrude(15)
                        square([clamp_diameter + clamp_tickness + 3, 21], center = true);
            }
        }
    }

    // Screw holes
    // Up
    // Inner
    translate([0, 0, base_hole_up]) rotate([90, 0, 0])
        cylinder(base_tickness, d = base_holes_diameter, center = true);
    // Outer
    translate([0, base_tickness/2, base_hole_up]) rotate([90, 0, 0])
        cylinder(3, d = base_holes_diameter + 2, center = true);

    // Center
    // Inner
    translate([0, 0, base_hole_center]) rotate([90, 0, 0])
        cylinder(base_tickness, d = base_holes_diameter, center = true);
    // Outer
    translate([0, base_tickness/2, base_hole_center]) rotate([90, 0, 0])
        cylinder(3, d = base_holes_diameter + 2, center = true);

    // Down
    // Inner
    translate([0, 0, base_hole_down]) rotate([90, 0, 0])
        cylinder(base_tickness + base_clamp_offset + 10, d = base_holes_diameter, center = true);
    // Outer
    translate([0, (base_tickness + base_clamp_offset)/2, base_hole_down]) rotate([90, 0, 0])
        cylinder(base_clamp_offset + 3, d = base_holes_diameter + 2, center = true);
}
