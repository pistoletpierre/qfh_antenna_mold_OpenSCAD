include <NopSCADLib/lib.scad>

use <NopSCADLib/vitamins/springs.scad>

debug = false;

function speed_of_light_meter_per_second() = 299792458;


function design_frequency_MHz() = 1575.42;
function wavelength() = speed_of_light_meter_per_second() / design_frequency_MHz() / 1e6;
function num_turns() = 0.5; // multiple of 0.25 from 1-4
function turn_length_in_terms_of_wavelength() = 1;
function bending_radius_mm() = 1;
//function conductor_diameter_mm() = 0.0088 * wavelc;
function conductor_diameter_mm() = 1.7;

function width_to_heigh_ratio() = 0.44;

echo("<b style='color:red'>", wavelength=wavelength());
echo("<b style='color:red'>", conductor_diameter_mm=conductor_diameter_mm());


function wavelength_mm() = wavelength() * 1e3;

//function spring_od(type)     = type[1]; //! Outside diameter
//function spring_gauge(type)  = type[2]; //! Wire gauge
//function spring_length(type) = type[3]; //! Uncompressed length
//function spring_turns(type)  = type[4]; //! Number of turns
//function spring_closed(type) = type[5]; //! Are the ends closed
//function spring_ground(type) = type[6]; //! Are the ends ground flat
//function spring_od2(type)    = type[7] ? type[7] : spring_od(type); //! Second diameter for spiral springs
//function spring_colour(type) = type[8]; //! The colour
//function spring_mesh(type)   = type[9]; //! Optional pre-computed mesh

function perfect_1_manifold_touch_compensation() = 1.0001;

function cylinder_hole_diameter_mm()    = 7;

function cylinder_wall_thickness_mm()   = 2;
function cylinder_top_thickness_mm()    = cylinder_wall_thickness_mm();
function cylinder_bottom_thickness_mm() = cylinder_wall_thickness_mm();

function cylinder_height()           = 62.9;
function cylinder_diameter()         = 27.6;
function cylinder_colour()           = "silver";
function cutout_wire_thickness()     = 2;

function small_lobe_scaling_factor() = 0.95;//0.975;

function small_lobe_height() = cylinder_height() * small_lobe_scaling_factor();
function big_lobe_height()   = cylinder_height();

function my_small_lobe_cutout_width()  = cylinder_diameter()/4;
function my_small_lobe_cutout_length() = cylinder_diameter() * perfect_1_manifold_touch_compensation();
function my_small_lobe_cutout_height() = (cylinder_height() - small_lobe_height());
function my_small_lobe_cutout_height_perfect_overlap_compensation() = (cylinder_height() - small_lobe_height()) * perfect_1_manifold_touch_compensation();



//TODO: adjust shorter strings so that they're 180 at the cutout

big_lobe  = let (
    spring_outer_diameter = cylinder_diameter() + cutout_wire_thickness(),
    spring_gauge          = cutout_wire_thickness(),
    spring_length         = 2 * big_lobe_height(),
    spring_turns          = 1,
    spring_closed         = 0,
    spring_ground         = false,
    spring_od2            = 0,
    spring_colour         = "red"
) [
    "big_lobe",
    spring_outer_diameter,
    spring_gauge,
    spring_length,
    spring_turns,
    spring_closed,
    spring_ground,
    spring_od2,
    spring_colour
];

small_lobe  = let (
    spring_outer_diameter = cylinder_diameter() + cutout_wire_thickness(),
    spring_gauge          = cutout_wire_thickness(),
    spring_length         = 2 * small_lobe_height(),
    spring_turns          = 1,
    spring_closed         = 0,
    spring_ground         = false,
    spring_od2            = 0,
    spring_colour         = "blue"
) [
    "big_lobe",
    spring_outer_diameter,
    spring_gauge,
    spring_length,
    spring_turns,
    spring_closed,
    spring_ground,
    spring_od2,
    spring_colour
];

module my_cutoff_ceiling_cube(starting_height) {
    translate([-cylinder_height()/2,-cylinder_height()/2,starting_height]) cube(size=cylinder_height());
};

module my_cutoff_floor_cube() {
    translate([-cylinder_height()/2,-cylinder_height()/2,(-perfect_1_manifold_touch_compensation())]) {
        rotate(a=[0,180,0]) {
            cube(size=cylinder_height());
        }
    }
};

module my_big_lobe() {
    difference() {
        translate([0,0,-big_lobe_height()/2]) comp_spring(big_lobe);
        my_cutoff_ceiling_cube(big_lobe_height()*perfect_1_manifold_touch_compensation());
        my_cutoff_floor_cube();
    }
};
module my_small_lobe() {
    difference() {
        translate([0,0,-small_lobe_height()/2]) comp_spring(small_lobe);
        my_cutoff_ceiling_cube(small_lobe_height()*perfect_1_manifold_touch_compensation());
        my_cutoff_floor_cube();
    }
};

module my_springs() {
    union() {
        rotate(0)   my_big_lobe();
        rotate(90)  my_small_lobe();
        rotate(180) my_big_lobe();
        rotate(270) my_small_lobe();
    }
};

module my_hollow_out_cylinder() {
    translate([0,0,cylinder_bottom_thickness_mm()]) cylinder(h = (cylinder_height() - cylinder_bottom_thickness_mm()) * perfect_1_manifold_touch_compensation() , d = cylinder_diameter() - (2*cylinder_wall_thickness_mm()), center = false);
}

module my_coax_hole_cylinder() {
    translate([0,0,-1]) cylinder(h = cylinder_height()+2, d = cylinder_hole_diameter_mm(), center = false);
}

module my_cylinder() difference() {
    color(cylinder_colour()) cylinder(h = cylinder_height(), d = cylinder_diameter(), center = false);
    my_coax_hole_cylinder();
    my_hollow_out_cylinder();
}

module my_small_lobe_cutout() cube([my_small_lobe_cutout_width(),my_small_lobe_cutout_length(),my_small_lobe_cutout_height_perfect_overlap_compensation()], center = false); 

module main_object() {
    difference() {
        my_cylinder();
        my_springs();
        //translate([-my_small_lobe_cutout_width()/2.0,-cylinder_diameter()/2,-cylinder_height()*0.01]) my_small_lobe_cutout();
        translate([-my_small_lobe_cutout_width()/2.0,-cylinder_diameter()/2, cylinder_height() - my_small_lobe_cutout_height() ]) my_small_lobe_cutout();
    }
}

if (debug || true) {
    translate([cylinder_diameter() * 0, 0, 0]) main_object();
}
if (debug) {
    translate([cylinder_diameter() * 2, 0, 0]) my_springs(); 
    translate([cylinder_diameter() * 4, 0, 0]) my_cylinder(); 
    translate([cylinder_diameter() * 6, 0, 0]) my_hollow_out_cylinder(); 
    translate([cylinder_diameter() * 8, 0, 0]) my_cutoff_ceiling_cube(starting_height=small_lobe_height());
    translate([cylinder_diameter() * 10, 0, 0]) my_cutoff_floor_cube();
    translate([cylinder_diameter() * 12, 0, 0]) my_small_lobe_cutout();
}