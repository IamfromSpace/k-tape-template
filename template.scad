module template(
  thickness, // distance from the bottom of the template to the bottom of the groove
  groove_depth, // distance from the top of the template to the bottom of the groove
  groove_width,
  tape_width,
  roundedness, // how round the edges should be, where 0 is square and 1 is a single circle with the radius equal to half the tape's depth
  overhang, // the length of tape on the template beyond the final groove
  guard_depth, // the length from the top of the template to the top of the guard
  guard_width,
) {
  module quadrant() {
    ideal_radius = roundedness * tape_width / 2;
    inner_radius = ideal_radius - groove_width/2;
    outer_radius = ideal_radius + groove_width/2;
    ggd = groove_depth + guard_depth;

    difference() {
      union() {
        // base
        translate([0, 0, -thickness])
          cube([ideal_radius + overhang, (tape_width + $allowance)/2 + guard_width, groove_depth + thickness]);

        // guard
        translate([0, (tape_width + $allowance)/2, 0])
          cube([ideal_radius + overhang, guard_width, ggd]);
      }

      // circular groove
      translate([0, tape_width/2 - ideal_radius, 0])
        intersection() {
          translate([ideal_radius, 0, 0])
            difference() {
              cylinder(ggd, outer_radius, outer_radius);
              cylinder(ggd, inner_radius, inner_radius);
            }
          cube([ideal_radius, outer_radius, ggd]);
        }

      // center groove that connects the circles
      cube([groove_width/2, tape_width/2 - ideal_radius + $fudge, ggd]);

      // groove along the tape edge
      translate([ideal_radius, (tape_width - groove_width)/2, 0])
        cube([inner_radius, groove_width, ggd]);
    }
  }

  for(i = [0:3])
    mirror([0, i % 2, 0])
    mirror([floor(i / 2), 0, 0])
      quadrant();
}

template(
  thickness = 2,
  groove_depth = 1.5,
  groove_width = 1,
  tape_width = 50.8, // 2in
  roundedness = 2/3,
  overhang = 5,
  guard_depth = 2,
  guard_width = 2,
  $allowance = 0.7,
  $fn = 120,
  $fudge = 0.0001
);
