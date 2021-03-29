include <NopSCADLib/lib.scad>

use <NopSCADLib/vitamins/springs.scad>

//
// Script settings
//
debug = false;


///////////////////////
// Physical settings //
///////////////////////
design_frequency_MHz = 1575.42;
//design_frequency_MHz = 2.45e3;
//design_frequency_MHz = 5.45e3;
conductor_bending_radius_mm = 1;
conductor_diameter_mm = 1.7;
width_to_heigh_ratio = 0.44;


// keeping these here to keep them close to John Coppens's other knobs, but for now these should keep their current values
function num_turns() = 0.5; // multiple of 0.25 from 1-4
function turn_length_in_terms_of_wavelength() = 1;

////////////////////////
// Practical settings //
////////////////////////
cylinder_hole_diameter_mm    = 4;
cylinder_wall_thickness_mm   = 2;






//
// Functions
//
function speed_of_light_meter_per_second() = 299792458;

function strToInt(str) = 
    let(d = [for (s = str) ord(s) - 48], l = len(d) - 1)
    [for (i = 0, a = d[i];i <= l;i = i + 1, a = 10 * a + d[i]) a][l];

function deltal_lookup_table() = [1.045, 1.053, 1.060, 1.064, 1.068, 1.070, 1.070, 1.071, 1.071, 1.070, 1.070, 1.070, 1.070, 1.069, 1.069, 1.068, 1.067] ;

function deltal(diam) = (deltal_lookup_table()[round(diam)] + (deltal_lookup_table()[round(diam)+1]-deltal_lookup_table()[round(diam)])*(diam-round(diam)));
  









function wavelength_mm() = (speed_of_light_meter_per_second() / (design_frequency_MHz * 1e6)) * 1e3;

function wd_eff() = (conductor_diameter_mm > 15) ? 15 : conductor_diameter_mm;
function wavelength_mm_compensated() = wavelength_mm() * deltal(wd_eff());
function optimum_conductor_diameter_mm() = 0.0088 * wavelength_mm_compensated();


function bending_correction_mm() = (2*conductor_bending_radius_mm) - (PI*conductor_bending_radius_mm/2);


echo("<b style='color:blue'>", conductor_diameter_mm=conductor_diameter_mm);
echo("<b style='color:red'>",  optimum_conductor_diameter_mm=optimum_conductor_diameter_mm());
echo("<b style='color:blue'>", wavelength_mm=wavelength_mm());
echo("<b style='color:blue'>", wavelength_mm_compensated=wavelength_mm_compensated());
echo("<b style='color:blue'>", bending_correction_mm=bending_correction_mm());


echo("<b style='color:blue'>");

//
// larger loop 
//
function big_lobe_total_length_mm()                = wavelength_mm_compensated() * 1.026;
function big_lobe_total_length_mm_compensated()    = big_lobe_total_length_mm() + (4 * bending_correction_mm());
function big_lobe_rad()                            = 0.5 * big_lobe_total_length_mm_compensated() / (1 + sqrt(1/pow(width_to_heigh_ratio,2) + pow(num_turns()*PI,2)));
function big_lobe_vertical_separator()             = (big_lobe_total_length_mm_compensated() - 2*big_lobe_rad())/2;

function big_lobe_height()                         = big_lobe_rad() / width_to_heigh_ratio;
function big_lobe_inner_diam()                     = big_lobe_rad() - conductor_diameter_mm;
function big_lobe_rad_compensated()                = big_lobe_rad()-(2*conductor_bending_radius_mm);
function big_lobe_vertical_separator_compensated() = big_lobe_vertical_separator() - (2*conductor_bending_radius_mm);    



echo("<b style='color:green'>", big_lobe_total_length_mm=big_lobe_total_length_mm());
echo("<b style='color:green'>", big_lobe_vertical_separator=big_lobe_vertical_separator());
echo("<b style='color:green'>", big_lobe_total_length_mm_compensated=big_lobe_total_length_mm_compensated());
echo("<b style='color:green'>", big_lobe_vertical_separator_compensated=big_lobe_vertical_separator_compensated());

echo("<b style='color:green'>", big_lobe_height_H1=big_lobe_height());
echo("<b style='color:green'>", big_lobe_inner_diam_Di1=big_lobe_inner_diam());
echo("<b style='color:green'>", big_lobe_rad_D1=big_lobe_rad());
echo("<b style='color:green'>", big_lobe_rad_compensated_Dc1=big_lobe_rad_compensated());

echo("<b style='color:blue'>");

//
// smaller loop 
//
function small_lobe_total_length_mm()                = wavelength_mm_compensated() * 0.975;
function small_lobe_total_length_mm_compensated()    = small_lobe_total_length_mm() + (4 * bending_correction_mm());
function small_lobe_rad()                            = 0.5 * small_lobe_total_length_mm_compensated() / (1 + sqrt(1/pow(width_to_heigh_ratio,2) + pow(num_turns()*PI,2)));
function small_lobe_vertical_separator()             = (small_lobe_total_length_mm_compensated() - 2*small_lobe_rad())/2;

function small_lobe_height()                         = small_lobe_rad() / width_to_heigh_ratio;
function small_lobe_inner_diam()                     = small_lobe_rad() - conductor_diameter_mm;
function small_lobe_rad_compensated()                = small_lobe_rad()-(2*conductor_bending_radius_mm);
function small_lobe_vertical_separator_compensated() = small_lobe_vertical_separator() - (2*conductor_bending_radius_mm);    

echo("<b style='color:green'>", small_lobe_total_length_mm=small_lobe_total_length_mm());
echo("<b style='color:green'>", small_lobe_vertical_separator=small_lobe_vertical_separator());
echo("<b style='color:green'>", small_lobe_total_length_mm_compensated=small_lobe_total_length_mm_compensated());
echo("<b style='color:green'>", small_lobe_vertical_separator_compensated=small_lobe_vertical_separator_compensated());

echo("<b style='color:green'>", small_lobe_height_H2=small_lobe_height());
echo("<b style='color:green'>", small_lobe_inner_diam_Di2=small_lobe_inner_diam());
echo("<b style='color:green'>", small_lobe_rad_D2=small_lobe_rad());
echo("<b style='color:green'>", small_lobe_rad_compensated_Dc2=small_lobe_rad_compensated());

























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



function cylinder_top_thickness_mm()    = cylinder_wall_thickness_mm;
function cylinder_bottom_thickness_mm() = cylinder_wall_thickness_mm;

function cylinder_height()           = big_lobe_height();
function cylinder_diameter()         = big_lobe_rad();
function cylinder_colour()           = "silver";
function cutout_wire_thickness()     = conductor_diameter_mm+1;



function my_small_lobe_cutout_width()  = cylinder_diameter()/4;
function my_small_lobe_cutout_length() = cylinder_diameter() * perfect_1_manifold_touch_compensation();
function my_small_lobe_cutout_height() = (cylinder_height() - small_lobe_height());
function my_small_lobe_cutout_height_perfect_overlap_compensation() = (cylinder_height() - small_lobe_height()) * perfect_1_manifold_touch_compensation();



//TODO: center the conductor hole in the springs 
function outer_gauge_multiple() = 2;
function outer_gauge() = cutout_wire_thickness()*outer_gauge_multiple();
big_lobe  = let (
    spring_outer_diameter = (big_lobe_inner_diam() + conductor_diameter_mm) + (outer_gauge()/2),
    spring_gauge          = outer_gauge(),
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

big_lobe_subtract  = let (
    spring_outer_diameter = (big_lobe_inner_diam() + conductor_diameter_mm),
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
    spring_outer_diameter = (small_lobe_inner_diam() + cutout_wire_thickness()) + (outer_gauge() / 2),
    spring_gauge          = outer_gauge(),
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

small_lobe_subtract  = let (
    spring_outer_diameter = (small_lobe_inner_diam() + cutout_wire_thickness()),
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

module my_big_lobe_solid() {
    difference() {
        translate([0,0,-big_lobe_height()/2]) comp_spring(big_lobe);
        my_cutoff_ceiling_cube(big_lobe_height()*perfect_1_manifold_touch_compensation());
        my_cutoff_floor_cube();
    }
};

module my_big_lobe_hollow() {
    difference() {
        difference() {
            translate([0,0,-big_lobe_height()/2]) comp_spring(big_lobe);
            translate([0,0,-big_lobe_height()/2]) comp_spring(big_lobe_subtract);
        }
        my_cutoff_ceiling_cube(big_lobe_height()*perfect_1_manifold_touch_compensation());
        my_cutoff_floor_cube();
    }
};

module my_small_lobe_solid() {
    difference() {
        //difference() {
            translate([0,0,-small_lobe_height()/2]) comp_spring(small_lobe);
        //};
        my_cutoff_ceiling_cube(small_lobe_height()*perfect_1_manifold_touch_compensation());
        my_cutoff_floor_cube();
    }
};

module my_small_lobe_hollow() {
    difference() {
        difference() {
            translate([0,0,-small_lobe_height()/2]) comp_spring(small_lobe);
            translate([0,0,-small_lobe_height()/2]) comp_spring(small_lobe_subtract);
        }
        my_cutoff_ceiling_cube(small_lobe_height()*perfect_1_manifold_touch_compensation());
        my_cutoff_floor_cube();
    }
};

module my_springs() {
    difference() {
        union() {
            rotate(0)   my_big_lobe_hollow();
            rotate(90)  my_small_lobe_hollow();
            rotate(180) my_big_lobe_hollow();
            rotate(270) my_small_lobe_hollow();
            //cube(size=cylinder_height(), center=true);
        };
        translate([0,0,-cylinder_height()/2]) cube(size=cylinder_height(), center=true);
    }
};

module my_springs_solid() {
    union() {
        rotate(0)   my_big_lobe_solid();
        rotate(90)  my_small_lobe_solid();
        rotate(180) my_big_lobe_solid();
        rotate(270) my_small_lobe_solid();
    }
};

module my_hollow_out_cylinder() {
    translate([0,0,cylinder_bottom_thickness_mm()]) cylinder(h = (cylinder_height() - cylinder_bottom_thickness_mm()) * perfect_1_manifold_touch_compensation() , d = cylinder_diameter() - (2*cylinder_wall_thickness_mm), center = false);
}

module my_coax_hole_cylinder() {
    translate([0,0,-1]) cylinder(h = cylinder_height()+2, d = cylinder_hole_diameter_mm, center = false);
}

module my_cylinder() difference() {
    color(cylinder_colour()) cylinder(h = cylinder_height(), d = cylinder_diameter(), center = false);
    my_coax_hole_cylinder();
    my_hollow_out_cylinder();
}

module my_small_lobe_cutout() cube([my_small_lobe_cutout_width(),my_small_lobe_cutout_length(),my_small_lobe_cutout_height_perfect_overlap_compensation()], center = false); 

module my_label() {
    linear_extrude(height=1) {
        text(str(design_frequency_MHz),size=2, halign="center");
    }
}



// TODO: this label stuff is kinda slapdash - improve
function label_text() = str(str(design_frequency_MHz), "MHz");
function chars_per_circle() = len(label_text());
function step_angle() = (360 / 2) / chars_per_circle();
function char_size() = (cylinder_diameter() * PI / 2) / chars_per_circle();
function char_height_beyond_cylinder_surface() = 0.5;
function char_height() = char_height_beyond_cylinder_surface() * 2;
char_thickness = 1;
module my_label() {
    for(i = [0 : len(label_text()) - 1]) {
        translate([0,0,i*((char_size() * 1.3)) + (char_size()/4)])
            rotate(45 + (i * step_angle()))
                translate([0, -(cylinder_diameter()/2) + (char_height() / 2), 0]) 
                    rotate([90, 0, 0]) linear_extrude(height=char_height()) 
                         text(
                            str(label_text())[i], 
                            font = "Courier New; Style = Bold", 
                            size = char_size(), 
                            //valign = "center",
                            halign = "center"
                        );
    }
}



module main_object() {
    difference() {
        union() {
            difference() {
                my_cylinder();
                my_springs_solid();
                
            };
            my_springs();
            color("silver") my_label();
        }
        //translate([-my_small_lobe_cutout_width()/2.0,-cylinder_diameter()/2,-cylinder_height()*0.01]) my_small_lobe_cutout();
        translate([-my_small_lobe_cutout_width()/2.0,-cylinder_diameter()/2, cylinder_height() - my_small_lobe_cutout_height() ]) my_small_lobe_cutout();
    }
}

if (true) {
    translate([cylinder_diameter() * 0, 0, 0]) main_object();
    
}
if (debug) {
    translate([cylinder_diameter() * 2, 0, 0]) my_springs(); 
    //rotate([135,135,270])
      translate([cylinder_diameter() * 4, 0, 0]) my_cylinder(); 
    translate([cylinder_diameter() * 6, 0, 0]) my_hollow_out_cylinder(); 
    translate([cylinder_diameter() * 8, 0, 0]) my_cutoff_ceiling_cube(starting_height=small_lobe_height());
    translate([cylinder_diameter() * 10, 0, 0]) my_cutoff_floor_cube();
    translate([cylinder_diameter() * 12, 0, 0]) my_small_lobe_cutout();
    translate([cylinder_diameter()*14,0,0]) { my_label(); }
}

