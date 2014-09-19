`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brede Doerner and Lukas Hunker
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
    input [1:0] sw,
	 input fpga_clk,
	 input reset,
	 input debug,
    output [6:0] seg,
    output [3:0] anode,
	 output HS,
	 output VS,

	 output [2:0] red,
	 output [2:0] grn,
	 output [1:0] blu,
	 
	 output dac_clock,
	 output dac_sdata,
	 output dac_sync
    );
	 
	 wire clk_25m;	//25 MHz clock
	 wire clk_10m;	//10 MHz clock
	 
	 wire blank;	//vblank signal
	 
	 
	 //dcm to generate necessary clocks
	dcm_25_10 instance_name
   (// Clock in ports
    .CLK_IN1(fpga_clk),      // IN
    // Clock out ports
    .CLK_OUT1(clk_25m),     // 25 MHz clock
    .CLK_OUT2(clk_10m),     // 10 MHz clock
    // Status and control signals
    .RESET(reset));
	 
	 //ODDR2 to forward 10MHz clock to the DAC
	 ODDR2 #(
	 .DDR_ALIGNMENT("NONE"),
	 .INIT(1'b0),
	 .SRTYPE("SYNC")
	 )
	 clock_forward (
	 .Q(dac_clock),
	 .C0(~clk_10m),
	 .C1(clk_10m),
	 .CE(1'b1),
	 .D0(1'b0),
	 .D1(1'b1),
	 .R(1'b0),
	 .S(1'b0));
	 
	 //wires for dac interface
	 wire [7:0] dac_control;
	 wire [7:0] dac_data;
	 wire dac_begin;
	 
	 //set dac control signals
	 assign dac_control = 8'b0000_0000;
	 
	 //instantiating the dac driver
	 dac_driver dac_drive(
		.clk(clk_10m),
		.dac_data(dac_data),
		.dac_control(dac_control),
		.dac_sout(dac_sdata),
		.dac_begin(dac_begin),
		.dac_sync(dac_sync));
		
	//instantiating waveform generator
	dac_counter countdac(
		.clk(clk_10m),
		.debug(debug),
		.dac_begin(dac_begin),
		.dac_data(dac_data));
	 
	 wire [10:0] hcount;
	 wire [10:0] vcount;
	 wire [7:0] rgb;
	 
	 // 2 digit decimal counter to drive 2 digits of the seven segment display
	 // 8 bit wire needed to connected dec_counter to the 7-segment display module
	 wire [7:0] counter_dec;
	 
	 //instantiate dec_counter to run off of the 10 MHz clock (divided internally to 10 Hz using a clock enable
	 dec_counter dec_count(
		.clk(clk_10m),
		.reset(reset),
		.out(counter_dec));
	 
	 //instantiate seven segment display
	 seven_seg s1 (.in({counter_dec, dac_data}), .seg(seg), .anodes(anode), .clk(clk_25m));
	 
	 //instantiate vga controller to generate timeing and sync signals
	 vga_controller_640_60 vga1 (.rst(reset), .pixel_clk(clk_25m), .HS(HS), .VS(VS), .hcount(hcount), .vcount(vcount), .blank(blank));
	 //generate patterns for vga controller
	 vga_gen gen1 (.hcount(hcount), .vcount(vcount), .blank(blank), .rgb(rgb), .mux (sw));
	 
	 //assign rgb outputs
	 assign red = rgb[7:5];
	 assign grn = rgb[4:2];
	 assign blu = rgb[1:0];


endmodule
