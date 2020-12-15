#!/bin/bash

#iverilog -Wall -g 2012 rtl/mips_cpu_bus_tb.v -o rtl/mips_cpu_bus_tbrtl/mips_cpu_bus.v rtl/mips_cpu_harvard.v rtl/avl_slave_mem.v rtl/mips_cpu/*.v
iverilog -g2012 rtl/mips_cpu_bus_tb.v -o rtl/mips_cpu_bus_tb rtl/mips_cpu_bus.v rtl/mips_cpu_harvard.v rtl/mips_cpu_avl_slave_mem_2.v rtl/mips_cpu/*.v
./rtl/mips_cpu_bus_tb
rm rtl/mips_cpu_bus_tb
