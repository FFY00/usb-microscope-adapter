/// Variables

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

module screw_hole(d = 3, height = 30, $fn = 80) {
    hull() {
        // Down small
        translate([0, -height/2, 0])
            sphere(d = d / 1.4, center = true, $fn = $fn);

        // Up small
        translate([0, height/2, 0])
            sphere(d = d / 1.4, center = true, $fn = $fn);

        // Down big
        translate([0, -height/2 + d, 0])
            sphere(d = d, center = true, $fn = $fn);

        // Up big
        translate([0, height/2 - d, 0])
            sphere(d = d, center = true, $fn = $fn);
    }
}

/// Model

// Calculate base hole positions
base_hole_radius = base_holes_diameter / 2;
base_hole_down = base_holes_offset + base_hole_radius;
base_hole_center = base_height / 2;
base_hole_up = base_height - base_holes_offset - base_hole_radius;

difference(){
    union(){
        // Base
        linear_extrude(base_height)
            square([base_width, base_tickness], center = true);

        // Clamp
        difference(){
            union(){
                // Clamp structure
                difference(){
                    hull(){
                        translate([0, base_tickness/2 + 0.5, clamp_height/2]) rotate([90, 0, 0])
                            cube([base_width, clamp_height, 1], center = true);

                        linear_extrude(clamp_height)
                            translate([0, base_tickness/2 + base_clamp_offset + clamp_diameter/2, 0])
                                circle(d = clamp_diameter + clamp_tickness*2, $fn=200);
                    }

                    linear_extrude(clamp_height)
                        translate([0, base_tickness/2 + base_clamp_offset + clamp_diameter/2, 0])
                            circle(d = clamp_diameter, $fn=200);
                }

                linear_extrude(clamp_height)
                    translate([0, base_tickness/2 + base_clamp_offset +  clamp_diameter +3])
                        square([6 + clamp_tickness*2, 6], center = true);
            }

            linear_extrude(clamp_height)
                translate([0, base_tickness/2 + base_clamp_offset +  clamp_diameter +3])
                    square([6, 10], center = true);
        }
    }

    // Screw holes
    // Up
    // Inner
    translate([0, 0, base_hole_up]) rotate([90, 0, 0])
        cylinder(base_tickness, d = base_holes_diameter, center = true, $fn = 80);
    // Outer
    translate([0, base_tickness/2, base_hole_up]) rotate([90, 0, 0])
        cylinder(3, d = base_holes_diameter + 2, center = true, $fn = 80);

    // Center
    // Inner
    translate([0, 0, base_hole_center]) rotate([90, 0, 0])
        cylinder(base_tickness, d = base_holes_diameter, center = true, $fn = 80);
    // Outer
    translate([0, base_tickness/2, base_hole_center]) rotate([90, 0, 0])
        cylinder(3, d = base_holes_diameter + 2, center = true, $fn = 80);

    // Down
    // Inner
    translate([0, 0, base_hole_down]) rotate([90, 0, 0])
        cylinder(base_tickness + base_clamp_offset + 10, d = base_holes_diameter, center = true, $fn = 80);
    // Outer
    translate([0, base_tickness/2 + base_clamp_offset, base_hole_down]) rotate([90, 0, 0])
        cylinder(base_clamp_offset + 3, d = base_holes_diameter + 2, center = true, $fn = 80);
}
