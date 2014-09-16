`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:44:12 09/14/2014 
// Design Name: 
// Module Name:    vga_gen 
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
module vga_gen(
    input [10:0] hcount,
    input [10:0] vcount,
    input blank,
	 input [1:0] mux,
    output [7:0] rgb
    );

	//Color Definitions
	parameter white = 8'b 11111111;	//white
	parameter black = 8'b 00000000;	//black
	parameter blue = 8'b 00000011;	//blue
	
	
	//Generate Checkerboard
	wire [7:0] checker;	//the color output for the checkerboard
	reg col;	//the current column
	reg row; //the current row
	
	always @ (hcount, col)
		if(hcount < 80)
			col <= 1'b0;
		else if (hcount < 160)
			col <= 1'b1;
		else if (hcount < 240)
			col <= 1'b0;
		else if (hcount < 320)
			col <= 1'b1;
		else if (hcount < 400)
			col <= 1'b0;
		else if (hcount < 480)
			col <= 1'b1;
		else if (hcount < 560)
			col <= 1'b0;
		else
			col <= 1'b1;
	
	always @ (vcount, row)
		if (vcount < 60)
			row <= 1'b0;
		else if (vcount < 120)
			row <= 1'b1;
		else if (vcount < 180)
			row <= 1'b0;
		else if (vcount < 240)
			row <= 1'b1;
		else if (vcount < 300)
			row <= 1'b0;
		else if (vcount < 360)
			row <= 1'b1;	
		else if (vcount < 420)
			row <= 1'b0;
		else
			row <= 1'b1;

	assign checker = (blank) ? black :
		(col ^ row) ? white : black;
		
	//generate blue screen
	wire [7:0] allblue;
	assign allblue = (blank) ? black : blue;
	
	//generate white square
	wire [7:0] square;
	reg sqcolor;	//the current color for the square
	
	always @ (hcount, vcount, sqcolor)
		if (hcount >316 && hcount < 324 &&
			vcount > 232 && vcount < 248)
			sqcolor = 1'b1;
		else
			sqcolor = 1'b0;
			
	assign square = (blank) ?black :
		(sqcolor) ? white : black;
		
	//output selection
	assign rgb = (mux == 0) ? allblue :
		(mux == 1) ? checker : square;
		
endmodule
