`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brede Doerner and Lukas Hunker
// 
// Create Date:    12:00:31 09/18/2014 
// Design Name: 
// Module Name:    dac_counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Trigger the DAC driver and generate a waveform for it 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dac_counter(
    input clk,
	 input debug,
    output dac_begin,
    output [7:0] dac_data
    );
	 
	 
	 //parameter array to create sine wave
	 parameter [7:0] sine [15:0] = {
		8'd128,
		8'd177,
		8'd218,
		8'd246,
		8'd255,
		8'd246,
		8'd218,
		8'd177,
		8'd128,
		8'd79,
		8'd37,
		8'd10,
		8'd0,
		8'd10,
		8'd37,
		8'd79};
		
	 wire count_en;
	 reg [20:0] count1;
	 
	 wire [20:0] tc;
	 
	 assign tc = (debug) ? 999999:99;	//debug mode updates the DAC at a rate of 10 Hz rather than 100 KHz
	 
	 always @ (posedge clk)	//counter to regulate the rate at which the DAC is updated
			if(count1 == tc)
				count1 <= 0;
			else
				count1 <= count1 + 1;
	 
	 assign count_en = (count1 == tc);	
	 assign dac_begin = (count1 == tc);
	 
	 reg [3:0] table_count;
	 
	 always @ (posedge clk)	//counter to cycle through the lookup table to generate a sine wave
		if(count_en)
		begin
			if(table_count == 15)
				table_count <= 0;
			else
				table_count <= table_count + 1;
		end
		
		assign dac_data = sine[table_count];	//select value from the constant lookup table


endmodule
