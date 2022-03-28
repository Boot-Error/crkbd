tiny_2040_xw = 18;
tiny_2040_yw = 20;

trrs_xw = 14;
trrs_yw = 5.8;
trrs_zw = 4.8;

pos_x1 = 28.55;
crkbd_screw_holes = [
    [pos_x1, -64.4],        // Bottom left
    [pos_x1, -45.3],        // Top left
    [72.0, -81.6],          // Bottom mid
    [104.89, -41.7],        // Top right
    [118.7, -89.37],        // Bottom right
    ];

base_plate_thickness = 3.3;
top_plate_thickness = 4;

case_height = 12.5;

module crkbd_bottom_plate(center) {
  import("svg/crkbd-left-bottom.svg", convexity=4, center=center);
}

module crkbd_top_plate(center) {
  import("svg/crkbd-left-top.svg", convexity=4, center=center);
}

module crkbd_top_plate_thick(center) {
  import("stl/crkbd-top-plate-thick.stl", convexity=4, center=center);
}

module tiny_2040() {
  cube([tiny_2040_xw, tiny_2040_yw, 1.3], center = true);
  translate([0, tiny_2040_yw/2 - 7.2/2 + 2, 1.3]) {
    cube([8.9, 7.2, 3], center = true);
  }
}

module bottom_case_inner_support() {
  support_height = case_height - top_plate_thickness;
  difference() {
    linear_extrude(support_height) {
      crkbd_top_plate(center = true);
    }
    xy_scale_factor = 0.95;
    linear_extrude(support_height + 2) {
      scale([xy_scale_factor, xy_scale_factor, 0]) {
        crkbd_top_plate(center = true);
      }
    }
    // correction for the keys to pass through
    translate([-91, 4.5, 0]) {
      cube([5, 71, 20], center = true);
    }
    translate([50, -7, 3]) {
        cube([10, 20, 6]);
      }
    }
}

module bottom_case_holes() {
  // usb c hole
  translate([63.5, 45, 3]) {
    minkowski() {
      sphere(1);
      cube([12, 10, 5]);
    }
  }

  // aux hole
  translate([80, -10, 3]) {
    minkowski() {
      sphere(1);
      cube([10, 12, 5]);
    }
  }
}

module crkbd_bottom_case() {
  xy_scale_factor = 1.08;
  difference() {
    linear_extrude(case_height) {
      scale([xy_scale_factor, xy_scale_factor, 0]) {
        crkbd_bottom_plate(center = true);
      }
    }
    translate([0, 0, base_plate_thickness]) {
      linear_extrude(case_height) {
        crkbd_bottom_plate(center = true);
      }
    }
    bottom_case_holes();
  }
  translate([0, 4, 0]) {
    bottom_case_inner_support();
  }
}

module main() {
  scale([0.75, 0.76, 1]) {
    crkbd_bottom_case();
  }
  // translate([52, 25, 4]) {
  //   color([200/255, 12/255, 2/255]) {
  //     tiny_2040();
  //   }
  // }
  // translate([-70, -19, 12]) {
  //   mirror([1, 0, 0]) {
  //     rotate([0, 180, 180]) {
  //       crkbd_top_plate_thick(center = true);
  //     }
  //   }
  // }
}

main();

$fn = 90;