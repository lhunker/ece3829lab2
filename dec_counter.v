`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brede Doerner and Lukas Hunker
// 
// Create Date:    12:22:34 09/18/2014 
// Design Name: 
// Module Name:    dec_counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: BCD counter
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dec_counter(
    input clk,
    input reset,
    output reg [7:0] out
    );

	reg [20:0] count;
	
	always @ (posedge clk)	//generate 10Hz clock enable to regulate the rate of the counter
	begin
		if(count == 999999)
			count <= 0;
		else
			count <= count + 1;
	end
	
	wire clk_en;
	assign clk_en = (count == 0);
	
	always @(posedge clk, posedge reset)
	begin
		if(reset)	//asynchronous reset
			out <= 0;
		else if(clk_en)
			if(out[3:0] == 9)	//carry from lower digit to upper digit
			begin
				if(out[7:4] == 9)	//reset to 0 after the count reaches 99
					out <= 0;
				else
				begin
					out[7:4] <= out[7:4] + 1;	//reset lower digit to 0
					out[3:0] <= 0;
				end
			end
			else
				out[3:0] <= out[3:0] + 1;	//if the lower digit is not 9 then increment it
	end

endmodule
