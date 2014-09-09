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
    output [6:0] seg,
    output [3:0] anode,
	 output lock_led
    );
	 
	 wire clk_25m;
	 parameter in2 = 8'b11111111;
	 
	 
  dcm_10 clk_10
   (// Clock in ports
    .CLK_IN1(fpga_clk),      // IN
    // Clock out ports
    .CLK_OUT1(clk_25m),     // OUT
    // Status and control signals
    .RESET(reset),// IN
    .LOCKED(lock_led));      // OUT
	 
	 seven_seg s1 (.in({in2, sw}), .seg(seg), .anodes(anode), .clk(clk_25m));


endmodule
