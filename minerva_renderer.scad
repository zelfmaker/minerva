/************************************************************************************

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

************************************************************************************/

// include the modules required for rendering
include <minerva.scad>

part = "hotend-tool";
plate = 0;

// renders individual parts
// end that holds motor - 3 required

// Mount for pcb spindle.  WIP.
if (part == "spindle-mount") // spindle-mount.stl
	spindle_mount();

// Idler end.
if (part == "idler-end") // idler-end-3x.stl
	minerva_end_idler(z_offset_guides = 8, clamp = false);

// Idler end with clamp for aluminum vertical board.
if (part == "idler-end-clamp") // idler-end-clamp.stl
	minerva_end_idler(z_offset_guides = 8, clamp = true);

// Back clamp for aluminum clamps.
if (part == "idler-clamp") // idler-clamp.stl
	minerva_clamp(floor = 0, hole_offset = false, fraction = .5);

// Clamp for aluminum bar at the top.
if (part == "top-clamp") // top-clamp.stl
	minerva_clamp(floor = 1, hole_offset = false, fraction = 1);

// Corner for aluminum bar at the top.
if (part == "top-corner") // top-corner.stl
	minerva_clamp(floor = 2, hole_offset = false, fraction = .5);

// Magnet mount for aluminum bar.
if (part == "top-magnet-mount") // top-magnet-mount.stl
	minerva_top_magnet_mount();

// end that holds idler bearings and end limit switches - 3 required
if (part == "motor-end") // motor-end-3x.stl
	minerva_end_motor(z_offset_guides = 8, clamp = false);

// Motor end with a clamp for aluminum bar.
if (part == "motor-end-clamp") // motor-end-clamp.stl
	minerva_end_motor(z_offset_guides = 8, clamp = true);

// Clamp for motor block.
if (part == "motor-clamp") // motor-clamp.stl
	minerva_clamp(floor = 1, hole_offset = true, fraction = .5);

// clamps the guide rods firmly to motor/idler ends - 12 required
if (part == "bar-clamp") // bar-clamp-12x.stl
	bar_clamp();

// permits tensioning of belts; all three are contained in one instance.
if (part == "belt-terminators") // belt-terminators-1x.stl
	minerva_belt_terminators();

// carriages ride on the guide rods 3 required for Parthenos
if (part == "carriage") // carriage.stl
	for (n = [0:2]) translate([0, 50 * n, 0]) minerva_carriage(linear_bearing = bearing_lm8uu, extra = 10, name = "uvw"[n]);

// the roller switch mount - 3 required for Parthenos
if (part == "central-limit-switch") // central-limit-switch-3x.stl
	central_limit_switch();

// the bottom limit switch mount
if (part == "bottom-switch") // bottom-switch-3x.stl
	bottom_limit_switch();

// if the platform uses a BBB and melzi, one of these is required
if (part == "bbb-melzi-mount") // bbb-melzi-mount.stl
	bbb_melzi_mount(render_large = true, render_small = true);

// mounts to vertical board, holds magnetic tools not in use and hides wires - convenience, not required for Parthenos
if (part == "tool-holder") // tool-holder.stl
	minerva_tool_holder();

// mounts to vertical board to which extruder drive is mounted and holds spool - convenience, not required
if (part == "spool-holder") // spool-holder-1x.stl
	minerva_spool_holder(render_mount = true, render_holder = true, mount_wood = true);

// mounts to vertical board, holds tools and hides wires - convenience, not required
if (part == "hand-tool-holder") // hand-tool-holder.stl
	minerva_hand_tool_holder(wood_mount = true, sonicare_magnet = false);

// Mounting plate fits in slotted motor-end linking board, one required; print with support
if (part == "connector-plate") // connector-plate-1x.stl
	connector_plate();

// for holding glass to base plate, three required
if (part == "glass-holddown") // glass-holddown.stl
	glass_holddown();

if (part == "ceramic-clamp") // ceramic-clamp-3x.stl
	ceramic_clamp();

if (part == "effector") // effector-1x.stl
	tool_effector();

if (part == "hotend-tool") // hotend-tool-1x.stl
	hotend_tool(headless = true, quickrelease = true, vent = false, dalekify = false, openfront = true, render_thread = false);

// shroud mounted to bottom of end effector for improved print cooling
if (part == "hotend-shroud") // hotend-shroud.stl
	hotend_shroud(height = 18, twist = 5);

// 2-D outline of hexagon to cut out of wood
if (part == "hexagon") // hexagon.svg
	scale(96 / 25.4) minerva_hexagon();

if (part == "hexagon-arm") // hexagon.svg
	scale(96 / 25.4) minerva_hexagon(top_mount = true);

// 2-D outline of rectangular boards to cut out of wood
if (part == "v-boards") // v_boards.svg
	scale(96 / 25.4) minerva_v_boards();

// 2-D outline of rectangular boards to cut out of wood
if (part == "h-boards") // h_boards.svg
	scale(96 / 25.4) minerva_h_boards();

// 2-D outline of tie rod (need 2 parts for one tie rod; 12 parts total)
if (part == "tierod") // tierod.svg
	scale(96 / 25.4) minerva_tierod();

// Cap for mounting bearing balls on carbon fiber tie rods.
if (part == "tierod-cap") // tierod-cap.stl
	minerva_tierod_cap();

if (part == "pcb-mount") // pcb-mount.stl
	pcb_mount();

// renders production plates
// approximate build circle to assure placement and fit on build platform
//	color([1, 0, 0])
//		circle(r = 125);

if (plate == 1)
	for (i = [-1:1])
		translate([0, i * (w_clamp + 2) + 20, 0])
			minerva_end_idler(z_offset_guides = 8);

if (plate == 2) {
	translate([0, -w_clamp / 2 - 6, 0])
		minerva_end_motor();

	translate([0, w_clamp / 2 + 6, 0])
		rotate([0, 0, 180])
			minerva_end_motor();

	translate([l_clamp - 6, 0, 0])
		rotate([0, 0, 90])
			minerva_end_motor();
}

// hot end effector
if (plate == 3) {
	hotend_effector(quickrelease = true, dalekify = false);
}

// fixed terminators
if (plate == 4) {
	for (i = [-3:2], j = [-1:1])
		//rotate([0, 0, i * 120])
			translate([i * 11, j * 32, 0])
				minerva_fixed_belt_terminator();
}

// free terminators
if (plate == 5) {
	for (i = [-3:2], j = [-1:1])
		//rotate([0, 0, i * 120])
			translate([i * 11, j * 25, 0])
				minerva_free_belt_terminator();
}

// bar clamps
if (plate == 6) {
	translate([-h_bar_clamp / 2 - 6, -w_clamp - 1, t_bar_clamp / 2])
		for (i = [0:2])
			for (j = [-4:3])
				translate([j * -(h_bar_clamp + 1), i * (w_clamp + 1), 0])
					bar_clamp();
}

if (plate == 7) {
	// Parthenos carriages
	translate([22, -2, 0])
		rotate([0, 0, 180])
			minerva_convertible_carriage();

	minerva_convertible_carriage();

	translate([14, -39, 0])
		rotate([0, 0, 180])
			minerva_convertible_carriage();
}

if (plate == 8) {
	translate([22, -2, 0])
		rotate([0, 0, 180])
			minerva_basic_carriage();

	minerva_basic_carriage();

	translate([14, -34, 0])
		rotate([0, 0, 180])
			minerva_basic_carriage();
}

if (plate == 9) {
	for (i = [-1:1], j = [-2:1])
		translate([i * 19, j * 22 + ((i == 0) ? 11 : 0), 0])
			thumbscrew_quickrelease();
}

if (plate == 10) {
	for (i = [-1:1], j = [-1,0])
		translate([i * 30, j * 25 + 12.5, 0])
		minerva_spool_holder(
			render_mount = true,
			render_holder = false,
			mount_wood = true);
}

if (plate == 11) {
	for(i = [-1:1])
		translate([0, i * 55, 0])
			bbb_melzi_mount(render_large = true, render_small = false);

}

module hotend_shroud(
	height,
	twist
) {
	t_shroud_base = 2.5;
	t_shroud = 0.6;

	difference() {
		hull() {
		union() {
			cylinder(r = r1_opening + 1.5 + t_shroud, h = t_shroud_base);

				hull()
					effector_shroud_holes(diameter = d_M3_cap / 2, height = t_shroud_base);

				translate([0, 0, height - 0.1])
					cylinder(r = r1_opening + 1.5 + t_shroud, h = 0.1);
			}
		}

		translate([0, 0, -0.5])
			if (twist > 0)
				metric_thread(
					diameter = 2 * (r1_opening + 1.5),
					pitch = 3,
					length = height + 1,
					internal = true,
					n_starts = twist);
			else
				cylinder(r = r1_opening + 1.5, h = height + 2);

		translate([0, 0, t_shroud_base])
			effector_shroud_holes(diameter = d_M3_cap / 2, height = height);

		translate([0, 0, -1])
			effector_shroud_holes(diameter = d_M3_screw / 2, height = t_shroud_base + 2);
	}
}
