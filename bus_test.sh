#!/bin/bash

iverilog -Wall -g 2012 rtl/mips_cpu_bus_tb.v -o rtl/mips_cpu_bus_tb_addiu rtl/mips_cpu_bus.v rtl/mips_cpu_harvard.v rtl/avl_slave_mem.v rtl/mips_cpu/*.v
./rtl/mips_cpu_bus_tb_addiu
rm rtl/mips_cpu_bus_tb_addiu
