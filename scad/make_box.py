#!/bin/env python3

import subprocess
import os

path = os.path.dirname(os.path.realpath(__file__))
scad_file = path + "/main_box.scad";

if not os.path.exists(path + "/stl"):
    os.makedirs(path + "/stl")

def openscad(*args):
	print("openscad", end=" ")
	for arg in args:
		print(arg, end=" ")
	print()
	subprocess.call(["openscad"] + list(args))

variables = ["BPanel", "FPanel", "BShell", "TShell", "Text"]
default_args = ["-Dmake_stl=1"]

for option in variables:
	default_args.append("-D" + option + "=0")

for option in variables:
	extra_args = [];
	openscad(*(default_args + ["-D" + option + "=1"] + [scad_file] + ["-o" + path + "/stl/" + option + ".stl"] + extra_args))
	#openscad(default_args, "-D" + option + "=1", path + "/main_box.scad", "-o " + path + "/" + option + ".stl")
