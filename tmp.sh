#!/bin/bash
iverilog -Wall -g 2012 rtl/mips_cpu_harvard_tb.v -o rtl/mips_cpu_harvard_tb_addiu rtl/mips_cpu_harvard.v rtl/mem_harvard.v rtl/mips_cpu/*.v
./rtl/mips_cpu_harvard_tb_addiu
rm rtl/mips_cpu_harvard_tb_addiu
