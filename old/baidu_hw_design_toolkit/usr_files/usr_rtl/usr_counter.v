`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2017 02:31:02 PM
// Design Name: 
// Module Name: usr_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module usr_counter(
    input usr_clk,
    output reg [3:0] o_count = 0
    );
    always@(posedge usr_clk)
        o_count <= o_count + 'd1;
endmodule
