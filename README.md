# qfh_antenna_mold_OpenSCAD

[OpenSCAD](https://www.openscad.org/) parametric model of a [QFH antenna](https://en.wikipedia.org/wiki/Helical_antenna) mold.

Currently, antenna dimensions (height, width, wire thickness, coax hole width, etc...) are are the starting point for generating the model (currently sized for [L1 GPS](https://en.wikipedia.org/wiki/GPS_signals)) with the help of [John Coppens' dimension calculator](http://jcoppens.com/ant/qfh/calc.en.php)

Goal is to be able to plug those calculator inputs in to the OpenSCAD script & calculate appropriate dimensions for a perfectly-sized 3D-printable mold around which to wrap your wire & connect it to your coax.

## Images

QFH antenna
![QFH antenna](images/00_QFH_antenna.jpg)

L1 GPS (1575.42 MHz) in OpenSCAD GUI
![Model for L1 GPS QFH antenna in OpenSCAD GUI](images/01_OpenSCAD_model.jpg)

Printed L1 GPS antenna mold
![Printed L1 GPS QFH antenna mold](images/02_L1_GPS_print.jpg)