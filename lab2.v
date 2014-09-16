`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:27:43 09/08/2014 
// Design Name: 
// Module Name:    lab2 
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
module lab2(
    input [7:0] sw,
	 input fpga_clk,
	 input reset,
    //output [6:0] seg,
    //output [3:0] anode,
	 output HS,
	 output VS,

	 output [2:0] red,
	 output [2:0] grn,
	 output [1:0] blu,
	 output blank,
	 output lock_led
    );
	 
	 wire clk_25m;
	 /*assign red =  blank ? 3'b0 : sw[2:0];
	 assign grn = blank ? 3'b0 : sw[5:3];
	 assign blu = blank ? 2'b00 : sw[7:6];*/
	 
  dcm_25 clk_25
   (// Clock in ports
    .CLK_IN1(fpga_clk),      // IN
    // Clock out ports
    .CLK_OUT1(clk_25m),     // OUT
    // Status and control signals
    .RESET(reset),// IN
    .LOCKED(lock_led));      // OUT
	 
	 wire [10:0] hcount;
	 wire [10:0] vcount;
	 wire [7:0] rgb;
	 //seven_seg s1 (.in({in2, sw}), .seg(seg), .anodes(anode), .clk(clk_25m));
	 vga_controller_640_60 vga1 (.rst(reset), .pixel_clk(clk_25m), .HS(HS), .VS(VS), .hcount(hcount), .vcount(vcount), .blank(blank));
	 vga_gen gen1 (.hcount(hcount), .vcount(vcount), .blank(blank), .rgb(rgb), .mux (sw[1:0]));
	 
	 assign red = rgb[7:5];
	 assign grn = rgb[4:2];
	 assign blu = rgb[1:0];


endmodule
