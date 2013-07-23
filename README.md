=======================================
MIPS32 CPU Implementation in VHDL for
Advanced Digital Design class in DI UoA
=======================================
Spring-Summer 2013
=======================================

Description
===========

This is a VHDL implementation of a MIPS R2000 RISC cpu clone.

It supports 48 instructions and has BIST functionality
for the alu multiplier that can automatically test it with
three different methods: LFSR, Deterministic Counter and ATPG

Credits
=======

Elias Kouskoumvekakis   (eliaskousk@gmail.com)

Panagiotis Stergiou     (redfieldcs@gmail.com)

Software Used
=============

Xilinx ISE 14.5 with ISim
Sigasi 2.14 VHDL Editor
GNU Binutils 2.23
MARS 4.3 MIPS Simulator


Statistics 
==========

(After Post Place and Route for xc3s1000-5fg676 FPGA)

Slices Used: 1845 / 7680 (24%)
BRAMs Used : 10 / 24 (41%)

Minimum period:  12.490ns (Maximum frequency:  80.064MHz) 


Notes:
======

--------
Projects
--------

To open with ISE use the provided project:
./ise/mips_cpu_ise_14.5/mips_cpu_ise_14.5.xise

To simulate use ISim with the provided wave configuration file:
./ise/mips_cpu_ise_14.5/mips_cpu_top.wcfg

To open with Sigasi use the provided .project file in:
./sigasi/sigasi_2.x/

----------------
Software / BRAMs
----------------

To create the BRAMs from the assembly programs
go into the ./src/software directory and change
the makefile path to your cross compiling toolchain
(e.g binutils that contain gnu as and ld). Then run:

$ make all

If you don't have a toolchain download GNU Binutils and
run the ./src/software/tools/build_mipscross.sh script

The makefile automatically removes NOPs however it messes
the branch instructions so you either need to manually edit
the BRAMs that were generated or you need to "negate" the change
in the original assembly source like it is done in full.s and
then run the above make command. This will be improved in future
versions!

The BRAMs after generation will reside in the ./src/rtl/imem
directory. To load a program delete the original im_bram_512x32_0.vhd
file and then rename the im_bram_512x32_0_XXXXXXX.vhd file into
im_bram_512x32_0.vhd.

The full.s program that demonstrates all the supported instructions
is already loaded in im_bram_512x32_0.vhd
