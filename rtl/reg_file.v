`timescale 1ns/100ps

module register_file(
    input logic clk,
    input logic reset,

    input logic[4:0]    read_reg1, read_reg2, 
    output logic[31:0]  read_data_a, read_data_b,

    input logic[4:0]    write_reg,
    input logic         write_enable,
    input logic[31:0]   write_data
);

    logic [32][31:0] reg_file;
	integer index;
   
    always_comb begin //combinatorial
			read_data_a = reg_file[read_reg1];
			read_data_b = reg_file[read_reg2];
    end
	
	always @(posedge clk) begin
		if (reset == 1) begin
			for (index=0; index<32; index=index+1) begin //use for loop to load the 0
                reg_file[index] <=0;
            end
		end
		else if (write_enable == 1) begin
			reg_file[write_reg] <= write_data;
		end
	end
	

endmodule


