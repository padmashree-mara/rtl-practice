`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/28/2026 03:43:02 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input a,b,cin,
    output s,c
    );
    
    wire t1, t2, t3;
    
    half_adder h1 (a , b, t1, t2);
    half_adder h2 (t1 , cin, s, t3);
    
    assign c = t2 | t3;
    
   
endmodule: full_adder
