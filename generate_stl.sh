# Usage: ./generate_stl.sh <.scad file>
SCAD_FILE=${1:-antenna_mold_from_cli.scad}
STL_FILE=${SCAD_FILE/.scad/.stl}

OPENSCAD_EXEC=$(which openscad)

# MacOS openscad path if 'openscad' not in PATH
OPENSCAD_EXEC=${OPENSCAD_EXEC:-"/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"}

# Generate .STL for slicer
${OPENSCAD_EXEC} -o antenna_mold_from_cli.stl ./antenna_mold_nopscadlib.scad

# Curious that the GUI generates a different file from the CLI - haven't looked at the difference(s) yet. Don't know enough to rule out non-determinism, but that would be surprising.
sha256sum *.stl
