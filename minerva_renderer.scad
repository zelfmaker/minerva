/************************************************************************************ {{{

minerva_renderer.scad - easily select and render parts and plates for manufacture of Minerva platform
Copyright 2015 Jerry Anzalone <info@phidiasllc.com>
Copyright 2017 Bas Wijnen <info@zelfmaker.nl>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

}}} ************************************************************************************/

// include the modules required for rendering
include <minerva.scad>

part = "wire-guide";
plate = "";

// Names have the form:
// <color>-<name>-<quantity>x.<ext>
// name describes the part.  It may contain hyphens.
// parts not used in the default build have a name starting with "optional-".
// color is the color that they are in the reference build.
// quantity is the number of times this file needs to be printed.

// Plates are named:
// plate-<color>-<name>.stl

// Frame: orange. {{{
// Idler end. {{{
if (part == "idler-end") // orange-idler-end-3x.stl
	minerva_end_idler(z_offset_guides = 8, clamp = false);
if (plate == "idler-orange") { // plate-orange-idler.stl
	for (i = [-1:1]) {
		translate([0, i * (w_clamp + t_board + 2) + 17, h_clamp / 2])
			minerva_end_idler(z_offset_guides = 8, clamp = false);
	}
}
// }}}

// Platform clamp. {{{
if (part == "ceramic-clamp") // orange-ceramic-clamp-3x.stl
	ceramic_clamp();
if (plate == "clamp-l") { // plate-orange-clamp-l.stl
	for (x = [0:5], y = [-2:0]) {
		translate([x * 15, y * 40, 0])
			ceramic_clamp([-1]);
	}
}
if (plate == "clamp-r") { // plate-orange-clamp-l.stl
	for (x = [-5:0], y = [-2:0]) {
		translate([x * 15, y * 40, 0])
			ceramic_clamp([1]);
	}
}
// }}}

// Motor end. {{{
if (part == "motor-end") // orange-motor-end-3x.stl
	minerva_end_motor(z_offset_guides = 8, clamp = false);
if (plate == "motor-end") { // plate-orange-motor-end.stl
	translate([0, -w_clamp / 2 - 6, h_clamp / 2])
		minerva_end_motor();
	translate([0, w_clamp / 2 + 6, h_clamp / 2])
		rotate([0, 0, 180])
			minerva_end_motor();
	translate([l_clamp - 6, 0, h_clamp / 2])
		rotate([0, 0, 90])
			minerva_end_motor();
}
// }}}

// Bar clamps. {{{
if (part == "bar-clamp") // orange-bar-clamp-6x.stl
	bar_clamp();
if (part == "bar-clamp-l") // orange-bar-clamp-long-6x.stl
	bar_clamp(long = true);
if (plate == "bar-clamp") { // plate-orange-bar-clamp.stl
	for (x = [-5:6], y = [-1:1]) {
		translate([x * 12, y * 35, t_bar_clamp / 2])
			bar_clamp();
	}
}
// }}}

// Bottom limit switch mount. {{{
if (part == "bottom-switch") // orange-bottom-switch-3x.stl
	bottom_limit_switch();
if (plate == "bottom-switch") { // plate-orange-bottom-switch.stl
	for (x = [-2:2], y = [-2:1]) {
		translate([x * 27, y * 27, 0])
			bottom_limit_switch();
	}
}
// }}}
// }}}

// Moving parts: green. {{{
// Belt terminator for tensioning the belts. {{{
if (part == "belt-terminators") // green-belt-terminators-1x.stl
	minerva_belt_terminators();
if (plate == "belt-terminators") { // plate-green-belt-terminators.stl
	for (x = [-3:3], y = [-3:2]) {
		translate([x * 21, y * 20, 0])
			minerva_free_belt_terminator();
	}
}
// }}}

// carriages ride on the guide rods. {{{
if (part == "carriage") { // green-carriage-1x.stl
	for (n = [0:2]) {
		translate([0, 50 * n, 0])
			minerva_carriage(linear_bearing = bearing_lm8uu, extra = -1, name = "uvw"[n]);
	}
}
if (plate == "carriage") { // plate-green-carriage.stl
	for (n = [0:2]) {
		translate([0, 32 * n, h_carriage / 2])
			minerva_carriage(linear_bearing = bearing_lm8uu, extra = -1, name = "uvw"[n]);
	}
	translate([0, -32, h_carriage / 2])
		minerva_carriage(linear_bearing = bearing_lm8uu, extra = -1, name = "u");
	translate([-70, -20, h_carriage / 2]) {
		rotate([0, 0, 90])
			minerva_carriage(linear_bearing = bearing_lm8uu, extra = -1, name = "v");
	}
	translate([70, -20, h_carriage / 2]) {
		rotate([0, 0, -90])
			minerva_carriage(linear_bearing = bearing_lm8uu, extra = -1, name = "w");
	}
}
// }}}

// The effector holds the tool and connects to the carriages. {{{
if (part == "effector") // green-effector-1x.stl
	tool_effector();
if (plate == "effector") { // plate-green-effector.stl
	tool_effector();
	for (angle = [0:2]) {
		rotate([0, 0, 120 * angle]) {
			translate([0, 70, 0]) {
				rotate([0, 0, 60])
					tool_effector();
			}
		}
	}
}
// }}}

// Cap for mounting bearing balls on carbon fiber tie rods. {{{
if (part == "tierod-cap") // green-tierod-cap-1x.stl
	minerva_tierod_cap(); // This contains 12 caps.
if (plate == "tierod-cap") { // plate-green-tierod-cap.stl
	for (x = [-8:8], y = [-6:5]) {
		translate([x * 14, y * 14, 0])
			minerva_tierod_cap(single = true);
	}
}
// }}}
// }}}

// TODO Cold end and related parts: blue. {{{
// TODO: move cold end into this file.
// mounts to vertical board to which extruder drive is mounted and holds spool - convenience, not required
if (part == "spool-mount") // blue-spool-mount-1x.stl
	minerva_spool_mount();
if (part == "wire-guide") // blue-wire-guide-3x.stl
	minerva_wire_guide();
if (part == "spool-arm") // blue-spool-arm-1x.stl
	minerva_spool_arm();
if (part == "spool-retainer") // blue-spool-retainer-1x.stl
	minerva_spool_retainer();
// }}}

// TODO Electronics: yellow. {{{
// TODO: Add mounting supports.
// Mounting plate fits in slotted motor-end linking board
if (part == "connector-plate") // yellow-connector-plate-1x.stl
	connector_plate(usb = false);

if (part == "melzi-mount") // yellow-melzi-mount-1x.stl
	melzi_mount();
if (part == "orangepizero-mount") // yellow-orangepizero-mount-1x.stl
	orangepizero_mount();
if (part == "electronics-spacer") // yellow-electronics-spacer-4x.stl
	electronics_spacer();
if (part == "electronics-spacer2") // yellow-electronics-spacer2-1x.stl
	electronics_spacer(true);
// }}}

// Hot end and other tools: red. {{{
// Hot end tool body. {{{
if (part == "hotend-tool") // red-hotend-tool-1x.stl
	hotend_tool(headless = true, quickrelease = true, vent = false, dalekify = false, render_thread = false);
if (plate == "hotend-tool") { // plate-red-hotend-tool.stl
	hotend_tool(headless = true, quickrelease = true, vent = false, dalekify = false, render_thread = true);
	for (angle = [0:2]) {
		rotate([0, 0, 120 * angle]) {
			translate([0, 70, 0]) {
				rotate([0, 0, 60])
					hotend_tool(headless = true, quickrelease = true, vent = false, dalekify = false, render_thread = true);
			}
		}
	}
}
// }}}

// Hot end retainer. {{{
if (part == "hotend-retainer") // red-hotend-retainer-1x.stl
	hotend_retainer();
if (plate == "hotend-retainer") { // plate-red-hotend-retainer.stl
	for (x = [-2:2], y = [-6:1]) {
		translate([x * 33, y * 12, 0])
			hotend_retainer();
	}
}
// }}}

// Probe tool. {{{
if (part == "probe-tool") // red-probe-tool-1x.stl
	probe_tool();
if (plate == "probe-tool") { // plate-red-probe-tool.stl
	for (x = [-2:2], y = [-6:1]) {
		translate([x * 33, y * 12, 0])
			probe_tool();
	}
}
// }}}

// Clamp tool. {{{
if (part == "clamp-tool") // red-clamp-tool-1x.stl
	clamp_tool(d_tool = 23);
if (plate == "clamp-tool") { // plate-red-clamp-tool.stl
	for (x = [-2:2], y = [-6:1]) {
		translate([x * 33, y * 12, 0])
			clamp_tool();
	}
}
if (part == "clamp-clamp") // red-clamp-clamp-1x.stl
	clamp_clamp(d_tool = 23);
if (plate == "clamp-clamp") { // plate-red-clamp-clamp.stl
	for (x = [-2:2], y = [-6:1]) {
		translate([x * 33, y * 12, 0])
			clamp_clamp();
	}
}
// }}}
// }}}

// Boards: wood. {{{
// 2-D outline of hexagon to cut out of wood
if (part == "hexagon") // wood-hexagon-1x.svg
	scale(96 / 25.4) minerva_hexagon();

// 2-D outline of rectangular boards to cut out of wood
if (part == "v-boards") // wood-v_boards-1x.svg
	scale(96 / 25.4) minerva_v_boards();

// 2-D outline of rectangular boards to cut out of wood
if (part == "h-boards") // wood-h_boards-1x.svg
	scale(96 / 25.4) minerva_h_boards();
// }}}




// Parts that are not used in the default build. {{{

// Idler end with clamp for aluminum vertical board.
if (part == "idler-end-clamp") // optional-idler-end-clamp-orange-1x.stl
	minerva_end_idler(z_offset_guides = 8, clamp = true);

// Back clamp for aluminum clamps.
if (part == "idler-clamp") // optional-idler-clamp-orange-1x.stl
	minerva_clamp(floor = 0, hole_offset = false, fraction = .5);

// Clamp for aluminum bar at the top.
if (part == "top-clamp") // optional-top-clamp-orange-1x.stl
	minerva_clamp(floor = 1, hole_offset = false, fraction = 1);

// Corner for aluminum bar at the top.
if (part == "top-corner") // optional-top-corner-orange-1x.stl
	minerva_clamp(floor = 2, hole_offset = false, fraction = .5);

// Magnet mount for aluminum bar.
if (part == "top-magnet-mount") // optional-top-magnet-mount-orange-1x.stl
	minerva_top_magnet_mount();

// Motor end with a clamp for aluminum bar.
if (part == "motor-end-clamp") // optional-motor-end-clamp-orange-1x.stl
	minerva_end_motor(z_offset_guides = 8, clamp = true);

// Clamp for motor block.
if (part == "motor-clamp") // optional-motor-clamp-orange-1x.stl
	minerva_clamp(floor = 1, hole_offset = true, fraction = .5);

// Extra high carriages for more stable movement; required for milling.
if (part == "large-carriage") // optional_large-carriage-green-1x.stl
	for (n = [0:2]) translate([0, 50 * n, 0]) minerva_carriage(linear_bearing = bearing_lm8uu, extra = 10, name = "uvw"[n]);

// the roller switch mount - 3 required for Parthenos
if (part == "central-limit-switch") // central-limit-switch-orange-3x.stl
	central_limit_switch();

// Mount for pcb spindle.  WIP.
if (part == "spindle-mount") // optional-spindle-mount-orange-1x.stl
	spindle_mount();

// if the platform uses a BBB and melzi, one of these is required
if (part == "bbb-melzi-mount") // optional-bbb-melzi-mount-yellow-1x.stl
	bbb_melzi_mount(render_large = true, render_small = true);

// mounts to vertical board, holds magnetic tools not in use and hides wires - convenience, not required for Parthenos
if (part == "tool-holder") // optional-tool-holder-blue-1x.stl
	minerva_tool_holder();

// mounts to vertical board, holds tools and hides wires - convenience, not required
if (part == "hand-tool-holder") // optional-hand-tool-holder-blue-1x.stl
	minerva_hand_tool_holder(wood_mount = true, sonicare_magnet = false);

// for holding glass to base plate
if (part == "glass-holddown") // optional-glass-holddown-3x.stl
	glass_holddown();

// shroud mounted to bottom of end effector for improved print cooling
if (part == "hotend-shroud") // optional-hotend-shroud-red-1x.stl
	hotend_shroud(height = 18, twist = 5);

// Hexagon with a gap for the aluminum arm.
if (part == "hexagon-arm") // optional-hexagon-wood-1x.svg
	scale(96 / 25.4) minerva_hexagon(top_mount = true);

// 2-D outline of tie rod (need 2 parts for one tie rod; 12 parts total)
if (part == "tierod") // optional-tierod-12x.svg
	scale(96 / 25.4) minerva_tierod();

// Mount for pcb used for milling.
if (part == "pcb-mount") // optional-pcb-mount-1x.stl
	pcb_mount();
// }}}

// When rendering a plate, show platform shape for fitting the parts. {{{
module platform_apex(angle) {
	rotate([0, 0, angle]) {
		intersection() {
			translate([0, r_printer - r_effector - carriage_offset, -2])
				cylinder(r = l_tierod, h = 4);
			translate([-l_tierod, -l_tierod, angle == 0 ? -1 : -2])
				cube([2 * l_tierod, l_tierod + r_printer - r_effector - carriage_offset, angle == 0 ? 1 : 4]);
		}
	}
}

if (plate != "") {
	echo(l_tierod, r_printer, r_printer - r_effector - carriage_offset);
	%intersection() {
		intersection() {
			platform_apex(0);
			platform_apex(120);
		}
		platform_apex(-120);
	}
}
// }}}
// vim: set foldmethod=marker filetype=c :
