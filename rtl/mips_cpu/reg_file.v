//`timescale 1ns/100ps

module register_file(
    input logic clk,
    input logic reset,
    input logic clk_enable,

    input logic[4:0]    read_reg1, read_reg2, 
    output logic[31:0]  read_data_a, read_data_b,
    output logic[31:0]  register_v0,

    input logic[4:0]    write_reg,
    input logic         write_enable,
    input logic[31:0]   write_data
);

    logic [31:0] reg_file[31:0];
    integer index;
    assign register_v0 = reg_file[2];
   
    always_comb begin //combinatorial
			read_data_a = reg_file[read_reg1];
			read_data_b = reg_file[read_reg2];
    end
	
	always @(posedge clk) begin
		if (clk_enable == 1) begin
			if (reset == 1) begin
				for (index=0; index<32; index=index+1) begin //use for loop to load the 0
					reg_file[index] <=0;
				end
			end
			else if (write_enable == 1 && write_reg != 0) begin
				reg_file[write_reg] <= write_data;
			end
		end
	end
	

endmodule

