/************************************************************************************

minerva.scad - structural and tool objects required to build an Minerva delta platform
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

// requires the common delta modules
include <include/simple_delta_common.scad>

/************  layer_height is important - set it to the intended print layer height  ************/
layer_height = 0.33; // layer height that the print will be produced with

// Bowden sheath dims
d_175_sheath = 4.8;
175_bowden = [d_M4_nut, h_M4_nut, d_175_sheath];
d_300_sheath = 6.55;
300_bowden = [d_M6_nut, h_M6_nut, d_300_sheath];

bowden = 175_bowden; // set to the diameter of the Bowden sheath desired, defined above

echo_dims = true; // set to true to echo pertinent dimensions - will repeat some

// [w, l, t] = [y, x, z]
$fn = 48;
pi = 3.1415926535897932384626433832795;

// Thickness of wooden boards.
t_board = 6;

// bar clamp dims
t_bar_clamp = 8;
h_bar_clamp = 10;

// Ceramic clamp dims.
h_bed_clamp = 10;
w_bed_clamp = 10;
r_bed_clamp = 3;	// Radius of rounded corner.
d_tile = 251;

// the following sets the spacing of the linking board mounts on motor/idler ends
cc_idler_mounts = 120; // c-c of mounts on idler end - large to maximize x-y translation when in fixed tool mode and minimizes material use for bases
cc_motor_mounts = 75; // c-c of mounts on idler end

// magnetic ball joint dims
d_ball_bearing = 9.5;
od_magnet = 10;
h_magnet = 2.8;
d_bearing_with_magnet = 10.9;
h_carriage_magnet_mount = 9;
h_effector_magnet_mount = 10;
r_pad_carriage_magnet_mount = 2;
r_pad_effector_magnet_mount = 2;

// tierod dims
w_laser = .6;
t_tierod = 3.2;	// thickness of tie rod plates - typically 3
w_tierod = 3 * t_tierod;
w2_tierod = 4 * t_tierod;
tierod_fraction = 0.25;	// Fraction of the bearing ball's surface that makes contact.
d_tierod = 5.2;
h_tierod_cap = 25;
h_tierod_wall = 10;

// printer dims
r_printer = 175; // radius of the printer, distance from printer center to guide rod centers - typically 175
l_tierod = 250 + 2 * h_tierod_wall + d_ball_bearing; // length of the tie rods - typically 250
l_guide_rods = 600; // length of the guide rods

// belt, pulley and idler dims
idler = bearing_608;
w_belt = 6; // width of the belt (not used)
pulley_cogs = 16; // number of cogs on the pulley
belt = GT2; // the type of drive belt to be used
h_idler_washer = h_M8_washer; // idler bearing shaft washer
d_idler_shaft_head = d_M8_nut; // idler bearing shaft head diameter
h_idler_shaft_head = h_M8_nut; // idler bearing shaft head height - sets nut pocket depth

// the diameter of the pulley isn't the whole story - the belt rides on the pulley at it's root radius
// but on the idler bearing, it rides on the tips of the cogs, pushing its pitch radius outwards
od_idler = idler[0]; // idler OD
id_idler = idler[1]; // idler id
h_idler = h_608; // thickness of idler
n_idlers = 2; // number of idler bearings
d_pulley = pulley_cogs * belt[0] / pi - belt[2]; // diameter of the pulley (used to center idler)
offset_idler = (od_idler - d_pulley) / 2 + belt[2]; // amount to offset idler bearing so belt stays parallel with guide rods

// belt terminator.
cc_belt_terminator = d_pulley;
w_belt_dog = cc_belt_terminator - d_M3_nut * cos(30);
l_belt_dog = 15;
h_belt = 7;	// measured 6.
belt_pitch = belt[0];
belt_height = belt[1];
belt_tooth_depth = belt[2];
belt_extra = 0; //belt[8];

// guide rod and clamp dims
cc_guides = 60; // center-to-center of the guide rods
d_guides = 8.3; // diameter of the guide rods - a little big for clearance
pad_clamp = 8; // additional material around guide rods
gap_clamp = 2; // opening for clamp

// following for tabs on either side of clamp to which linking boards are attached
// the radius of the delta measured from the center of the guide rods to the center of the triangle
// as drawn here, the tangent is parallel to the x-axis and the guide rod centers lie on y=0
//cc_mount = 75; // center to center distance of linking board mount pivot points standard = 75
h_apex = 40; // height of the portion of motor and idler ends mating with linking board
w_mount = 12; // thickness of the tabs the boards making up the triangle sides will attach to
l_mount = 40; // length of said tabs
cc_mount_holes = 16;
l_base_mount = l_mount;
w_base_mount = 14.1;
t_base_mount = 6.0;
r_base_mount = 3;
l_mount_slot = 0; // length of the slot for mounting screw holes

l_idler_relief = cc_guides - d_guides - pad_clamp - 1.5; // with guide rod clamp design, the length needs to be smaller so there are walls for bridging
w_idler_relief = n_idlers * h_idler + 2 * h_idler_washer;
r_idler_relief = 2; // radius of the relief inside the apex
l_clamp = cc_guides + d_guides + pad_clamp;
w_clamp = w_idler_relief + pad_clamp + 8;
h_clamp = l_NEMA17;
h_clamp_foot = 2;
h_motor_screw = 16;
motor_screw_depth = 4;	// How far the screw sinks into the motor
h_motor_pad = h_motor_screw - (w_clamp - w_idler_relief) / 2 - motor_screw_depth;

cc_v_board_mounts = l_idler_relief - d_M3_nut - 2 * r_idler_relief; // c-c mounts for vertical boards

// effector dims
// l_effector needs to be played with to keep the fan from hitting the tie rods
l_effector = 60; // cc of tie rod bearings on effector
h_effector = equilateral_height_from_base(l_effector);
r_effector = 30; // radius of the magnet mounts
t_effector = 2 * h_magnet + 2; // thickness of the effector base
h_triangle_inner = h_effector + 12;
r_triangle_middle = equilateral_base_from_height(h_triangle_inner) * tan(30) / 2;

// for the small tool end effector:
d_small_effector_tool_mount = 50; // diameter of the opening in the end effector that the tool will pass through
d_small_effector_tool_magnet_mount = 1 + d_small_effector_tool_mount + od_magnet + 2 * r_pad_effector_magnet_mount; // ring diameter of the effector tool magnet mounts
d_small_tool_magnets = 62;

// for the large tool end effector:
d_large_effector_tool_mount = 50;
d_large_effector_tool_magnet_mount = h_triangle_inner;

// Bowden sheath quick release fitting dims
d_quickrelease_threads = 6.4; // M6 threads, but this gives best fit
l_quickrelease_threads = 5; // length of threads on quick release
pitch_quickrelease_threads = 1;
d_quickrelease = 12; // diameter of the hex portion for counter-sinking quick release into hot end tool
countersink_quickrelease = 6; // depth to contersink quick release fitting into hot end tool when not headless

// hot end dims
pad_jhead = 12; // this is added to the diameter of the cage to permit clearance for the hotend
pad_e3d = 14;
t_hotend_cage = t_heat_x_jhead - h_groove_jhead - h_groove_offset_jhead;
d_hotend_side = d_large_jhead + pad_jhead;
z_offset_retainer = t_hotend_cage - t_effector / 2 - 3;  // need an additional 3mm to clear the interior of the cage
a_fan_mount = 15;
l_fan = 39.5;
r_flare = 9;
h_retainer_body = h_groove_jhead + h_groove_offset_jhead + 4;
r1_retainer_body = d_hotend_side / 2 + r_flare * 3 / t_hotend_cage - .5;
r2_retainer_body = r1_retainer_body - r_flare * h_retainer_body / t_hotend_cage + 2;
r2_opening = (d_hotend_side - 5 ) / 2 + r_flare * (t_hotend_cage - 6 - t_effector + 3.0) / (t_hotend_cage - 6);//r1_opening - r_flare * (t_effector + 1.5) / t_hotend_cage;
r1_opening = r2_opening - 1;
d_retainer_screw = d_M2_screw;
h_retainer = h_groove_jhead + h_groove_offset_jhead;
d_wire_hole = 4;

// carriage dims:
w_carriage_web = 4;
h_carriage = l_lm8uu + 4;
carriage_offset = 20; // distance from center of guide rods to center of ball mount pivot
y_web = - od_lm8uu / 2 - (3 - w_carriage_web / 2);
stage_mount_pad = 3;

// limit switch dims
l_limit_switch = 13;
w_limit_switch = 1.5;
t_limit_switch = 6;
cc_limit_mounts = 9.5;
limit_x_offset = 14; // 11 places limit switch at guide rod, otherwise center at cc_guides / 2 - 8
limit_y_offset = d_M3_screw - carriage_offset;

// center-to-center of tie rod pivots
tierod_angle = acos((r_printer - r_effector - carriage_offset) / l_tierod);

// tool mount member dims
w_member = 25; // narrow dimension of member
l_member = 75; // wide dimension of member

// BBB dims; origin at corner w/ power jack, starting from hole nearest power jack, going counter clockwise
bbb_hole0 = [14.61, 3.18];
bbb_hole1 = [14.61 + 66.5, 6.35];
bbb_hole2 = [14.61 + 66.5, 6.35 + 42.6];
bbb_hole3 = [14.61, 3.18 + 48.39];
bbb_holes = [bbb_hole0, bbb_hole1, bbb_hole2, bbb_hole3];

// Connector plate
r_plate_corners = 10;
l_plate = 102; //l_rj45_housing + l_usb_housing + w_bbl_opening + 12;
w_plate = 24; //w_rj45_housing + 2;
l_plate_rim = 3 * d_M3_screw;

// Computed values for mounting holes in apexes and wooden parts.
l_pad_mount = l_mount / 4;
function xedge(cc_mount) = cc_mount / 2 + l_pad_mount * cos(60);
yedge = r_printer - l_pad_mount * sin(60);
function center_to_board_edge(cc_mount) = sqrt(yedge * yedge + xedge(cc_mount) * xedge(cc_mount));
function linking_board_edge_angle(cc_mount) = atan(xedge(cc_mount) / yedge);
function l_brd(cc_mount) = 2 * center_to_board_edge(cc_mount) * sin(60 - linking_board_edge_angle(cc_mount)); // length of the board that will be mounted between the apexs to yield r_printer
function r_brd(cc_mount) = center_to_board_edge(cc_mount) * cos(60 - linking_board_edge_angle(cc_mount)); // distance from center of printer to center of linking board
// Width of vertical boards.
v_width = l_clamp - 2 * r_base_mount;
// Size of aluminum tube.
l_alu = 60;
w_alu = 20;
t_alu = 2;
h_alu_plug = 5;

// Top mount.
d_top_magnet = 22;
h_top_magnet = 3;
cc_top_magnets_x = l_alu - d_top_magnet;
cc_top_magnets_y = 50 - d_top_magnet / 2;


if (echo_dims) {
	echo(str("Printer radius = ", r_printer));
	echo(str("Effector offset = ", r_effector, "mm"));
	echo(str("Carriage offset = ", carriage_offset, "mm"));
	echo(str("Printer effective radius = ", r_printer - r_effector - carriage_offset));
	echo(str("Radius of base plate = ", ceil(r_printer - d_guides / 2 - 1), "mm"));
	echo(str("Tie rod angle at (0, 0, 0) = ", tierod_angle));
	echo(str("Effector tie rod c-c = ", l_effector, " mm"));
	echo(str("Vertical board mount c-c = ", cc_v_board_mounts));
	echo(str("Vertical board offset = ", 8 - h_clamp / 2 + 3));
	echo(str("Vertical board width = ", v_width));
	echo(str("offset_idler = ", offset_idler));
}

// minerva_end_idler is the structural component to which idler bearings and guide rods are attached
module minerva_end_idler(z_offset_guides = 8) {
	id_wire_retainer = 10; // the id of the hull forming the wire retainer
	union() {
		difference() {
			union() {
				translate([0, (clamp ? (w_alu - 1) / 2 : t_board) / 2, 0]) {
					round_box(
						l_clamp,
						w_clamp + (clamp ? (w_alu - 1) / 2 : t_board),
						h_clamp
					);
				}

				translate([0, 0, (h_apex - h_clamp) / 2])
					apex(
						l_slot = l_mount_slot,
						height = h_apex,
						cc_mount = cc_idler_mounts,
						base_mount = false,
						echo = echo_dims
					);

				for (i = [-1, 1]) {
					h_platform = h_motor_screw - 4 - t_board;	// Height of the platform to make the bolt fit.
					translate([i * (l_clamp / 2 + 5), w_clamp / 2 - 7, -h_clamp / 2 + h_platform / 2]) {
						round_box(27, 14, h_platform);

						// a wire retainer
						translate([i * -6, 11 / 2, h_platform / 2]) {
							rotate([90, 0, 0]) {
								difference() {
									hull() {
										for (j = [-1, 1]) {
											translate([j * 3, 0, 0])
												cylinder(r = id_wire_retainer / 2 + 3, h = 3, center = true);
										}
									}

									hull() {
										for (j = [-1, 1])
											translate([j * 3, 0, 0])
												cylinder(r = id_wire_retainer / 2, h = 4, center = true);
									}

									translate([0, -id_wire_retainer, 0])
										cube([id_wire_retainer * 3, id_wire_retainer * 2 - 1, 4], center = true);
								}
							}
						}
					}
				}
				if (clamp) {
					translate([0, w_clamp / 2 + w_alu / 2 - 6 / 2, 0])
						cube([l_clamp + 2 * d_M3_washer, 6 - 1, h_clamp], center = true);
				}
			}
			// Vertical board.
			translate([0, w_clamp / 2 + t_board / 2 + w_alu / 2, 0])
				cube([clamp ? l_alu : v_width, t_board + w_alu, h_clamp + 1], center = true);

			if (clamp) {
				for (k = [-1, 0, 1]) {
					for (i = [-1, 1]) {
						translate([i * (l_clamp / 2 + d_M3_washer / 2), w_clamp / 2 + w_alu / 2 - 6 / 2, k * h_clamp * .35]) {
							rotate([90, 0, 0])
								cylinder(d = d_M3_screw, h = 8, center = true);
						}
					}
				}
			}

			// Wire channel for limit switch.
			w_channel = 3;
			channel_offset = (w_clamp / 2 - w_idler_relief / 2) / 2;
			translate([0, -w_clamp / 2 + channel_offset, -h_clamp / 2])
				difference() {
					cube([l_clamp + 1, w_channel, w_channel * 2], center = true);
					for (i = [-1, 1]) {
						translate([i * l_clamp * .4, 0, 0])
							cube([3, w_channel + 2, 2], center = true);
					}
				}
			translate([l_clamp / 2 - 28.5, -w_clamp / 2 + channel_offset, -h_clamp / 2])
				rotate([atan((channel_offset * 1.5) / h_clamp), 0, 0])
					cylinder(d = w_channel, h = h_clamp);

			// place the idler shaft such that the belt is parallel with the pulley - the belt connection will be on the right looking down the vertical axis
			translate([-offset_idler, 0, 0]) // update 09212014
				rotate([90, 0, 0])
					union() {
						cylinder(r = id_idler / 2, h = w_clamp + 2, center = true);

						translate([0, 0, -w_clamp / 2])
							cylinder(r = d_idler_shaft_head / 2, h = 2 * h_idler_shaft_head, center = true, $fn = 6);
					}

			// idler will be two bearing thick plus two washers
			round_box(
				length = l_idler_relief,
				width = w_idler_relief,
				height = h_clamp + 2,
				radius = r_idler_relief
			);

			// limit switch mount
			translate([l_clamp / 2 - 28.5, -w_clamp / 2, h_clamp / 2 - t_limit_switch / 2 + 1])
				cube([l_limit_switch, w_limit_switch * 2, t_limit_switch + 2], center = true);

			// guide rod and clamp pockets
			bar_clamp_relief(z_offset_guides = z_offset_guides);

			// holes for mounting top ring
			for (i = [-1, 1])
				translate([i * (l_clamp / 2 + 13), 12, -h_clamp / 2 + 5])
					cylinder(r = d_M3_screw / 2, h = 11, center = true);

			if (!clamp) {
				// relief for vertical boards
				translate([0, 0, z_offset_guides - h_clamp / 2 + 3])
					vertical_board_relief();
			}

			// holes to reduce plastic and wire passage
			for (i = [-1,1])
				translate([i * (cc_idler_mounts / 2 - 12), 0, 0])
					rotate([90, 0, 0])
						hull()
							for (j = [-1, 1])
								translate([0, j * h_apex / 8, 0])
									cylinder(r = 4, h = 13, center = true);

			// wire passage
			for (i = [-1, 1])
				translate([i * (cc_idler_mounts / 2 + 30), -w_clamp - 5, -h_clamp / 2 + 2.5])
					rotate_extrude(convexity = 10)
						translate([42, 0, 0])
							circle(r = 2);
		}

		// floor for guide rod pockets
		for (i = [-1, 1])
			translate([i * cc_guides / 2, 0, h_bar_clamp / 2 + layer_height])
				cylinder(r = d_guides / 2 + 1, h = layer_height);
	}
}

// minerva_end_motor is the structural component to which motors and guide rods are attached
module minerva_end_motor(z_offset_guides = 8, clamp = false) {
	h_brace = 8; // height of cross brace triangle
	b_brace = equilateral_base_from_height(h_brace);
	r_wire_guide = 12;
	h_wire_guide = 5;
	union() {
		difference() {
			union() {
				translate([0, (clamp ? (w_alu - 1) / 2 : t_board) / 2, h_clamp_foot / 2]) {
					round_box(
						l_clamp,
						w_clamp + (clamp ? (w_alu - 1) / 2 : t_board),
						h_clamp + h_clamp_foot
					);
				}

				translate([0, 0, (h_apex - h_clamp) / 2])
					apex(
						l_slot = l_mount_slot,
						height = h_apex,
						cc_mount = cc_motor_mounts,
						base_mount = true,
						echo = echo_dims
					);

				// wire guide
				for (i = [-1, 1])
					translate([i * l_clamp / 2, w_clamp / 2 - r_wire_guide, (h_wire_guide - h_clamp) / 2])
						difference() {
							hull()
								for (j = [-i * 1, i * 0.4])
									translate([j * 4, 0, 0])
										cylinder(r = r_wire_guide, h = h_wire_guide, center = true);

							hull()
								for (j = [-i * 1, i * 0.4])
									translate([j * 4, 0, 0])
										cylinder(r = r_wire_guide - 3, h = h_wire_guide + 1, center = true);
						}
				if (clamp) {
					translate([0, w_clamp / 2 + w_alu / 2 - 6 / 2, 0])
						cube([l_clamp + 2 * d_M3_washer, 6 - 1, h_clamp], center = true);
				}
			}

			// Vertical board.
			translate([0, w_clamp / 2 + t_board / 2 + w_alu / 2, h_clamp_foot / 2])
				cube([clamp ? l_alu : v_width, t_board + w_alu, h_clamp + h_clamp_foot + 1], center = true);
			// Cut off round edge at foot.
			translate([0, w_clamp / 2 + t_board / 2 + w_alu / 2, h_clamp / 2 + 1])
				cube([l_clamp + 2 * d_M3_washer + 2, t_board + w_alu, h_clamp_foot + 2], center = true);

			if (clamp) {
				for (k = [-.8, 0, 1]) {	// Lower top hole to make space for wire guide.
					for (i = [-1, 1]) {
						translate([i * (l_clamp / 2 + d_M3_washer / 2), w_clamp / 2 + w_alu / 2 - 6 / 2, k * h_clamp * .35]) {
							rotate([90, 0, 0])
								cylinder(d = d_M3_screw, h = 8, center = true);
						}
					}
				}
			}

			// Inner body.
			translate([0, h_motor_pad / 2, (l_NEMA17 - h_clamp) / 2])
				round_box(
					length = l_idler_relief,
					width = w_idler_relief - h_motor_pad,
					height = h_clamp + h_clamp_foot * 2 + 2,
					radius = r_idler_relief
				);


			// motor mount
			translate([0, 0, (l_NEMA17 - h_clamp) / 2])
				rotate([90, 0, 0]) {
					NEMA_parallel_mount(
						height = w_clamp + 2,
						l_slot = 0,
						motor = NEMA17);
					// Larger holes for the screws.
					for (y = [-1, 1]) {
						for (x = [-1, 1]) {
							translate([x * cc_NEMA17_mount / 2, y * cc_NEMA17_mount / 2, -w_clamp / 2])
								cylinder(d = d_M3_screw_head, h = w_clamp - w_idler_relief + 2, center = true);
						}
					}

				// tear drop motor opening to improve printing
				hull() {
					cylinder(r = NEMA17[1] / 2, h = w_clamp + 2, center = true);

					translate([0, h_clamp / 2 - 8, 0])
						cylinder(r = 1, h = w_clamp + 2, center = true);
				}
			}

			// set screw access - access from bottom of printer
			translate([-2.5, -w_clamp / 2 - 1, d_NEMA17_collar / 2 + 0.5])
				cube([5, w_clamp / 2, (h_clamp - d_NEMA17_collar) / 2 + h_clamp_foot]);

			// guide rod and clamp pockets
			bar_clamp_relief(z_offset_guides = -z_offset_guides);

			// relief for vertical boards
			if (!clamp) {
				translate([0, 0, h_clamp / 2 - z_offset_guides - 3])
					vertical_board_relief();
			}

			// wire passage
			for (i = [-1, 1])
				translate([i * (cc_guides / 2 + 30), -w_clamp - 5, -h_clamp / 2 + 10])
					rotate_extrude(convexity = 10)
						translate([40, 0, 0])
							scale([0.75, 1, 1])
								circle(r = 5);
		}

		// cross bracing to minimize motor torquing into box
		for (i = [-1, 1])
			translate([i * (b_brace + 5) / 2, 0, h_clamp / 2 - h_brace])
				rotate([90, 0, 0])
					linear_extrude(height = w_clamp - 2, center = true)
						equilateral(h_brace);

		// floor for guide rod pockets
		for (i = [-1, 1])
			translate([i * cc_guides / 2, 0, h_bar_clamp / 2 + layer_height])
				cylinder(r = d_guides / 2 + 1, h = 0.3);

	}
}

module minerva_clamp(floor, hole_offset, fraction) {
	t_floor = [0, h_clamp_foot, t_board][floor];
	union() {
		difference() {
			union() {
				if (floor != 0) {
					// Plug floor.
					translate([0, t_board / 2 + (fraction - .5) * w_alu, -h_clamp / 2])
						cube([l_alu - .1, w_alu + t_board, t_floor + .1], center = true);
				}
				if (floor == 2) {
					// Floor with screw holes.
					difference() {
						translate([0, t_board / 2 + (fraction - .5) * w_alu + h_clamp / 2 + h_clamp_foot / 2, -h_clamp / 2])
							cube([l_clamp + 2 * d_M3_washer, h_clamp + t_floor, t_floor + .1], center = true);
						for (i = [-1, 1]) {
							for (k = [-1, 0, 1]) {
								translate([i * (l_clamp / 2 + d_M3_washer / 2), k * h_clamp * .35 + h_clamp / 2 + t_floor / 2 + t_board / 2, -t_floor / 2 - h_clamp / 2 - 1])
									cylinder(d = d_M3_screw, h = t_floor + 2);
							}
						}
					}
					// Body including support prism.
					hull() {
						translate([0, t_board / 2 + w_alu * fraction / 2 + 1 / 2, 0])
							cube([l_clamp, w_alu * fraction + t_board - 1, h_clamp + t_floor], center = true);
						translate([0, t_board / 2 + (fraction - .5) * w_alu + h_clamp + h_clamp_foot / 2 + t_floor / 2 - .1, -h_clamp / 2 - 1])
							cube([l_clamp, .1, .1], center = true);
					}
				}
				else {
					// Body.
					if (fraction > 0) {
						translate([0, t_board / 2 + w_alu * fraction / 2 + 1 / 2, 0])
							cube([l_clamp, w_alu * fraction + t_board - 1, h_clamp + t_floor], center = true);
					}
				}
				// Tabs.
				translate([0, 6 / 2, 0])
					cube([l_clamp + 2 * d_M3_washer, 6 - 1, h_clamp + t_floor], center = true);
			}
			// Main hole.
			translate([0, -1, t_floor / 2])
				cube([l_alu, 2 * fraction * w_alu + 2, h_clamp + t_floor + 1], center = true);
			// Screw holes.
			for (i = [-1, 1]) {
				for (k = [-1, 0, hole_offset ? .8 : 1]) {	// The base clamp needs the top screw hole to be displaced.
					translate([i * (l_clamp / 2 + d_M3_washer / 2), 0, t_floor / 2 + k * h_clamp * .35]) {
						rotate([-90, 0, 0])
							cylinder(d = d_M3_screw, h = 8);
					}
				}
			}
		}
		if (floor != 0) {
			// Plug.
			hull() {
				// Base.
				translate([0, (fraction - .5) * w_alu, (h_alu_plug / 4) / 2 - h_clamp / 2])
					cube([l_alu - 2 * t_alu, w_alu - 2 * t_alu, h_alu_plug / 4 + t_floor / 2], center = true);
				// Top.
				translate([0, (fraction - .5) * w_alu, h_alu_plug / 2 - h_clamp / 2])
					cube([l_alu - 3 * t_alu, w_alu - 3 * t_alu, h_alu_plug + t_floor / 2], center = true);
			}
		}
	}
}

module minerva_top_magnet_mount() {
	difference() {
		cube([l_clamp + 2 * d_M3_washer, cc_top_magnets_y + d_top_magnet + 3, 6], center = true);
		translate([0, cc_top_magnets_y / 2, 6 / 2 - h_top_magnet])
			cylinder(d = d_top_magnet, h = h_top_magnet + 1);
		for (i = [-1, 1]) {
			translate([i * cc_top_magnets_x / 2, -cc_top_magnets_y / 2, 3 - h_top_magnet])
				cylinder(d = d_top_magnet, h = h_top_magnet + 1);
		}
		for (i = [-1, 1]) {
			for (k = [-1, 0, 1]) {
				translate([i * (l_clamp / 2 + d_M3_washer / 2), k * h_clamp * .35, -6 / 2 - 1]) {
					cylinder(d = d_M3_screw, h = 8);
				}
			}
		}
	}
}

d_top_mount_relief = 22 + 1;
d_top_mount = d_top_mount_relief + 2 * 3;
z_top_mount = d_top_mount_relief / 6;
h_top_mount = d_top_mount_relief / 2 + z_top_mount + 3;
top_mount_safe = d_top_mount / 2;
top_mount_safe2 = top_mount_safe + cc_top_magnets_y * sin(60);

module top_mount_parts() {
	cylinder(d = d_top_mount, h = h_top_mount);
	for (i = [-1, 1]) {
		translate([i * cc_top_magnets_x / 2, -cc_top_magnets_y, 0])
			cylinder(d = d_top_mount, h = h_top_mount);
	}
}

module top_mount_relief() {
	translate([0, 0, z_top_mount]) {
		sphere(d = d_top_mount_relief);
		for (i = [-1, 1]) {
			translate([i * cc_top_magnets_x / 2, -cc_top_magnets_y, 0])
				sphere(d = d_top_mount_relief);
		}
	}
}

module top_mount() {
	difference() {
		hull() {
			top_mount_parts();
		}
		top_mount_relief();
	}
}

d_spindlescrews = 4.5;
a_spindlescrews = 25;
d_spindlebody = 52;
d_spindlering = 26;

module spindle_mount() {
	rotate([180, 0, 0]) {
		difference() {
			hull() {
				cylinder(d = d_spindlebody, h = h_top_mount);
				translate([0, top_mount_safe2 + d_spindlebody / 2, 0])
					top_mount_parts();
			}
			translate([0, top_mount_safe2 + d_spindlebody / 2, 0])
				top_mount_relief();
			translate([0, 0, -1]) {
				cylinder(d = d_spindlering, h = h_top_mount + 2);
				for (a = [0:3]) {
					rotate([0, 0, 90 * a]) {
						translate([a_spindlescrews / sqrt(2), 0, 0])
							cylinder(d = d_spindlescrews, h = h_top_mount + 2);
					}
				}
			}
		}
	}
}

module minerva_free_belt_terminator(h_floor = 3) {
	h_belt_terminator = h_belt + h_floor;
	rotate([90, 0, 0]) {
		difference() {
			translate([-(belt_height + belt_extra) / 2 - (cc_belt_terminator + d_M3_washer) / 2, 0, -h_floor - 1])
				cube([cc_belt_terminator + d_M3_washer, l_belt_dog, h_belt_terminator]);
			dog_relief(l_belt_dog);
		}
	}
}

module minerva_belt_terminators() {
	for (i = [0:3]) {
		rotate([0, 0, i * 120]) {
			translate([50, 0, 0])
				minerva_free_belt_terminator();
		}
	}
}

/**********
						following are carriages for the Minerva
						one is simple and does not permit fixed tool mode operation
						the other is convertible, permitting use in both mobile and fixed tool modes
**********/

// minerva_basic_carriage does not have magnet mounts required for fixed tool mode
module minerva_basic_carriage() {
	union() {
		difference() {
			union() {
				carriage_body();

				// magnet mounts
				for (i = [-1, 1])
					translate([i * l_effector / 2, -carriage_offset, -4])
						rotate([90 - tierod_angle, 0, 0])
							magnet_mount(r_pad = r_pad_carriage_magnet_mount, h_pad = h_carriage_magnet_mount);
			}

			for (i = [-1, 1])
				translate([i * cc_guides / 2, 0, 0])
					carriage_wire_tie_relief();

			carriage_bearing_relief();

			// belt terminator mount
			translate([d_pulley / 2, y_web, h_carriage / 2 - d_M3_screw / 2 - 5])
				rotate([90, 0, 0])
					cylinder(r = d_M3_screw / 2, h = w_carriage_web + 2, center = true);

			// flatten the bottom
			translate([0, 0, -h_carriage])
				cube([2 * cc_guides, 4 * (od_lm8uu + 6), h_carriage], center = true);
		}
	}
}

// minerva_carriage is required if the platform will be used in fixed tool mode
module minerva_carriage(linear_bearing = bearing_lm8uu, extra = 0, name) {
	total_h = h_carriage + (extra >= 0 ? h_carriage + extra : 0);
	union() {
		difference() {
			union() {
				carriage_body(linear_bearing = linear_bearing, extra = extra, name = name);

				// magnet mounts
				for (i = [-1, 1]) {
					for (j = [-1, 1]) {
						translate([i * l_effector / 2, y_web, -0 * stage_mount_pad]) {
							rotate([j * tierod_angle, 0, 0]) {
								translate([0, 0, j * stage_mount_pad]) {
									rotate([90, 0, 0]) {
										translate([0, 0, d_bearing_with_magnet - d_ball_bearing / 2 + h_carriage_magnet_mount])
											magnet_mount(r_pad = r_pad_carriage_magnet_mount, h_pad = h_carriage_magnet_mount);
										if (j == 1) {
											translate([0, 0, 30 / 2 + h_carriage_magnet_mount + h_magnet + layer_height]) {
												difference() {
													cylinder(r = od_magnet / 2 + r_pad_carriage_magnet_mount, h = 30, center = true);
													cylinder(d = od_magnet, h = 30 + 2, center = true);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}

			for (i = [-1, 1])
				translate([i * cc_guides / 2, 0, 0])
					carriage_wire_tie_relief(linear_bearing = linear_bearing, extra = extra);

			carriage_bearing_relief(linear_bearing = linear_bearing, extra = extra);

			// flatten the bottom
			translate([0, 0, -h_carriage])
				cube([2 * cc_guides, 4 * (linear_bearing[0] + 6), h_carriage], center = true);
		}
		// Floor for support.
		for (i = [-1, 1]) {
			for (h = extra >= 0 ? [0, total_h - h_carriage] : [0]) {
				translate([i * cc_guides / 2 - od_lm8uu / 2 - 1, 10 - 2 - (od_lm8uu / 2 + 5) / 2, h_carriage / 2 - (h_carriage - l_lm8uu) / 2 - 2 * layer_height + h])
					cube([od_lm8uu + 2, 2, layer_height]);
				translate([i * cc_guides / 2 - od_lm8uu / 2 - 1, -d_guides / 2, h_carriage / 2 - (h_carriage - l_lm8uu) / 2 - 2 * layer_height + h])
					cube([od_lm8uu + 2, 2, layer_height]);
			}
		}
	}
}

/**********
						following for the limit switch required for fixed tool mode operation
						it is not necessary if the platform does not have a fixed tool mount
**********/

l_bottom_switch = 2 * d_guides + 2 * d_M3_screw;
w_bottom_switch = 25 - h_M3_nut - h_M3_washer;
bottom_switch_wall = 3;
h_bottom_switch = 35;
l_switch = 13.5;
w_switch = 5.8;
h_switch = 6;
l_switch_channel = 12.5;
w_switch_channel = 2.5;
h_switch_channel = 3;	// Horizontal part.
bottom_switch_gap = 2;
module bottom_limit_switch() {
	difference() {
		// Body.
		translate([-l_bottom_switch / 2, -w_bottom_switch + d_guides / 2 + bottom_switch_wall, 0])
			cube([l_bottom_switch, w_bottom_switch, h_bottom_switch]);
		// Guide rod.
		translate([0, 0, -1])
			cylinder(d = d_guides, h = h_bottom_switch + 2);
		// Screw holes.
		for (z = [-1, 1]) {
			translate([z * (d_guides / 2 + (l_bottom_switch - d_guides) / 4), d_guides / 2 + bottom_switch_wall + 1, h_bottom_switch / 2]) {
				rotate([90, 0, 0])
					cylinder(d = d_M3_screw, h = w_bottom_switch + 2);
			}
		}
		// Limit switch.
		translate([-l_switch / 2, -d_guides / 2 - w_switch - .01, h_bottom_switch - h_switch])
			cube([l_switch, w_switch, h_switch + 1]);
		// Limit switch wire channel.
		translate([-l_switch_channel / 2, -d_guides / 2 - w_switch / 2 - w_switch_channel / 2, -1])
			cube([l_switch_channel, w_switch_channel, h_bottom_switch - h_switch + 2]);
		// Horizontal part of wire channel.
		translate([-l_bottom_switch / 2 - 1, -d_guides / 2 - w_switch / 2 - w_switch_channel / 2, -1])
			cube([l_bottom_switch / 2 + 1, w_switch_channel, h_switch_channel + 1]);
		// Gap.
		translate([-l_bottom_switch / 2 - 1, -bottom_switch_gap / 2, -1])
			cube([l_bottom_switch + 2, bottom_switch_gap, h_bottom_switch + 2]);
	}
}

// central_limit_switch permits mounting a switch on the interior of vertical boards
module central_limit_switch() {
l_switch_mount = 20;
w_switch_mount = 10;
h_switch_mount = 20;

difference() {
	cube([l_switch_mount, w_switch_mount, h_switch_mount], center = true);

	translate([-5, 3.5, 0])
		cube([l_switch_mount, w_switch_mount, h_switch_mount + 1], center = true);

	// limit switch mounts
	translate([l_switch_mount / 2, 2, 0])
		rotate([0, 90, 0])
			for (i = [-1, 1])
				translate([i * cc_limit_mounts / 2, 0, 0])
					cylinder(r = 0.8, h = 14, center = true);

	for (i = [-1, 1])
		translate([-2.5, 0, i * 5])
			rotate([90, 0, 0])
				hull()
					for (j = [-1, 1])
						translate([j * 2.5, 0, 0])
							cylinder(r = d_M3_screw / 2 + 0.25, h = 13, center = true);
}
}

/**********
						following for mounting controller boards to the base of the platform
						render and print necessary holders
**********/

// BBB_mount is for mounting a Beaglebone Black to the base of the platform
module BBB_mount(
bbb_standoff = 6,
mount_offset = 14) {
// standoff is the total height of the mount
// offset is the location of the mounting holes for mounting to whatever, in the case of Minerva, the underside of the base
slope0_2 = (bbb_hole2[1] - bbb_hole0[1]) / (bbb_hole2[0] - bbb_hole0[0]);

difference() {
	union() {
		translate([0, 0, -bbb_standoff / 2 + 1]) {
			hull()
				for (i = [0, 2])
					translate([bbb_holes[i][0], bbb_holes[i][1], 0])
						cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

			hull()
				for (i = [1, 3])
					translate([bbb_holes[i][0], bbb_holes[i][1], 0])
						cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
		}

		for (i = [0:3])
			translate([bbb_holes[i][0], bbb_holes[i][1], 0])
						cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = bbb_standoff, center = true);
	}

	for (i = [0:3])
		translate([bbb_holes[i][0], bbb_holes[i][1], 1])
			cylinder(r = d_M3_screw / 2 - 0.25, h = bbb_standoff, center = true);

	translate([bbb_hole0[0] + mount_offset, bbb_hole0[1] + mount_offset * slope0_2, 0])
		cylinder(r = d_M3_screw / 2, h = bbb_standoff + 1, center = true);

	translate([bbb_hole2[0] - mount_offset, bbb_hole2[1] - mount_offset * slope0_2, 0])
		cylinder(r = d_M3_screw / 2, h = bbb_standoff + 1, center = true);
}
}

/**********
						following are various holders for convenience, not necessary for construction of platform
**********/

// minerva_tool_holder is an object to be mounted on a vertical board for holding effector tools
module minerva_tool_holder(wood_mount = false) {
// a tool holder for the side of the printer
l_mount = 2 * d_small_effector_tool_magnet_mount * cos(60);
w_mount = 16;
h_mount = 20;

mirror([0, 0, (wood_mount) ? 0 : 1]) // want to flip it over if aluminum mounting
	difference() {
		union() {
			if (wood_mount)
				// fits over the vertical board and covers wires
				translate([0, d_small_effector_tool_magnet_mount * sin(60) / 2 + 6, (h_mount - t_effector) / 2])
					board_mount(
						height = h_mount,
						length = l_mount,
						width = w_mount
						);
			else
				translate([0, d_small_effector_tool_magnet_mount * sin(60) / 2, 0])
					hull() {
						for (i = [-1, 1])
							translate([i * 10, 10, 0])
								cylinder(r = d_M3_nut / 2, h = t_effector, center = true);

							cube([20 + d_M3_nut, 4, t_effector], center = true);
					}

			hull()
				for (i = [0:2])
					rotate([0, 0, i * 120 + 60])
						translate([0, d_small_effector_tool_magnet_mount / 2, 0])
							cylinder(r = od_magnet / 2 + r_pad_effector_magnet_mount, h = t_effector, center = true);
		}

		if (!wood_mount)
			translate([0, d_small_effector_tool_magnet_mount * sin(60) / 2, 0])
				for (i = [-1, 1])
					translate([i * 10, 10, 0])
						cylinder(r = d_M3_screw / 2, h = t_effector + 1, center = true);

		cylinder(r = d_small_effector_tool_mount / 2, h = h_effector + 1, center = true);

		for (i = [0:2])
			rotate([0, 0, i * 120 + 60])
				translate([0, d_small_effector_tool_magnet_mount / 2, -t_effector / 2])
					cylinder(r1 = od_magnet / 2, r2 = od_magnet / 2 + 0.5, h = h_magnet + 2, center = true);

		for (i = [-1, 1])
			translate([i * l_mount / 4, d_small_effector_tool_magnet_mount * sin(60) / 2, h_mount - 8])
				rotate([90, 0, 0])
					cylinder(r = d_M3_screw / 2, h = 5, center = true);
	}
}

module minerva_spool_holder(
		render_mount = false,
		render_holder = false,
		mount_wood = false) {
	// spool holder to mount to vertical board
	l_mount = 28;
	w_mount = t_board + 8;
	h_mount = 30;
	l_holder = 140;
	w_holder = 20;
	h_holder = h_motor_screw - 1;	// Use same length screws when possible.
	d_pivot = 14;
	h_pivot = h_holder / 2;

	if (render_mount) {
		translate([0, 0, h_mount / 2]) {
			difference() {
				union() {
					if (mount_wood)
						mirror([0, 0, 1])
							board_mount(
								height = h_mount,
								length = l_mount,
								width = w_mount,
								wire_guide_offset = 8);
					else
						difference() {
							cube([l_mount, w_member + 8, h_mount], center = true);

							translate([0, 0, -4])
								cube([l_mount + 1, w_member, 6], center = true);
						}

					translate([-1, 0, (h_pivot + h_mount) / 2 - 0.5])
						difference() {
							cylinder(r = d_pivot / 2, h = h_pivot + 1, center = true);

							cylinder(d = d_M3_screw - 0.2, h = h_pivot + 2, center = true);
						}
				}

				// Pivot path.
				translate([-1, 0, h_mount / 2 - 5])
					intersection() {
						rotate_extrude(convexity = 10)
							translate([8, 0, 0])
								square([10, 6]);

						rotate([0, 0, 80])
							translate([-l_mount / 2 + 6, w_mount / 2, 5])
								cube([20, 20, 10], center = true);
					}

				if (mount_wood)
					// Screw holes.
					translate([0, -w_mount / 2, -h_mount / 2 + 5])
						rotate([90, 0, 0])
							for (i = [-1, 1]) {
								translate([i * 8, 0, -w_mount / 2])
									cylinder(d = 3, h = w_mount + 2, center = true);
								translate([i * 8, 0, -w_mount - h_M3_nut / 2])
									cylinder(d = d_M3_nut, h = h_M3_nut, $fn = 6);
							}
				else {
					translate([-1, 3, -1 + layer_height])
						cylinder(r = d_M3_screw / 2, h = h_mount + h_pivot + 3);

	//						translate([0, 0, h_pivot])
	//							cylinder(r = d_M3_cap / 2, h = h_M3_cap + 1, center = true);
				}
			}
		}
	}

	if (render_holder) {
		translate([0, (render_mount) ? (w_mount + h_holder) / 2 + 2 : 0, 0]) {
			// Arm.
			translate([0, 0, w_holder / 2]) {
				rotate([90, 0, 0]) {
					union() {
						difference() {
							hull()
								for (i = [-1, 1])
									translate([i * (l_holder - w_holder) / 2, 0, 0])
										cylinder(r = w_holder / 2 / cos(30), h = h_holder, center = true, $fn = 6);

							// Pivot hole.
							translate([-(l_holder - w_holder) / 2, 0, (h_holder - h_pivot ) / 2]) {
								cylinder(d = d_pivot + 0.5, h = h_pivot + 1, center = true);

								translate([0, 0, -h_pivot * 3 / 2 - .1])
									cylinder(d1 = d_pivot + 6, d2 = d_pivot + 0.5, h = h_holder - h_pivot + .2);
							}

							// Narrow towards end.
							translate([10, 0, h_holder / 2 + 2.75])
								rotate([0, 5, 0])
									cube([l_holder, w_holder + 1, h_holder], center = true);

							// Down towards end (hook).
							translate([10, 14, 0])
								rotate([0, 0, -7])
									cube([l_holder - 35, w_holder, h_holder + 1], center = true);
						}

						// Stop block.
						translate([-l_holder / 2 + 20, (4 - w_holder) / 2, 7])
							difference() {
								cube([10, 4, 10], center = true);

								translate([10, 0, h_holder / 2 + 3])
									rotate([0, 7, 0])
										cube([l_holder, w_holder + 1, h_holder], center = true);
							}
					}
				}
			}

			// Retainer.
			translate([0, 20, 0]) {
				difference() {
					cylinder(r1 = d_pivot / 2 + 0.25, r2 = d_pivot / 2 + 3, h = h_holder - h_pivot);

					translate([0, 0, -1])
						cylinder(d = d_M3_screw, h = h_holder);
				}
			}
		}
	}
}

// minerva_hand_tool_holder is an object to mount to a vertical board that wires can be tucked underneath and drivers can be hung on
// sonicare model E toothbrush ends have nice magnets in them, good for holding scraper
module minerva_hand_tool_holder(
		wood_mount = false,
		sonicare_magnet = false) {
	l_mount = 30;
	w_mount = 22;
	h_mount = (sonicare_magnet) ? 50 : 30;
	difference() {
		union() {
			if (wood_mount)
				translate([5, 0, l_mount / 2])
					rotate([0, 90, 0])
						board_mount(
							height = h_mount,
							length = l_mount,
							width = w_mount
							);
			else
				translate([0, 0, l_mount / 2])
					hull()
						for (i = [-1, 1])
							translate([i * l_mount / 2, 0, 0])
								cylinder(r = d_M3_nut / 2, h = h_mount, center = true);

			translate([30 - h_mount / 2, -13 - w_mount / 2, 2.5])
				hull()
					for (i = [-1, 1])
						translate([i * 30, 0, 0])
							cylinder(r = 15, h = 5, center = true);
		}

		translate([-h_mount / 2, -13 - w_mount / 2, 2.5])
			for (i = [0:4])
				translate([i * 15, 0, 0])
					cylinder(r = 3, h = 6, center = true);

		for (i = [0, 1])
		translate([14, -w_mount / 2, i * 15 + 10])
			rotate([90, 0, 0]) {
				cylinder(r = d_M3_screw / 2, h = 20, center = true);

				cylinder(r = 4, h = 5, center = true);
			}

		// magnet relief for sonicar magnets
		if (sonicare_magnet) {
			translate([1, 2.7 - w_mount / 2, h_mount / 3])
				rotate([90, 0, 0]) {
					for (i = [-1, 1])
						translate([i * (3.7 + 5.2) / 2, 0, 0])
							cube([5.2, 10.2, 6], center = true);

					translate([0, 0, -3 / 2])
						cube([19, 17, 2], center = true);
			}
		}
	}
}

module tool_effector() {
	difference() {
		effector_base(large = true);
		for (i = [0:2]) {
			rotate([0, 0, 120 * i + 90]) {
				translate([d_small_tool_magnets / 2, 0, t_effector - h_magnet])
					cylinder(d = od_magnet, h = h_magnet + 1);
				translate([d_small_tool_magnets / 2, 0, -1])
					cylinder(d = od_magnet, h = h_magnet + 1);
			}
		}
		translate([0, 0, -1])
			cylinder(d = d_small_effector_tool_mount, h = t_effector + 2);
	}
}

module hotend_tool(
		quickrelease = true,
		dalekify = false,
		vent = false,
		headless = false,
		render_thread = false) {
	y_offset = -5;
	z_offset = 8;
	translate([0, 0, t_effector / 2]) {
		difference() {
			union() {
				hotend_mount(
					dalekify = dalekify,
					quickrelease = quickrelease,
					vent = vent,
					headless = headless,
					render_thread = render_thread,
					y_offset = y_offset,
					z_offset = z_offset
				);
				rotate([0, 0, 180])
					tool_mount_body(d_small_tool_magnets, t_effector);
			}
			rotate([0, 0, 180])
				tool_mount_bearing_cage(d_small_tool_magnets, t_effector);

			// Bottom hole.
			cylinder(r1 = r1_opening, r2 = r2_opening, h = t_effector + 0.1, center = true);
		}
	}
}

module hotend_retainer() {
	rotate([-90, 0, 0]) {
		translate([0, -(d_large_jhead + 6 + 1) / 2 - (6 - 1) / 2, 0]) {
			difference() {
				union() {
					translate([0, (d_large_jhead + 6 + 1) / 2, h_retainer / 2])
						cube([d_large_jhead + d_M3_screw * 4, 6 - 1, h_retainer - 2], center = true);
					translate([0, (d_large_jhead / 2 + 3) / 2, h_retainer / 2])
						cube([d_large_jhead - 2, d_large_jhead / 2 + 3, h_retainer - 2], center = true);
				}
				// Above the groove.
				translate([0, 0, -h_retainer + h_groove_offset_jhead - 1 + .1])
					cylinder(d = d_large_jhead, h = h_retainer);
				// Groove.
				translate([0, 0, -1])
					cylinder(d = d_small_jhead, h = h_retainer + 2);
				for (x = [-1, 1]) {
					// Screw holes.
					translate([x * (d_large_jhead + d_M3_nut) / 2, d_large_jhead / 2 + 6 + 1, h_retainer / 2]) {
						rotate([90, 0, 0])
							cylinder(d = d_M3_screw, h = 8);
					}
					// Slots to make it fit in the groove.
					translate([x * d_large_jhead / 2, 0, h_groove_offset_jhead - 1 + h_retainer / 2])
						cube([d_large_jhead - d_small_jhead + 1, d_large_jhead + 2, h_retainer], center = true);
					// Nut traps.
					translate([x * (d_large_jhead + d_M3_nut) / 2, d_large_jhead / 2 + 6 + 1, h_retainer / 2]) {
						rotate([90, 0, 0])
							cylinder(d = d_M3_nut, h = 1 + h_M3_nut / 2, $fn = 6);
					}
				}
			}
		}
	}
}

module probe_tool() {
	translate([0, 0, t_effector / 2]) {
		difference() {
			union() {
				// TODO.
				tool_mount_body(d_small_tool_magnets, t_effector);
			}
			tool_mount_bearing_cage(d_small_tool_magnets, t_effector);
		}
	}
}

module clamp_tool(d_tool = 13, h_tool = 8) {
	translate([0, 0, t_effector / 2]) {
		difference() {
			union() {
				tool_mount_body(d_small_tool_magnets, t_effector);
				difference() {
					cylinder(d = d_tool + 10, h = t_effector / 2 + h_tool);
					translate([-(d_tool + 10) / 2 - 1, -(d_tool + 10), -1])
						cube([d_tool + 10 + 2, d_tool + 10, t_effector / 2 + h_tool + 2]);
				}
				translate([-(d_tool + 10) / 2 - 6, 0, 0])
					cube([d_tool + 10 + 2 * 6, 3, t_effector / 2 + h_tool]);
			}
			tool_mount_bearing_cage(d_small_tool_magnets, t_effector);
			translate([0, 0, -t_effector / 2 - 1])
				cylinder(d = d_tool, h = h_tool + t_effector + 2);
			for (x = [-1, 1]) {
				translate([x * (d_tool / 2 + 5 + 3), -1, t_effector / 2 + h_tool / 2]) {
					rotate([-90, 0, 0])
						cylinder(d = d_M3_screw, h = 8);
				}
			}
		}
	}
}

module clamp_clamp(d_tool = 13, h_tool = 8) {
	rotate([-90, 0, 0]) {
		translate([0, -6, 0]) {
			difference() {
				translate([-(d_tool + 10 + 2 * 6) / 2, 0, 0])
					cube([d_tool + 10 + 2 * 6, 6, h_tool]);
				translate([0, 0, -1]) {
					scale([1, .5, 1]) 
						cylinder(d = d_tool, h = h_tool + 2);
				}
				for (x = [-1, 1]) {
					translate([x * (d_tool / 2 + 5 + 3), -1, h_tool / 2]) {
						rotate([-90, 0, 0])
							cylinder(d = d_M3_screw, h = 8);
					}
				}
			}
		}
	}
}

module hotend_effector(
		quickrelease = true,
		dalekify = false,
		vent = false,
		headless = false) {
	difference() {
		union() {
			hotend_mount(
				dalekify = dalekify,
				quickrelease = quickrelease,
				vent = vent,
				headless = headless,
				render_thread = false
			);

			effector_base(large = false);
		}

		// opening at bottom
		translate([0, 0, 0])
			cylinder(r1 = r1_opening, r2 = r2_opening, h = t_effector + 0.1, center = true);

		/*translate([0, 0, -t_effector / 2 - 1])
			rotate([0, 0, 60])
				effector_shroud_holes(diameter = d_M3_screw / 2 - 0.15, height = t_effector + 1 - 2 * layer_height);*/
	}
}

module effector_shroud_holes(diameter, height) {
	for (i = [0:2])
		rotate([0, 0, i * 120])
			translate([0, r2_opening + 4, 0])
				cylinder(r = diameter, h = height);
}

module glass_holddown() {
	difference() {
		hull()
			for (i = [-1,1])
				translate([i * 1, 0, 0])
					cylinder(r = 6, h = 12, center = true);

		translate([4, 0, 0]) {
			cylinder(r = 2, h = 13, center = true);
		}

		translate([0, 0, -4])
			cube([20, 20, 8], center = true);

		translate([-152, 0, 0])
			cylinder(r = 152, h = 3, center = true);
	}
}

module ceramic_clamp(side = [-1, 1]) {
	w = -w_mount / 2 - w_base_mount / 2 + r_base_mount - w_base_mount / 2 + 4;
	difference() {
		intersection() {
			hull() {
				translate([0, r_bed_clamp + w_clamp / 2, h_bed_clamp - r_bed_clamp]) {
					rotate([0, 90, 0])
						cylinder(r = r_bed_clamp, h = 2 * l_clamp, center = true);
				}
				translate([0, r_printer - d_tile / 2 - 1, 0])
					cube([2 * l_clamp, 2, h_bed_clamp * 2], center = true);
				translate([0, w_clamp / 2 + 1, 1])
					cube([2 * l_clamp, 2, 2], center = true);
			}
			union() {
				for (side = side) {
					l = 0;
					l2 = -l_base_mount / 2 + l;
					x = cc_motor_mounts / 2 - l2 * cos(60) + w * sin(60);
					y = -l2 * sin(60) - w * cos(60);
					translate([side * x, y, h_bed_clamp / 2]) {
						rotate([0, 0, -30 * side])
							cube([w_bed_clamp, 4 * w_clamp, h_bed_clamp], center = true);
					}
				}
			}
		}
		for (side = [-1, 1]) {
			// Base mounting holes.
			for (l = [0, -l_base_mount / 2 + 4]) {
				l2 = -l_base_mount / 2 + l;
				x = cc_motor_mounts / 2 - l2 * cos(60) + w * sin(60);
				y = -l2 * sin(60) - w * cos(60);
				translate([side * x, y, -1])
					cylinder(d = d_M3_screw, h = h_bed_clamp + 2);
			}
		}
	}
}

module template_fixed_tool_mount() {
	cc_arm_mounts = 50;
	v_offset_arm_mount = 20; // offset from the top of the printer vertical
	y_third_hole = pow(pow(cc_arm_mounts, 2) - pow(cc_arm_mounts / 2, 2), 0.5);
	l_al_spacer = 80; // length of the aluminum 1" x 3" spacer between the two verticals
	offset_arm_mount = l_al_spacer - v_offset_arm_mount - y_third_hole;
	arm_mount = true; // set to true to generate template for the second vertical (part that arm attaches to)

	difference() {
		translate([0, (v_offset_arm_mount - cc_arm_mounts) / 2 + 3, 0])
			cube([l_member + 6, cc_arm_mounts + v_offset_arm_mount, 3], center = true);

		translate([0, (arm_mount) ? v_offset_arm_mount - offset_arm_mount : 0, 0]) {
			for (i = [-1, 1])
				translate([i * cc_arm_mounts / 2, (arm_mount) ? -y_third_hole : 0, 0])
					cylinder(r = 1.5, h = 5, center = true);

			translate([0, (arm_mount) ? 0 : -y_third_hole, 0])
				cylinder(r = 1.5, h = 5, center = true);
		}

		translate([0, (v_offset_arm_mount - cc_arm_mounts) / 2 - 5, 1])
			cube([l_member + 1, cc_arm_mounts + v_offset_arm_mount + 10, 3], center = true);
	}
}

module thumbscrew_quickrelease() {
	hex = 10.2; // size of hex head, mm
	r_hex = hex / 2 / cos(30); // radius of hex
	points = 6; // points in closed end thumbscrew
	h_wrench = 4; // thickness of the thumbscrew, mm

	difference() {
		union() {
			cylinder(r = r_hex + 5, h = h_wrench, center = true, $fn = 6);

			for (i = [0:5])
				rotate([0, 0, i * 360 / 6])
					translate([r_hex + 3.5, 0, 0])
						cylinder(r = 2.5, h = h_wrench, center = true, $fn = 16);
		}

		cylinder(r = r_hex, h = h_wrench + 1, center = true, $fn = points);
	}
}

module bbb_melzi_mount(
		render_small = true,
		render_large = true) {
	// width is short dimension, length is long dimension
	cc_w_melzi_mounts = 45.75 - 3.75; // c-c of melzi mounts on width axis
	cc_l_melzi_mounts = 200; // c-c of melzi mounts on length axis
	offset_melzi_mounts = 3.75 / 2 + 2; // distance from edge of board
	w_melzi = 50;
	w_bbb = 54.5;
	l_bbb = 86.3;
	bbb_melzi_offset = -20;
	h_standoff = 9;

	if (render_large)
		union() {
			// melzi
			translate([bbb_melzi_offset, -w_melzi, 0]) {
				difference() {
					union() {
						for (i = [-1, 1])
								translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = h_standoff, center = true);

						translate([0, 0, 1 - h_standoff / 2]) {
							hull(){
								translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole1[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([offset_melzi_mounts, cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([offset_melzi_mounts, cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole1[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole1[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole2[0], w_melzi + bbb_hole2[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole2[0], w_melzi + bbb_hole2[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							translate([4, w_melzi / 2, 0])
								hull()
									for (i = [0, -10])
										translate([i, 0, 0])
											cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);


							translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole2[1] - (bbb_hole2[1] - bbb_hole1[1]) / 2, 0])
								hull()
									for (i = [0, 10])
										translate([i, 0, 0])
											cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

						}
					}

					for (i = [-1, 1])
						translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
							cylinder(r = d_M3_screw / 2 - 0.25, h = h_standoff + 1, center = true);

					translate([-6, w_melzi / 2, 0])
						cylinder(r = d_M3_screw / 2, h = h_standoff + 1, center = true);

					translate([-bbb_melzi_offset + bbb_hole1[0] + 10, w_melzi + bbb_hole2[1] - (bbb_hole2[1] - bbb_hole1[1]) / 2, 0])
						cylinder(r = d_M3_screw / 2, h = h_standoff + 1, center = true);
				}
			}

			// bbb
			difference() {
				for (i = [0:2])
					translate([bbb_holes[i][0], bbb_holes[i][1], 0])
						cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = h_standoff, center = true);

				for (i = [0:3])
					translate([bbb_holes[i][0], bbb_holes[i][1], 0])
						cylinder(r = d_M3_screw / 2 - 0.25, h = h_standoff + 1, center = true);
			}
		}

	if (render_small)
		// for the opposite end of the melzi:
		translate([w_melzi / 2, 20, 0])
			rotate([0, 0, 90])
				difference() {
					union() {
						for (i = [-1, 1])
							translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
								cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = h_standoff, center = true);

						translate([0, 0, 1 - h_standoff / 2]) {
							hull(){
								translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([offset_melzi_mounts, cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							translate([4, w_melzi / 2, 0])
								hull()
									for (i = [0, -10])
										translate([i, 0, 0])
											cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
						}
					}

					for (i = [-1, 1])
						translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
							cylinder(r = d_M3_screw / 2 - 0.25, h = h_standoff + 1, center = true);

					translate([-6, w_melzi / 2, 0])
						cylinder(r = d_M3_screw / 2, h = h_standoff + 1, center = true);
				}
}

module connector_plate_full(top = true) {
	l_bbl_opening = 13.1; // length of barrel connector panel opening.
	l_bbl_center = 4.5; // distance from top of hole to center of connector.
	w_bbl_opening = 11; // width of barrel connector panel opening.
	t_bbl_panel = 1.75; // thickness of the barrel connector panel (groove in barrel jack).
	l_bbl_extra = 1.5; // Size of ridge on barrel connector.

	h_plate = t_board + t_bbl_panel / 2; // Fall into wood, but not through it.
	w_rim = d_M3_screw;

	l_rj45_housing = 36.5;
	w_rj45_housing = 22;
	w_rj45_jack = 14;
	l_rj45_jack = 16.5;
	top_offset_rj45_jack = 6;
	cc_rj45_mounts = 27.5;

	l_usb_housing = 38;
	w_usb_housing = 13;
	cc_usb_mounts = 28;
	l_usb_opening = 17;
	w_usb_opening = 9;

	difference() {
		union() {
			// Ridge through wood.
			hull()
				for (i = [-1, 1])
					for (j = [-1, 1])
						translate([i * (l_plate / 2 - r_plate_corners), j * (w_plate / 2 - r_plate_corners), 0])
							cylinder(r = r_plate_corners - .25, h = h_plate);

			// Front plate.
			hull()
				for (i = [-1, 1])
					for (j = [-1, 1])
						translate([i * (l_plate / 2 - r_plate_corners + l_plate_rim), j * (w_plate / 2 - r_plate_corners + w_rim), 0])
							cylinder(r = r_plate_corners, h = t_bbl_panel);
		}

		// Cut off half.
		translate([-l_plate / 2 - l_plate_rim - 1, top ? 0 : -w_plate, -1])
			cube([l_plate + 2 * l_plate_rim + 2, w_plate, h_plate + 2]);

		// Mounting holes.
		for (i = [-1, 1]) {
			translate([i * (l_plate / 2 + l_plate_rim / 2), 0, -1])
				cylinder(d = d_M3_screw, h = t_bbl_panel + 2);
		}

		// Inside of ridge.
		hull() {
			for (i = [-1, 1]) {
				for (j = [-1, 1]) {
					translate([i * (l_plate / 2 - r_plate_corners - 1), j * (w_plate / 2 - r_plate_corners - 1), t_bbl_panel])
						cylinder(r = r_plate_corners - 1, h = h_plate + 5);
				}
			}
		}

		// barrel connector
		translate([-(l_plate - w_bbl_opening) / 2 + 1, -l_bbl_center, -1]) {
			cube([w_bbl_opening, l_bbl_opening, h_plate + 2]);

			translate([-l_bbl_extra, -l_bbl_extra, t_bbl_panel + 1.01])
				cube([w_bbl_opening + 2 * l_bbl_extra, l_bbl_opening + 2 * l_bbl_extra, h_plate]);
		}

		// rj45 jack
		translate([-12, 0, 0]) {
			translate([-l_rj45_jack / 2, top_offset_rj45_jack - w_rj45_housing / 2, -1]) {
				cube([l_rj45_jack, w_rj45_jack, h_plate + 2]);

				translate([-(w_rj45_housing - l_rj45_jack) / 2, -w_plate / 2, t_bbl_panel + 1.01])
					cube([w_rj45_housing, 2 * w_plate, h_plate]);
			}

			for (i = [-1, 1])
				translate([i * cc_rj45_mounts / 2, 0, -1])
					cylinder(r = d_M3_screw / 2, h = h_plate + 2);
		}

		// usb jack
		translate([(l_plate - l_usb_housing) / 2 - 4, 0, 0]) {
			for (i = [-1, 1]) {
				translate([i * cc_usb_mounts / 2, 0, -1])
					cylinder(r = d_M3_screw / 2, h = h_plate + 2);
			}

			translate([-l_usb_opening / 2, -w_usb_opening / 2, -1])
				cube([l_usb_opening, w_usb_opening, h_plate + 2]);
		}
	}
}

module connector_plate() {
	union() {
		connector_plate_full(true);
		translate([0, 3, 0])
			connector_plate_full(false);
	}
}

module hexagon(r1, r2) {
	r_corner = 5;
	minkowski() {
		intersection() {
			circle(r = r1 * 2 - r_corner / cos(60), $fn = 3);
			rotate([0, 0, 180])
				circle(r = r2 * 2 - r_corner / cos(60), $fn = 3);
		}
		circle(r = r_corner);
	}
}

module minerva_hexagon(top_mount = false) {
	difference() {
		union() {
			hexagon(r_printer - w_clamp / 2, r_brd(cc_idler_mounts));
			difference() {
				hexagon(r_printer - w_clamp / 2 + w_clamp + t_board, r_brd(cc_idler_mounts) + w_clamp + t_board);
				// OpenSCAD only knows solid objects; this inner border should be deleted before cutting.
				hexagon(r_printer - w_clamp / 2 + 1, r_brd(cc_idler_mounts) + 1);
			}
		}
		for (i = [0:2]) {
			angle = [30, 150, 270][i];
			rotate([0, 0, -angle]) {
				for (offset = [r_printer + t_board / 2, r_printer - w_clamp - t_board / 2]) {
					translate([0, offset]) {
						rotate([0, 0, [0, 120, -120][i]])
							text("wvu"[i], halign = "center", valign = "center");
					}
				}
				for (side = [-1, 1]) {
					// Base mounting holes.
					w = -w_mount / 2 - w_base_mount / 2 + r_base_mount - w_base_mount / 2 + 4;
					for (l = [0, -l_base_mount / 2 + 4]) {
						l2 = -l_base_mount / 2 + l;
						x = cc_motor_mounts / 2 - l2 * cos(60) + w * sin(60);
						y = r_printer + l2 * sin(60) + w * cos(60);
						translate([side * x, y])
							circle(d = 3);
					}
					// Top mounting holes.
					translate([side * (l_clamp / 2 + 13), r_printer + 12])
						circle(d = 3);
				}
			}
		}
		if (top_mount) {
			rotate(-30 + 120) {
				translate([-l_alu / 2, r_printer + w_clamp / 2])
					square([l_alu, w_alu]);
			}
		}
		msg = ["Steps to finalize:",
			"1. Select path, break it apart and set no fill solid stroke.",
			"2. Remove outer hexagon of inner (double) ring.",
			"3. Select all text and make it red; use fill if desired.",
			"4. Remove this text."];
		for (i = [0:len(msg) - 1]) {
			translate([-100, 20 - i * 15])
				text(msg[i], size = 7, halign = "left", valign = "baseline");
		}
	}
}

module linking_board(idler, slot, marking1, marking2, message) {
	w = l_brd(idler ? cc_idler_mounts : cc_motor_mounts);
	difference() {
		square([w, h_apex]);
		if (!slot) {
			translate([w / 2, h_apex / 2])
				text(message, halign = "center", valign = "center");
		}
		for (i = [-1, 1]) {
			translate([w / 2 - i * w / 2 + i * (l_mount / 4 * 3 / 2), h_apex / 2]) {
				text(i < 0 ? marking2 : marking1, halign = "center", valign = "center");
			}
			for (p = [[0, 0], [1, -.5], [1, .5]]) {
				translate([w / 2 - i * w / 2 + i * (l_mount / 4 * 3 / 2 - cc_mount_holes / 2 + p[0] * cc_mount_holes), h_apex / 2 + p[1] * cc_mount_holes])
					circle(d = 3);
			}
		}
		if (slot) {
			hull() {
				for (i = [-1, 1]) {
					for (j = [-1, 1]) {
						translate([w / 2 + i * (l_plate / 2 - r_plate_corners), h_apex / 2 + j * (w_plate / 2 - r_plate_corners), 0])
							circle(r = r_plate_corners);
					}
				}
			}
			for (i = [-1, 1]) {
				translate([w / 2 + i * (l_plate / 2 + l_plate_rim / 2), h_apex / 2])
					circle(d = d_M3_screw);
			}
		}
	}
}

module vertical_board(v, z_offset_guides, marking) {
	size = l_guide_rods + 2 * z_offset_guides;
	difference() {
		square([size, v_width]);
		for (x = [[h_clamp / 2, z_offset_guides + 3], [size - h_clamp / 2, size - z_offset_guides - 3]]) {
			translate([x[0], v_width / 2]) {
				rotate([0, 0, -90])
					text(marking, halign = "center", valign = "center");
			}
			for (y = [-1, 1]) {
				translate([x[1], v_width / 2 + y * cc_v_board_mounts / 2])
					circle(d = 3);
			}
		}
		if (v) {
			spool_mount_dist = 16;
			for (i = [-1, 1]) {
				ewidth = 60 / sqrt(2) / 2;	// include sqrt(2) because it's a diagonal.
				eheight = size / 3 * 2;
				translate([eheight + i * ewidth, v_width / 2 - i * ewidth])
					circle(d = 3);
				translate([eheight - 150 - i * spool_mount_dist / 2, 20 - 8 - 5])
					circle(d = 3);
			}
		}
	}
}

module minerva_h_boards(z_offset_guides = 8) {
	union() {
		for (y = [0, 1, 2]) {
			translate([h_apex + y * (h_apex + 10), 0]) {
				rotate(90)
					linking_board(true, false, "uvw"[y], "vwu"[y], "Minerva");
				translate([0, l_brd(cc_idler_mounts) + 10]) {
					rotate(90)
						linking_board(false, y == 2, "uvw"[y], "vwu"[y], "http://zelfmaker.nl");
				}
			}
		}
		msg = ["Steps to finalize:",
			"1. Select path, break it apart (ctrl-shift-K) and set solid fill no stroke.",
			"2. Group boards (ctrl-G).",
			"3. Move boards to have slight overlap.",
			"4. Copy as many times as desired.",
			"5. Let inkscape remove overlap.",
			"6. Ungroup (ctrl-shift-G), set no fill solid stroke.",
			"7. Use path editor (F2) to remove duplicate paths.",
			"8. Select all text and make it red; use fill if desired.",
			"9. Remove this text."];
		for (i = [0:len(msg) - 1]) {
			translate([30, -20 - i * 15])
				text(msg[i], size = 7, halign = "left", valign = "baseline");
		}
	}
}

module minerva_v_boards(z_offset_guides = 8) {
	union() {
		for (y = [0, 1, 2]) {
			translate([0, y * (l_clamp - 2 * r_base_mount + 10)])
				vertical_board(y == 1, z_offset_guides, "uvw"[y]);
		}
		msg = ["Steps to finalize:",
			"1. Select path, break it apart (ctrl-shift-K) and set solid fill no stroke.",
			"2. Group boards (ctrl-G).",
			"3. Move boards to have slight overlap.",
			"4. Copy as many times as desired.",
			"5. Let inkscape remove overlap.",
			"6. Ungroup (ctrl-shift-G), set no fill solid stroke.",
			"7. Use path editor (F2) to remove duplicate paths.",
			"8. Select all text and make it red; use fill if desired.",
			"9. Remove this text."];
		for (i = [0:len(msg) - 1]) {
			translate([30, -20 - i * 15])
				text(msg[i], size = 7, halign = "left", valign = "baseline");
		}
	}
}

module tierod_ring() {
	difference() {
		circle(d = w2_tierod + w_laser);
		for (i = [0, 90]) {
			rotate([0, 0, i])
				square([w_tierod - w_laser, t_tierod - w_laser], center = true);
		}
	}
}

module minerva_tierod_cap(single = false) {
	// Surface = 2*pi*(1-sin(a)) = 4*pi*f
	// sin(a) = 1 - 2*f
	for (y = [0:single ? 0 : 2]) {
		for (x = [0:single ? 0 : 3]) {
			translate([x * 10, y * 10, 0]) {
				difference() {
					cylinder(r = (d_ball_bearing / 2) * cos(asin(1 - 2 * tierod_fraction)), h = h_tierod_cap + h_tierod_wall);
					translate([0, 0, -1])
						cylinder(d = d_tierod, h = h_tierod_wall + 1);
					translate([0, 0, h_tierod_cap + h_tierod_wall])
						sphere(d = d_ball_bearing);
				}
			}
		}
	}
}

module minerva_tierod() {
	offset = l_tierod / 6;
	union() {
		difference() {
			// Main rod.
			square([l_tierod, w_tierod + w_laser], center = true);
			// Slider slot.
			translate([0, -(t_tierod - w_laser) / 2])
				square([l_tierod, t_tierod - w_laser]);
			// Circular ends.
			for (i = [-1, 1]) {
				translate([i * l_tierod / 2, 0])
					circle(d = d_ball_bearing - w_laser);
			}
		}
		// Stopper.
		translate([-l_tierod / 2 + offset, -(w2_tierod + w_laser) / 2])
			square([w2_tierod - w_tierod + w_laser, w2_tierod + w_laser]);
		// Ring.
		translate([l_tierod / 2 + w2_tierod / 2 + w_laser, 0])
			tierod_ring();
	}
}

module tierod_assembled() {
	translate([0, 0, -t_tierod / 2])
		linear_extrude(height = t_tierod)
			minerva_tierod();
	rotate([90, 0, 180])
		translate([0, 0, -t_tierod / 2])
			linear_extrude(height = t_tierod)
				minerva_tierod();
	for (i = [-1, 1]) {
		translate([i * l_tierod / 2, 0, 0])
			%sphere(d = d_ball_bearing);
	}
}

l_pcb = 73;
w_pcb = 101;
h_pcb = 1.6;
module pcb_mount() {
	difference() {
		translate([0, 0, d_ball_bearing / 2])
			cube([l_pcb + d_M3_washer * 2, w_pcb + d_M3_washer * 2, d_ball_bearing], center = true);
		tool_mount_bearing_cage(d_small_tool_magnets, t_effector);
		translate([0, 0, d_ball_bearing]) {
			cube([l_pcb, w_pcb, h_pcb * 2], center = true);
			cube([l_pcb + 2 * d_M3_screw + .4, w_pcb + 2 * d_M3_screw + .4, h_pcb], center = true);
		}
		for (y = [-1, 0, 1]) {
			for (x = [-1, 1]) {
				translate([x * (l_pcb / 2 + d_M3_screw / 2 + .1), y * w_pcb / 3, -1])
					cylinder(d = d_M3_screw, h = d_ball_bearing + 2);
			}
		}
		for (y = [-1, 1]) {
			for (x = [-1, 0, 1]) {
				translate([x * l_pcb / 3, y * (w_pcb / 2 + d_M3_screw / 2 + .1), -1])
					cylinder(d = d_M3_screw, h = d_ball_bearing + 2);
			}
		}
	}
}

module hotend_shroud(height, twist) {
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

// vim: set filetype=c :
