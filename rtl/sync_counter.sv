`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2026 02:23:32 PM
// Design Name: 
// Module Name: sync_counter
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


module sync_counter(
    input logic clk, rst, en,
    output logic [7:0] count
    );
    
    always_ff @(posedge clk) begin
        if(rst) count <= 0;
        else begin
            if(en) begin
                count <= count + 1;
            end
        end
    end
    
endmodule: sync_counter


