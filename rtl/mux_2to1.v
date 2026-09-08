`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 03:07:46 PM
// Design Name: 
// Module Name: multiplexer
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


module mux_2to1(
    input a, b,sel,
    output  y
    );
// method 1    
 /*   reg temp;
    always @(*) begin
        if(sel) 
        temp = b;
        else 
        temp = a;
    end
    
    assign y = temp;*/
 
 // method 2
    
    assign y = sel? b : a;
    
endmodule: mux_2to1


