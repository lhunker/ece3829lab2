`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lukas Hunker, Brede Doerner
// 
// Create Date:    19:52:57 09/08/2014 
// Design Name: 
// Module Name:    seven_seg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module seven_seg(
    input [15:0] in,
	 input clk,
    output [6:0] seg,
    output [3:0] anodes
    );
	 
	 reg [1:0]mux;
	 reg [14:0] count = 0;
	 
	 //implement counter
	 always @(posedge clk)
	 begin
	 if(count == 9999)
		begin
		mux <= mux + 1'b1;
		count <= 0;
		end
	 else
		count <= count + 1'b1;
	 end

	//select input with mux (by setting anode)

	wire [3:0] display;
	assign anodes = (mux == 2'b00) ? 4'b1110 : 
		(mux == 2'b01) ? 4'b1101 :
		(mux == 2'b10) ? 4'b1011 :
		4'b0111;
		
	assign display = (mux == 2'b00) ? in[3:0] : 
		(mux == 2'b01) ? in[7:4] :
		(mux == 2'b10) ? in[11:8] :
		in[15:12];
		
	//convert input to 7 seg output

	assign seg = (display == 4'b0000) ? 7'b000001 :
		(display == 4'b0001) ? 7'b1001111 : 
		(display == 4'b0010) ? 7'b0010010 :
		(display == 4'b0011) ? 7'b0000110 : 	
		(display == 4'b0100) ? 7'b1001100 : 
		(display == 4'b0101) ? 7'b0100100 : 
		(display == 4'b0110) ? 7'b0100000 :
		(display == 4'b0111) ? 7'b0001111 :
		(display == 4'b1000) ? 7'b0000000 :
		(display == 4'b1001) ? 7'b0001100 : 	
		(display == 4'b1010) ? 7'b0001000 :
		(display == 4'b1011) ? 7'b1100000 :
		(display == 4'b1100) ? 7'b0110001 :
		(display == 4'b1101) ? 7'b1000010 :
		(display == 4'b1110) ? 7'b0110000 :
		7'b0111000;
	
endmodule

