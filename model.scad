t_fix = 0.5;
s_fix = 2 * t_fix;
thickness = 2;

module box(thickness = 1, depth = 10, width = 10, height = 10) {
  // left
  cube([thickness, depth, height]);
  // right
  translate([width - thickness, 0, 0])
    cube([thickness, depth, height]);
  // front
  translate([width, 0, 0])
    rotate(90, [0,0,1])
      cube([thickness, width, height]);
  // back
  translate([width, depth - thickness, 0])
    rotate(90, [0,0,1])
      cube([thickness, width, height]);

  //bottom
  rotate(90, [0,0,-1])
    rotate(90, [0,-1,0])
      cube([thickness, width, depth]);
}

module handle(thickness = 1, inner_depth = 10, inner_width = 10, inner_height = 10, border = 4) {
  difference() {
    box(thickness , inner_depth, inner_width, inner_height);
    translate([border + thickness, -t_fix, border + thickness])
      cube([inner_width - (2 * border) - (2 * thickness), thickness + s_fix, inner_height]);
  }
}

module partial() {
  thickness = 2;
  inner_depth = 11;
  inner_width = 73;
  inner_height = 16.5;

  handle(thickness = thickness,
      inner_depth = inner_depth + (2 * thickness),
      inner_width = inner_width + (2 * thickness),
      inner_height = inner_height + (2 * thickness));
}

module landscape() {
  thickness = 2;
  inner_depth = 11;
  inner_width = 142;
  inner_height = 16.5;

  handle(thickness = thickness,
      inner_depth = inner_depth + (2 * thickness),
      inner_width = inner_width + (2 * thickness),
      inner_height = inner_height + (2 * thickness));
}

// plate
module plate(width=116, depth=40) {
  hole_size = depth / 2;
  hole_r = hole_size / 2;

  t_l2 = (width / 2) - hole_size;

  l1 = hole_size;
  l2 = l1 > t_l2 ? hole_size : t_l2;

  t_r1 = (width / 2) + hole_size;

  r2 = width - hole_size;
  r1 = t_r1 > r2 ? r2 : t_r1;

  difference() {
    union() {
      translate([hole_r, depth - hole_r, 0])
        cylinder(2, r=hole_r);
      translate([width - hole_r, depth - hole_r, 0])
        cylinder(2, r=hole_r);
     cube([width, depth - hole_r, 2]);
      translate([hole_r, hole_r, 0])
        cube([width - hole_r - hole_r, depth - hole_r, 2]);
    }

    translate([l1, hole_size, -0.5])
      cylinder(3, r = hole_r);
    translate([l2, hole_size, -0.5])
      cylinder(3, r = hole_r);
    translate([r1, hole_size, -0.5])
      cylinder(3, r = hole_r);
    translate([r2, hole_size, -0.5])
      cylinder(3, r = hole_r);

    translate([(width / 2) + hole_size, hole_r, -0.5])
      cube([r2 - r1,hole_size,10]);
    translate([hole_size, hole_r, -0.5])
      cube([l2 - l1, hole_size,10]);
  }
}

translate([0,13,-2.5])
  plate(width=116, depth=40);

// connector
translate([0,0,-2.5])
  cube([77,8,2.5]);

rotate(-10, [1, 0, 0])
  partial();
rotate(10, [1, 0, 0])
  translate([0,-0.5, -2.5])
    mirror([0,0,1])
      landscape();
