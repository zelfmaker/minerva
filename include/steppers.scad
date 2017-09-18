/************************************************************************************

steppers.scad - dimesnions and modules for various stepper motors
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

include<fasteners.scad>

function r_mounts(cc_mounts) =
	pow(pow(cc_mounts, 2) / 2, 0.5);

l_NEMA11 = 28.2; // length of one side
d_NEMA11_collar = 22; // diameter of collar
d_NEMA11_shaft = 4.5; // diameter of shaft
cc_NEMA11_mount = 23; // c-c distance for mount holes
d_NEMA11_mount_screw = d_M2_5_screw;
NEMA11 = [l_NEMA11, d_NEMA11_collar, d_NEMA11_shaft, cc_NEMA11_mount, d_NEMA11_mount_screw];

l_NEMA17 = 42; // length of one side
d_NEMA17_collar = 22.5; // diameter of collar
d_NEMA17_shaft = 5.4; // diameter of collar
cc_NEMA17_mount = 31; // c-c distance for mount holes
d_NEMA17_mount_screw = d_M3_screw;
NEMA17 = [l_NEMA17, d_NEMA17_collar, d_NEMA17_shaft, cc_NEMA17_mount, d_NEMA17_mount_screw];

l_NEMA23 = 56.4; // length of one side
d_NEMA23_collar = 38.1; // diameter of collar
d_NEMA23_shaft = 6.35; // diameter of collar
cc_NEMA23_mount = 47.14; // c-c distance for mount holes
d_NEMA23_mount_screw = d_M5_screw;
NEMA23 = [l_NEMA23, d_NEMA23_collar, d_NEMA23_shaft, cc_NEMA23_mount, d_NEMA23_mount_screw];

// motor = [l_NEMAXX(0), d_NEMAXX_collar(1), d_NEMAXX_shaft(2), cc_NEMAXX_mount(3), d_NEMAXX_mount_screw(4)]
module NEMA_X_mount(
	height,
	l_slot,
	motor) {

	c_d_mount = r_mounts(motor[3]); // distance from shaft center to mount hole

	cylinder(r = motor[1] / 2, h = height, center = true);

	for (i=[0:3]) {
		rotate([0, 0, i * 90])
			translate([c_d_mount, 0, 0])
				hull()
					for (j = [-1, 1])
						translate([j * l_slot / 2, 0, 0])
							cylinder(r = motor[4] / 2, h = height, center = true);
	}
}


// motor = [l_NEMAXX(0), d_NEMAXX_collar(1), d_NEMAXX_shaft(2), cc_NEMAXX_mount(3), d_NEMAXX_mount_screw(4)]
module NEMA_parallel_mount(
	height,
	l_slot,
	motor)
	{

	hull()
		for (i = [-1, 1])
			translate([i * l_slot / 2, 0, 0])
				cylinder(r = motor[1] / 2, h = height, center = true);

	for (y=[-1, 1]) {
		for (x=[-1, 1]) {
			translate([x * motor[3] / 2, y * motor[3] / 2, 0])
				hull()
					for (j = [-1, 1])
						translate([x * j * l_slot / 2, y * j * l_slot / 2, 0])
							cylinder(r = motor[4] / 2, h = height, center = true);
		}
	}
}

module motor_shim(
	motor,
	thickness)
	{
	difference() {
		cube([motor[0], motor[0], thickness], center = true);

		NEMA_parallel_mount(
			height = thickness + 1,
			l_slot = 0,
			motor = motor);
	}
}

module stepper_pedestal(
	height,
	t_wall,
	t_mounts,
	motor) {
	difference() {
		pedestal_body(height = height, motor = motor);

		translate([0 ,0, -t_wall])
			difference() {
				hull() {
					for (i=[0:3]) {
						rotate([0, 0, i*90])
							translate([r_mounts(cc_mounts = motor[3]) + d_M3_washer / 2 - t_wall, 0, 0])
								cylinder(r1 = d_M3_washer / 2 + 1, r2 = d_M3_washer / 2, h = height);
					}
				}

				translate([0, 0, height-t_mounts+t_wall])
					for (i=[0:3]) {
						rotate([0, 0, i*90])
							translate([r_mounts(cc_mounts = motor[3]), 0, 0])
								cylinder(r=d_M3_washer/2+1.5, h=t_mounts);
					}
			}

		translate([0, 0, height / 2])
			rotate([0, 0, 45])
				NEMA_parallel_mount(
					height = height + 2,
					l_slot = 0,
					motor = motor);
	}
}

// pedestal body for the pedestal
module pedestal_body(motor, height) {
	hull() {
		for (i=[0:3])
			rotate([0, 0, i*90])
				translate([r_mounts(cc_mounts = motor[3]) + d_M3_washer / 2, 0, 0])
					cylinder(r1 = d_M3_washer / 2 + 1, r2 = d_M3_washer / 2, h = height);
	}
}
