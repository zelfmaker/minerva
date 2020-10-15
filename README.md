#Minerva
Minerva is a general purpose robot, including 3-D printer, designed and
produced by De Zelfmaker.  This repository contains the source files for the
printed and laser cut parts of the machine.

The machine is based on [Phidias, llc's Athena](http://github.com/phidiasllc/athena).

#Design philosophy
The design of this machine is based on the following principles:

  - As much as possible, use the same type of nuts and bolts everywhere. The chosen value is M3x16. Where a longer bolt was required, M3x30 has been used if possible.
  - As much as possible, things can be taken apart. This means there are no screws anywhere in the machine. Glue is avoided when possible.
  - All dimensions are metric.

#How to build
Build instructions will (hopefully) follow later. Here's a summary.

The machine consists of printed parts, laser cut wooden parts and so called
vitamins that need to be purchased.

Most printed parts and all wooden parts are rendered from
minerva\_renderer.scad. The extruder's printed parts are rendered in the same
way from extruder\_drive\_renderer.scad.

Near the top of both files is a line that defines the part variable.  That
should be set to all required parts in turn and then the file should be
rendered. All possible parts are later in the file as:

if (part == "...") // filename

The printed parts in the file have filenames with the stl extention. Wooden
parts have the svg extension.

The svg files need to be opened in an editor such as Inkscape. The files
contain instructions on the required changes. The shapes are meant to be cut
out on a laser cutter from 5mm plywood. When using a different thickness, the
"wood" variable in minerva\_renderer.scad should be adjusted.

#Vitamins
The motors in the machine are NEMA17. Most bolts are M3x16. The longer bolts
are M3x30. The thick bolts in the idlers are M8x40. Every bolt should have a
washer on each side without a nut trap.

The carriages are connected using GT2 timing belts. The pulleys on the motors
have 16 cogs. Most bearings are 608zz.  The extruder contains one 625zz
bearing. The linear bearings are lm8uu.

Depending on the settings, the magnets that are used have a diameter of 10 or
12 mm with a height of 2.8 or 4.8 mm respectively. The bearing balls that are
used with the magnets are 9.5 or 12 mm respectively.

The tie rods are carbon fibre rods of 20 cm length. Including the tie rod caps,
the center to center distance is 250 mm. The lengths of the rods need to be of
as equal length as possible. It is strongly recommended to buy them at length
and not to cut them manually.

The machine expects an Orange Pi Zero computer and a Melzi 2 control board.
They are mounted on printed parts and connected to the motor ends.

The build platform is a hexagonal ceramic tile.
