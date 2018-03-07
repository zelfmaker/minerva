/************************************************************************************

simple_delta_common.scad - common shapes used by various delta derivatives
Copyright 2015 Jerry Anzalone
Author: Jerry Anzalone <info@phidiasllc.com>

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
include <fasteners.scad>
include <bearings.scad>
include <steppers.scad>
include <Triangles.scad>
include <hotends.scad>
include <belt_terminator.scad>
include <belt_profiles.scad>
include <threads.scad>

// round_box makes a box with rounded corners
module round_box(
	length,
	width,
	height,
	radius = 4) {
	hull() {
		for (i = [-1, 1]) {
			translate([i * (length / 2 - radius), width / 2 - radius, 0])
				cylinder(r = radius, h = height, center = true);

			translate([i * (length / 2 - radius), -(width / 2 - radius), 0])
				cylinder(r = radius, h = height, center = true);
		}
	}
}

// the mount body forms the bulk of the linking board mounts on the motor and idler ends
// nut pockets will be included if: nut_pocket = 1 on exterior side, nut_pocket = -1 on interior side
module mount_body(
	cc_mount,
	l_base_mount,
	w_base_mount,
	t_base_mount,
	r_base_mount,
	l_slot = 0,
	hole_count = 3,
	height,
	nut_pocket,
	w_mount = w_mount,
	echo = true) {
	if (echo) {
		echo(str("Length of linking board to yield printer radius of ", r_printer, "mm  = ", l_brd(cc_mount), "mm"));
		echo(str("Linking board tab thickness = ", w_mount, "mm"));
		echo(str("Linking board height = ", height, "mm"));
		echo(str("Linking board hole c-c = ", cc_mount_holes, "mm"));
		echo(str("Linking board hole offset from end = ", l_mount / 4 * 3 / 2 - cc_mount_holes / 2, "mm"));
		echo(str("l_pad_mount = ", l_pad_mount, "mm"));
		echo(str("hexagon apex radius = ", r_printer - w_clamp / 2, "mm"));
		echo(str("hexagon linking board radius = ", r_brd(cc_mount), "mm"));
		echo(str("hexagon width = ", w_clamp + t_board, "mm"));
	}

	difference() {
		hull() {
			cylinder(r = w_mount / 2, h = height, center = true);

			translate([0, -l_mount + w_mount / 2, 0])
				cube([w_mount, w_mount, height], center = true);
		}

		// relief for board between apexs
		translate([w_mount - t_board, -l_mount / 2 - l_pad_mount, 0])
			cube([w_mount, l_mount, height + 2], center = true);

		// screw holes to mount linking board
		// Translate to halfway the available space (excluding padding).
		translate([0, -l_mount / 2 - l_pad_mount / 2, 0])
			if (hole_count == 4)
				for (i = [-1, 1])
					for (j = [-1, 1])
						translate([0, j * cc_mount_holes / 2, i * cc_mount_holes / 2]) {
							slot(l_slot = l_slot);

							if (nut_pocket != 0)
								translate([nut_pocket * (w_mount / 2 - 3), 0, 0])
									rotate([0, 90, 0])
										cylinder(r = d_M3_nut / 2, h = 2 * h_M3_nut, center = true, $fn = 6);
						}
			else if (hole_count == 3) {
				for (i = [-1, 1])
					translate([0, -cc_mount_holes / 2, i * cc_mount_holes / 2]) {
						slot(l_slot = l_slot);

						if (nut_pocket != 0)
							translate([nut_pocket * (w_mount / 2 - 3), 0, 0])
								rotate([0, 90, 0])
									cylinder(r = d_M3_nut / 2, h = 2 * h_M3_nut, center = true, $fn = 6);
					}

				translate([0, cc_mount_holes / 2, 0]) {
					slot(l_slot = l_slot);

					if (nut_pocket != 0)
						translate([nut_pocket * (w_mount / 2 - 3), 0, 0])
							rotate([0, 90, 0])
								cylinder(r = d_M3_nut / 2, h = 2 * h_M3_nut, center = true, $fn = 6);
				}
			}
	}
}

// just what it sounds like
module slot(l_slot) {
		rotate([0, 90, 0])
			if (l_slot > 0)
				hull()
					for (k = [-1, 1])
						translate([0, k * l_slot / 2, 0])
							cylinder(r = d_M3_screw / 2, h = w_mount + 2, center = true);
			else
				cylinder(r = d_M3_screw / 2, h = w_mount + 2, center = true);
}

// so that the relief of the mount holes for vertical boards are consistent:
module vertical_board_relief(echo = true) {
	// holes to mount vertical boards
	for (i = [-1, 1])
		translate([i * cc_v_board_mounts / 2, w_clamp / 2, 0])
			rotate([90, 0, 0]) {
				cylinder(r = d_M3_screw / 2, h = w_clamp, center = true);
				translate([0, 0, (l_clamp - l_idler_relief) / 4 - h_M3_nut])
					cylinder(d = d_M3_nut, h = h_M3_nut + 1, $fn = 6);
			}

	if (echo) echo(str("c-c vertical board mounts = ", cc_v_board_mounts));
}

// the mount is the shape that linking boards attach to
module mount(
	l_slot,
	height,
	cc_mount,
	base_mount = true,
	nut_pocket,
	echo) {
	union() {
		mount_body(
			cc_mount = cc_mount,
			l_base_mount = l_base_mount,
			w_base_mount = w_base_mount,
			t_base_mount = t_base_mount,
			r_base_mount = r_base_mount,
			l_slot = l_slot,
			height = height,
			nut_pocket = nut_pocket,
			echo = echo);

		if (base_mount) {
			// boss for mounting base plate
			translate([-w_mount / 2 - w_base_mount / 2 + r_base_mount, -l_base_mount / 2, (t_base_mount - height) / 2]) {
				difference() {
					round_box(
						w_base_mount,	// short
						l_base_mount,	// long
						t_base_mount,	// z
						radius = r_base_mount);

					// Platform screw holes.
					translate([-w_base_mount / 2 + 4, -l_base_mount / 2 + 4, 0])
						cylinder(r = d_M3_screw / 2, h = t_base_mount + 1, center = true);

					translate([-w_base_mount / 2 + 4, 0, 0])
						cylinder(r = d_M3_screw / 2, h = t_base_mount + 1, center = true);
				}
			}
			if (echo) {
				for (c = [[l_base_mount / 2, -w_base_mount + 4], [l_base_mount - 4, -w_base_mount + 4]])
					echo(str("hexagon mount hole: ", cc_mount / 2 + c[0] * cos(60) + c[1] * sin(60), ", ", r_printer + c[1] * cos(60) - c[0] * sin(60), "mm"));
			}
		}
	}
}

// the apex is the shape of the motor or idler end
module apex(
	l_slot,
	height = h_clamp,
	cc_mount,
	base_mount = true,
	nut_pocket = 0,
	echo = true
) {
	// Central bar.
	hull() {
		for (i = [-1, 1])
			translate([i * cc_mount / 2, 0, 0])
				cylinder(r = w_mount / 2, h = height, center = true);
	}

	// Legs
	for (i = [-1, 1])
		translate([i * cc_mount / 2, 0, 0])
			rotate([0, 0, i * 30])
				mirror([(i < 0) ? i : 0, 0, 0])
					mount(
						l_slot = l_slot,
						height = height,
						cc_mount = cc_mount,
						base_mount = base_mount,
						nut_pocket = nut_pocket,
						echo = echo);
}

// rod_clamp_relief uses the whole motor/idler end as a clamp, requiring threaded rods to apply clamping force
module rod_clamp_relief(
	height,
	z_offset_guides,
	height_divisor = 4) {
	union() {
		// clamp screws
		for (i = [-1, 1])
			for (j = [-1, 1])
				translate([0, (w_idler_relief + d_M3_nut) / 2 - 1, i * height / height_divisor])
					rotate([0, 90, 0]) {
						translate([0, 0, j * (l_clamp / 2 + 0.1)])
							cylinder(r = d_M3_washer / 2 + 1, h = 1, center = true);

						cylinder(r = d_M3_screw / 2, h = l_clamp + 1, center = true);
					}

		// guide rod holes and slots for clamp
		for (i = [-1, 1])
			translate([i * cc_guides / 2, 0, 0]) {
				translate([0, 0, z_offset_guides - height / 2])
					cylinder(r = d_guides / 2, h = height);

				translate([0, (w_clamp - d_guides) / 2 + 0.5, 0])
					cube([gap_clamp, w_clamp, height + 1], center = true);
			}
	}
}

// bar_clamp_relief employs bars with M3 nuts for application of clamping force in the motor/idler ends
module bar_clamp_relief(z_offset_guides) {
	// instead of using the end body as a clamp, use a bar:
	for (i = [-1, 1])
		translate([i * cc_guides / 2, 0, 0]) {
			// put a hole all the way through so Slic3r doesn't treat it like a hole in the model
			cylinder(r = 0.1, h = h_clamp + 1, center =true);

			translate([0, 0, z_offset_guides])
				cylinder(r = d_guides / 2, h = h_clamp, center = true);

			// the bar clamp will be rectangular but the pocket it sits in will be trapezoidal so that the clamp can be pressed against the guide rod
			translate([i * -t_bar_clamp / 2, 0, 0]) {
				hull() {
					translate([0, -w_clamp / 2 - 1, 0])
						cube([t_bar_clamp, 0.1, h_bar_clamp + 4 * layer_height], center = true);

					translate([i, w_clamp / 2 + 1, 0])
						cube([t_bar_clamp + 2, 0.1, h_bar_clamp + 4 * layer_height], center = true);
				}

				translate([i * (pad_clamp / 2 + 1), w_clamp / 2 - 7, 0])
					rotate([0, 90, 0])
						cylinder(r = d_M3_screw / 2, h = 2 * pad_clamp, center = true);
			}
		}
}

// bar_clamp is the part that clamps against the guide rods when the motor/idler ends use bar_clamp_relief
module bar_clamp() {
	mirror([0, 0, 1])
		difference() {
			cube([h_bar_clamp, w_clamp, t_bar_clamp], center = true);

			translate([0, w_clamp / 2 - 7, 0]) {
				translate([0, 0, -t_bar_clamp / 2 - layer_height])
					cylinder(r = d_M3_screw / 2, h = t_bar_clamp, center = true);

				translate([0, 0, t_bar_clamp / 2])
					cylinder(r = d_M3_nut / 2, h = 2 * h_M3_nut + 1, center = true, $fn = 6);
			}

			translate([0, 0, -t_bar_clamp / 2])
				rotate([0, 90, 0])
					cylinder(r = d_guides / 2, h = h_bar_clamp + 1, center = true);

			//angle the outside end so it's flush with the face of the end when tightened
			translate([0, w_clamp / 2 + (h_bar_clamp - h_bar_clamp * sin(atan(2 / w_clamp))) / 2, 0])
				rotate([atan(2 / w_clamp), 0, 0])
					cube([h_bar_clamp + 1, h_bar_clamp, h_bar_clamp], center = true);
		}
}

// the hotend_cage is the part of the hotend mount that the fan mounts to
module hotend_cage(
	d_fan_mount_hole,
	cc_mount_holes,
	d_fan,
	y_offset,
	z_offset,
	dalekify = false,
	vent = false
) {

	y_offset_fan = d_hotend_side / 2 + t_heat_x_jhead / 2 * sin(a_fan_mount) + y_offset;
	z_offset_fan = z_offset + t_effector;
	h_thickness = t_hotend_cage / cos(a_fan_mount); // length of hypoteneus based upon thickness of cage
	t_fan_mount = 3;
	h_fan_mount = t_fan_mount / 2 / cos(a_fan_mount);
	r_mount_holes = pow(pow(cc_mount_holes / 2, 2) * 2, 0.5);

	difference() {
		union() {
			difference() {
				hotend_cage_shape(
					thickness = t_hotend_cage,
					d_hotend_side = d_hotend_side,
					l_fan = l_fan,
					y_offset_fan = y_offset_fan,
					z_offset_fan = z_offset_fan,
					a_fan_mount = a_fan_mount,
					y_offset = y_offset,
					z_offset = z_offset,
					dalekify = dalekify);

				hotend_cage_shape(
					thickness = t_hotend_cage - 6,
					d_hotend_side = d_hotend_side - 5,
					l_fan = l_fan - 6,
					y_offset_fan = y_offset_fan + 0.5,
					z_offset_fan = z_offset_fan,
					y_offset = y_offset,
					z_offset = z_offset,
					a_fan_mount = a_fan_mount);
			}

			// Fan mounting tabs.
			translate([0, y_offset_fan, (l_fan > h_thickness) ? z_offset_fan + (l_fan - h_thickness) / 2: z_offset_fan]) {
				rotate([90 + a_fan_mount, 0, 0]) {
					for (i = [-1, 1]) {
						translate([i * cc_mount_holes / 2, cc_mount_holes / 2, 0]) {
							rotate([0, 0, i * 20]) {
								hull() {
									cylinder(r = 3, h = t_fan_mount, center = true);

									translate([0, -4, 0])
										cylinder(r = 1, h = t_fan_mount, center = true);
								}
							}
						}
					}

					for (i = [-1, 1]) {
						translate([i * cc_mount_holes / 2, -cc_mount_holes / 2, 0])
							cylinder(r = 3, h = t_fan_mount, center = true);
					}
				}
			}
		}

		// Fan mounting holes.
		translate([0, y_offset_fan, (l_fan > h_thickness) ? z_offset_fan + (l_fan - h_thickness) / 2: z_offset_fan]) {
			rotate([90 + a_fan_mount, 0, 0]) {
				for (i = [0:3]) {
					rotate([0, 0, i * 90 + 45]) {
						translate([0, r_mount_holes, 0]) {
							cylinder(d = d_M3_screw, h = t_fan_mount + 1, center = true);
							translate([0, 0, t_fan_mount / 2])
								cylinder(d = d_M3_nut * 1.3, h = h_M3_nut * 2);
						}
					}
				}
				// Front wire hole.
				hull() {
					for (i = [0, 1]) {
						translate([l_fan / 2 - 3 / 2, -l_fan / 4, -d_wire_hole * i]) {
							rotate([0, 90, 0])
								cylinder(d = d_wire_hole, h = 6 / 2 + 2, center = true);
						}
					}
				}
			}
		}

		if (vent) {
			for (i = [-4:4])
				if (i != 0)
					rotate([0, 0, i * 20])
						translate([0, -15, 0])
							rotate([90, 0, 0])
								hull()
									for (j = [-1, 1])
										translate([0, 0, j * 15])
											scale([0.2, 1])
												cylinder(r = t_hotend_cage / 4, h = 1, center = true);
		}
	}
}

// hotend_cage_shape forms the fan-to-outlet transition that is the exterior and interior of the bulk of the hotend cage
module hotend_cage_shape(
	thickness,
	d_hotend_side,
	l_fan,
	y_offset_fan,
	z_offset_fan,
	a_fan_mount,
	y_offset = 5,
	z_offset = 10,
	dalekify = false) {

	h_thickness = thickness / cos(a_fan_mount); // length of hypoteneus based upon thickness of cage
	r_dalek_spheres = 2;
	a_dalek_spheres = 30;

	union() {
		hull() {
			// Bottom ring.
			translate([0, 0, -thickness / 2])
				cylinder(d = d_hotend_side + 2 * r_flare, h = .1, $fn = dalekify ? 12 : $fn);
			// Top ring.
			translate([0, y_offset, thickness / 2 + z_offset])
				cylinder(d = d_hotend_side, h = .1, $fn = dalekify ? 12 : $fn);
			// Fan plate.
			translate([0, y_offset_fan, (l_fan > h_thickness) ? z_offset_fan + (l_fan - h_thickness) / 2 : z_offset_fan])
				rotate([90 + a_fan_mount, 0, 0])
					round_box(
						l_fan,
						l_fan,
						3,
						radius = 3);
		}

		if (dalekify) {
			translate([0, 0, -thickness / 2])
				for (i = [0:3])
					translate([0, 0, i * (thickness - t_effector - r_dalek_spheres) / 4 + t_effector + r_dalek_spheres])
						rotate([0, 0, a_dalek_spheres / 2])
						for (j = [-3:2])
							rotate([0, 0, j * a_dalek_spheres])
								translate([0, -(d_hotend_side / 2 + r_flare * (thickness - (i * (thickness - t_effector) / 4 + t_effector)) / thickness), 0])
									sphere(r = r_dalek_spheres);
		}
	}
}

// hotend_mount is the shape placed on a tool or effector onto which a fan and hot end can be mounted
module hotend_mount(dalekify = false,
	quickrelease = false,
	vent = false,
	render_thread = true,
	headless = true,
	y_offset = -5,
	z_offset = 10
) {
	difference() {
		union() {
			difference() {
				union() {
					// hot end cage
					translate([0, 0, (t_hotend_cage - t_effector) / 2]) {
						hotend_cage(
							d_fan_mount_hole = 3.4,
							cc_mount_holes = 32,
							d_fan = 38,
							y_offset = y_offset,
							z_offset = z_offset,
							dalekify = dalekify,
							vent = vent
						);
					}

					// hot end retainer body
					translate([0, y_offset, z_offset + z_offset_retainer]) {
						difference() {
							cylinder(r1 = r1_retainer_body, r2 = r2_retainer_body, h = h_retainer_body + r2_retainer_body - countersink_quickrelease);
							if (headless) {
								translate([0, 0, h_groove_jhead + h_groove_offset_jhead - .1])
									cylinder(r = r1_retainer_body, h = h_retainer_body);
							}
						}

						// hot end retainer mount
						for (x = [-1, 1]) {
							translate([x * (d_large_jhead + d_M3_nut) / 2, -6 / 2 + d_large_jhead / 2, h_retainer / 2])
								cube([d_M3_nut, 6, h_retainer], center = true);
						}
					}
				} // end union

				// bottom opening for hot end
				translate([0, 0, -t_effector / 2 - 1])
					cylinder(r1 = r1_opening, r2 = r2_opening, h = t_effector + 1.5);

				// hot end mounting parts
				translate([0, y_offset, z_offset + z_offset_retainer]) {
					// Thin part of the hot end.
					translate([0, 0, -1])
						hull()
							for (i = [0, 1])
								translate([0, i * d_hotend_side, 0])
									cylinder(d = d_small_jhead + i * 2, h = h_groove_jhead + 2);

					translate([0, 0, h_groove_jhead]) {
						// Upper thick part of hot end.
						hull()
							for (i = [0, 1])
								translate([0, i * d_large_jhead / 2, 0])
									cylinder(d = d_large_jhead + i * 2, h = h_groove_offset_jhead);

						// Slope for easier insertion.
						hull() {
							translate([0, d_large_jhead / 3, h_groove_offset_jhead / 2])
								cube([d_large_jhead + 2 * (2 / 3), 0.1, h_groove_offset_jhead], center = true);

							translate([0, d_large_jhead, (h_groove_offset_jhead - 3) / 2])
								cube([d_large_jhead + 4, 0.1, h_groove_offset_jhead + 3], center = true);
						}

						// Cut off front so retainer will fit.
						translate([0, d_large_jhead, 0])
							cube([d_large_jhead + 2 * d_M3_screw, d_large_jhead, h_groove_offset_jhead + 5], center = true);

						if (quickrelease) {
							// Bowden sheath
							translate([0, 0, h_groove_offset_jhead + layer_height])
								cylinder(d = headless ? 12 : bowden[2], h = 30);

							// quick release fitting threads
							if (!headless && render_thread) {
								translate([0, 0, r2_retainer_body + h_retainer_body - h_groove_jhead]) {
									translate([0, 0, -countersink_quickrelease]) {
										translate([0, 0, -l_quickrelease_threads])
											metric_thread(diameter = d_quickrelease_threads, pitch = pitch_quickrelease_threads, length = l_quickrelease_threads, internal = true, n_starts = 1);
									}
								}
							}
						}
						else {
							// Bowden sheath retainer
							translate([0, 0, h_groove_offset_jhead + layer_height]) {
								cylinder(r = bowden[0] / 2, h = bowden[1], $fn = 6);

								// bowden sheath
								translate([0, 0, bowden[1] + layer_height])
									cylinder(r = bowden[2] / 2, h = 30);

								// retainer retainer
								translate([0, (d_large_jhead + d_retainer_screw) / 2, 0])
									cylinder(r = d_retainer_screw / 2 - 0.15, h = 20);

								translate([0, (d_large_jhead + d_retainer_screw) / 2, 6])
									cylinder(r = d_M2_screw_head / 2, h = 20);
							}
						}
					}

					if (dalekify) {
						for (i = [-1,1])
							translate([i * (d_hotend_side / 2 - 3), 0, 3])
								rotate([80, 0, 0])
									cylinder(r = 2.2 / 2, h = 20);

						translate([0, -r2_retainer_body + 7, h_retainer_body + r2_retainer_body - 5])
							rotate([70, 0, 0])
								cylinder(r = 2.2 / 2, h = 20);
					}

				}

			} // end difference

			translate([0, 0, z_offset_retainer - 1.5 * layer_height]) {
				// floor for retainer body
				translate([0, y_offset + d_hotend_side / 2 - 2, z_offset])
						cube([l_fan - 5, 7, 2 * layer_height], center = true);
				translate([0, y_offset - d_large_jhead / 2 + 5, z_offset])
						cube([l_fan - 18, 4, 2 * layer_height], center = true);
			}
			translate([0, y_offset + d_large_jhead / 2 + 2, z_offset_retainer + h_groove_offset_jhead + h_groove_jhead + layer_height + z_offset])
				cube([l_fan - 5, 8, 2 * layer_height], center = true);
		} // end floor union
		// Screw holes for hot end retainer
		for (x = [-1, 1]) {
			translate([x * (d_large_jhead + d_M3_screw * 2) / 2, y_offset + d_large_jhead / 2, z_offset + z_offset_retainer + h_retainer / 2]) {
				translate([0, 1, 0]) {
					rotate([90, 0, 0])
						cylinder(d = d_M3_screw, h = h_retainer_body * 2);
				}
				translate([0, -9 - .1, 0]) {
					rotate([90, 0, 0])
						cylinder(d = d_M3_cap + 1, h = h_retainer_body * 2);
				}
			}
		}
	}
}

// tool_mount_body is the shape forming the base of a tool mount to be used on a tool end effector
module tool_mount_body(d_effector_tool_magnet_mount, h_effector_tool_mount) {
	union() {
		hull() {
			for (i = [0:2]) {
				rotate([0, 0, i * 120 + 60]) {
					translate([0, d_effector_tool_magnet_mount / 2, 0])
						cylinder(r = d_ball_bearing / 2 + 2.5, h = h_effector_tool_mount, center = true);
				}
			}
		}

		for (i = [0:2]) {
			rotate([0, 0, i * 120 + 60]) {
				translate([0, d_effector_tool_magnet_mount / 2, -1]) {
					difference() {
						sphere(r = d_ball_bearing / 2 + 2);

						translate([0, 0, -d_ball_bearing / 2])
							cylinder(r = d_ball_bearing, h = d_ball_bearing, center = true);
					}
				}
			}
		}

		// put an index on the edge normal the y-axis
		translate([5 * tan(30), (d_effector_tool_magnet_mount / 2 + d_ball_bearing / 2 + 1.5) * tan(30), 0]) {
			rotate([0, 0, 60]) {
				linear_extrude(height = h_effector_tool_mount, center = true)
					equilateral(5);
			}
		}

	}
}

// tool_mount_bearing_cage forms the relief for the ball bearings used in the tool mount
module tool_mount_bearing_cage(d_effector_tool_magnet_mount, h_effector_tool_mount) {
	// place the center of the ball bearings just under the top of the mount so they snap in their pockets
	for (i = [0:2]) {
		rotate([0, 0, i * 120 + 60]) {
			translate([0, d_effector_tool_magnet_mount / 2, -h_effector_tool_mount / 2 + 2])
				sphere(d = d_ball_bearing + 1.5);
		}
	}
}

// magnet_mount is the shape of the bosy and pocket into which magnets are mounted
module magnet_mount(r_pad, h_pad, relief_only = false) {
	// this places the pivot point at the origin
	if (relief_only) {
		translate([0, 0, h_magnet / 2 - d_bearing_with_magnet + d_ball_bearing / 2]) {
			translate([0, 0, 10]) {
				cylinder(r1 = od_magnet / 2 + 0.25, r2 = od_magnet / 2, h = h_magnet + 20, center = true);
			}
		}
	}
	else {
		translate([0, 0, h_magnet / 2 - d_bearing_with_magnet + d_ball_bearing / 2]) {
			difference() {
				translate([0, 0, -h_pad / 2])
					cylinder(r = od_magnet / 2 + r_pad, h = h_magnet + h_pad, center = true);

				translate([0, 0, 1])
					cylinder(r1 = od_magnet / 2 + 0.25, r2 = od_magnet / 2, h = h_magnet + 2, center = true);
			}
			// magnet and ball bearing
			if (false) {
				%union() {
					difference() {
						cylinder(r = od_magnet / 2, h = h_magnet, center = true);

						cylinder(r = od_magnet / 4, h = h_magnet + 1, center = true);
					}

					translate([0, 0, -h_magnet / 2 + d_bearing_with_magnet - d_ball_bearing / 2])
						sphere(r = d_ball_bearing / 2);
				}
			}
		}
	}
}

// effector_base is the shape of the base of the end effector
module effector_base(large = false) {
	r_apex = 2.5;

	difference() {
		union() {
			difference() {
				// magnet mounts are always in the same position
				effector_tierod_magnets();

				// need to flatten base
				translate([0, 0, -t_effector * 5])
					cylinder(r = r_effector * 2, h = t_effector * 5);
			}

			if (large){
				r = sqrt(r_effector * r_effector + l_effector * l_effector / 4);
				cylinder(r1 = r, r2 = r - od_magnet / 2, h = t_effector);
			}
			else {
				// inner portion of effector
				difference() {
					translate([0, r_triangle_middle - h_triangle_inner, 0])
						linear_extrude(height = t_effector)
							equilateral(h_triangle_inner);

					// round the triangle apexes
					for(i = [0:2])
						rotate([0, 0, i * 120])
							translate([0, r_triangle_middle - h_triangle_inner, -2])
								cylinder(r = r_apex, h = t_effector + 3);
				}
			}

			// put an index on the side normal the y-axis
			translate([5 * tan(30), (large) ? (h_triangle_inner + od_magnet) / 2 + r_pad_effector_magnet_mount - 1: h_triangle_inner * tan(30) * tan(30) - 1, 0])
				rotate([0, 0, 60])
					linear_extrude(height = t_effector + 1)
						equilateral(5);
		}
		effector_tierod_magnets(relief_only = true);
	}
}

module effector_tierod_magnets(relief_only = false) {
	translate([0, 0, h_effector_magnet_mount]) {
		for (i = [0:2]) {
			rotate([0, 0, i * 120]) {
				translate([0, r_effector, 0]) {
					rotate([tierod_angle - 90, 0, 0]) {
						for (j = [-1, 1]) {
							translate([j * (l_effector) / 2, 0, 0])
								magnet_mount(r_pad = r_pad_effector_magnet_mount, h_pad = h_effector_magnet_mount, relief_only = relief_only);
						}
					}
				}
			}
		}
	}
}

module dog_relief(l, nuts = false, extra = -1) {
	translate([-belt_height - belt_extra, -1, -1])
		cube([belt_height - belt_tooth_depth + belt_extra, l + 2, h_belt + 1]);
	intersection() {
		for (i = [0:floor(l / belt_pitch) + 1]) {
			translate([-belt_tooth_depth, i * belt_pitch, -1])
					cylinder(r = belt_tooth_depth, h = h_belt + 1, $fn = 12);
		}
		translate([-(belt_height + belt_tooth_depth) / 2, -2 * belt_tooth_depth, -1])
			cube([belt_height - (belt_height - belt_tooth_depth) / 2 + 1, l + 4 * belt_tooth_depth, h_belt + 3]);
	}
	for (i = [-1, 1]) {
		translate([-belt_height / 2 + i * cc_belt_terminator / 2, -1, h_belt / 2]) {
			rotate([-90, 0, 0]) {
				cylinder(d = d_M3_screw, h = l + 2);
				if (nuts) {
					translate([0, 0, (extra >= 0 ? l_belt_dog + 10 + 6 + 1 : 7)])
						rotate([0, 0, 30])
							cylinder(d = d_M3_nut, h = h_M3_nut + 1, $fn = 6);
				}
			}
		}
	}
}

// carriage_body renders the solid parts of the carriage with relief dor the end stop adjustment screw
module carriage_body(limit_switch_mount = true, extra = 0, name) {
	total_h = h_carriage + (extra >= 0 ? h_carriage + extra : 0);
	e = (extra >= 0 ? 1 : -1);
	difference() {
		union() {
			// bearing saddles
			for (i = [-1, 1])
				translate([i * cc_guides / 2, 0, -h_carriage / 2]) {
					hull() {
						translate([i * 2, 0, 0])
							cylinder(r = od_lm8uu / 2 + 3, h = total_h);
						translate([i * (-od_lm8uu / 2 - 5), -od_lm8uu / 2 - 3, 0])
							cube([1, od_lm8uu + 2 * 3, total_h]);
					}
				}

			// boss for the limit switch engagement screw
			if (limit_switch_mount) {
				translate([e * (l_effector / 2 - limit_x_offset), y_web, e * -h_carriage / 2]) {
					difference() {
						hull() {
							rotate([0, e * 90 - 90, 0]) {
								for (i = [0, 1]) {
									translate([0, i * (limit_y_offset - y_web), 0])
										cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 2, h = 7);
								}
								if (extra < 0) {
									translate([0, 0, h_carriage * .8])
										cylinder(r = .1, h = .1);
								}
							}
						}

						translate([-(d_M3_screw + 5) / 2, 0, -total_h - 1])
							cube([d_M3_screw + 5, d_M3_screw + 5, total_h + 2]);
					}
				}
			}

			// web
			translate([-cc_guides / 2, y_web - w_carriage_web / 2, -h_carriage / 2])
				cube([cc_guides, w_carriage_web, total_h]);
			// name
			translate([0, y_web - w_carriage_web / 2 + 1, -h_carriage / 2 + total_h / 2]) {
				rotate([90, 90 + e * 90, 0]) {
					linear_extrude(height = 2) {
						scale(4 + e)
							text(name, halign = "center", valign = "center");
					}
				}
			}
			// belt dog
			translate([e * d_pulley / 2, -h_belt / 2, -h_carriage / 2]) {
				difference() {
					union() {
						offset = (extra >= 0 ? l_belt_dog + 10 : h_carriage - 6 - h_M3_nut);
						w = cc_guides / 2 + (cc_belt_terminator + d_M3_washer) / 2;
						translate([-cc_guides / 2, y_web + h_belt / 2, offset]) {
							hull() {
								cube([w, -y_web + h_belt / 2, 6 + h_M3_nut]);
								translate([0, 0, -8])
									cube([w, .1, .1]);
							}
							if (extra >= 0) {
								hull() {
									translate([0, 0, 26])
										cube([w, -y_web + h_belt / 2, total_h - offset - 26]);
									translate([0, 0, 6 + h_M3_nut - .1])
										cube([w, .1, .1]);
								}
							}
						}
						if (extra < 0) {
							translate([-cc_guides / 2, y_web + h_belt / 2, 0])
								cube([w, -y_web + h_belt / 2, 6 + h_M3_nut]);
						}
					}
					translate([0, h_belt, total_h / 2 + e * total_h / 2]) {
						rotate([90, 90 + 90 * e, 0])
							dog_relief(total_h, true, extra);
					}
				}
			}
		}

		// end stop screw
		if (limit_switch_mount) {
			translate([e * (l_effector / 2 - limit_x_offset), limit_y_offset, -total_h / 2 - 1])
				cylinder(r = d_M3_screw / 2 - 0.4, h = total_h + 2);
		}
	}
}

// carriage_bearing_relief renders the pockets for lm8uu bearings and guide rods for the carriage
module carriage_bearing_relief(extra = 0) {
	total_h = h_carriage + (extra >= 0 ? h_carriage + extra : 0);
	union() {
		// bearing pockets and guide rod relief
		for (i = [-1, 1]) {
			translate([i * cc_guides / 2, 0, -h_carriage / 2 - 1]) {
				for (j = [0, 1])
					for (h = extra >= 0 ? [0, total_h - h_carriage] : [0]) {
						translate([0, j * (od_lm8uu / 2 - 1), h + (h_carriage - l_lm8uu) / 2 + 1])
							cylinder(r = od_lm8uu / 2, h = l_lm8uu);
					}

				hull() {
					cylinder(d = d_guides + 2, h = total_h + 2);

					translate([0, od_lm8uu / 2 + 3, 0])
						cylinder(d = d_guides + 2, h = total_h + 2);
				}
			}
		}

		translate([-cc_guides / 2 - od_lm8uu / 2 - 6, -od_lm8uu / 4 - 2.5 + 10, -h_carriage / 2 - 1])
			cube([cc_guides + od_lm8uu + 12, od_lm8uu / 2 + 5, total_h + 2]);
	}
}

// carriage_wire_tie_relief are the slots for wire ties in the carriage
module carriage_wire_tie_relief(extra = 0) {
	total_h = h_carriage + (extra >= 0 ? h_carriage + extra : 0);
	for (h = extra >= 0 ? [0, total_h - h_carriage] : [0]) {
		translate([0, 0, h]) {
			difference() {
				hull() {
					cylinder(r = od_lm8uu / 2 + 2.4, h = 4.5, center = true);

					translate([0, -6, 0])
						cylinder(r = od_lm8uu / 2 + 2.4, h = 4.5, center = true);
				}

				hull() {
					cylinder(r = od_lm8uu / 2 + 1, h = 6, center = true);

					translate([0, -6, 0])
						cylinder(r = od_lm8uu / 2 + 1, h = 6, center = true);
				}
			}
		}
	}
}

// 12mm_vboard_mount is a shape for tucking wires under and attaching fixtures to 12mm thick boards
module board_mount(
	height = 20,
	length = 10,
	width = t_board + 8,
	d_wire_guide = t_board + .2,
	wire_guide_offset = 4
) {
	difference() {
		cube([length, width, height], center = true);

		rotate([0, 90, 0])
			hull()
				for (i = [-1, 1])
					translate([i * height / 2 - d_wire_guide / 2 - wire_guide_offset, 0, 0])
						rotate([0, 0, 30])
							cylinder(r = d_wire_guide / 2, h = length + 1, center = true, $fn = 6);
		for (i = [-1, 1]) {
		}
	}
}

// vim: set filetype=c :
