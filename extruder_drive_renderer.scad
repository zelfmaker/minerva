/*
extruder_drive_renderer.scad is the rendering portion of the extruder drive used on Phidias products
Copyright (C) 2015 Gerald Anzalone
Copyright (C) 2017 Bas Wijnen <info@zelfmaker.nl>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

include <extruder_drive.scad>

part = "body";

if (part == "body") // optional-blue-extruder-body.stl
	drive_body(threads = true);

if (part == "idler") // optional-blue-extruder-idler.stl
	extruder_idler_608z();

if (part == "link") // optional-blue-extruder-support-strut.stl
	support_strut();

if (part == "axle") // optional-blue-extruder-axle.stl
	axle_8mm();

if (part == "extruder") // blue-extruder-1x.stl
{
	translate([0,-20,0])
		rotate([0,0,270])
			drive_body(threads = true);

	translate([10, 15 + t_feet, 0]) rotate([0, 0, 90]) extruder_idler_608z();
	translate([10, 36 + t_feet, 0]) support_strut();
	translate([-26, 9 + t_feet, 0]) axle_8mm();
}

// vim: set filetype=c :
