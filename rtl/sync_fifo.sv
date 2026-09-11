`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2026 03:31:56 PM
// Design Name: 
// Module Name: sync_fifo
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


module sync_fifo (
    input  logic       clk,
    input  logic       rst,
    input  logic       wr_en,
    input  logic       rd_en,
    input  logic [7:0] data_in,

    output logic [7:0] data_out,
    output logic       full,
    output logic       empty
);

    logic [2:0] wr_ptr;
    logic [2:0] rd_ptr;
    logic [3:0] occupancy;
    logic [7:0] fifo [0:7];
    
    assign empty = (occupancy == 0);
    assign full  = (occupancy == 8);
    
    always_ff @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            occupancy <= 0;
            data_out <= 0;
        end
        
        else begin
            case({rd_en, wr_en})
            
                2'b00: begin
                       end
                       
                2'b01: begin
                     if(!full) begin
                         fifo[wr_ptr] <= data_in; 
                         wr_ptr <= wr_ptr + 1;
                         occupancy <= occupancy + 1;
                     end
                    end
                    
                 2'b10: begin
                      if(!empty) begin
                        data_out <= fifo[rd_ptr]; 
                         rd_ptr <= rd_ptr + 1;
                         occupancy <= occupancy - 1;
                     end
                    end
                  2'b11: begin
                       if (empty) begin
                             fifo[wr_ptr] <= data_in; 
                             wr_ptr <= wr_ptr + 1;
                             occupancy <= occupancy + 1;
                         end
                         else if(full) begin
                             data_out <= fifo[rd_ptr]; 
                             rd_ptr <= rd_ptr + 1;
                             occupancy <= occupancy - 1;
                         end
                         else begin
                             fifo[wr_ptr] <= data_in; 
                             wr_ptr <= wr_ptr + 1;
                             data_out <= fifo[rd_ptr]; 
                             rd_ptr <= rd_ptr + 1;
                         end
                    end  
              endcase
        end
    end
  endmodule
                  
                       
       /* else begin
             if(wr_en && rd_en) begin
                if (empty) begin
                     fifo[wr_ptr] <= data_in; 
                     wr_ptr <= wr_ptr + 1;
                     occupancy <= occupancy + 1;
                 end
                 else if(full) begin
                     data_out <= fifo[rd_ptr]; 
                     rd_ptr <= rd_ptr + 1;
                     occupancy <= occupancy - 1;
                 end
                 else begin
                     fifo[wr_ptr] <= data_in; 
                     wr_ptr <= wr_ptr + 1;
                     data_out <= fifo[rd_ptr]; 
                     rd_ptr <= rd_ptr + 1;
                 end
                                 
             end
        
             else if (wr_en) begin // wr_en using independant if statements to test all three conditions wr_en only. rd_en only and both wr_en && rd_ en
                if(!full) begin
                     fifo[wr_ptr] <= data_in; 
                     wr_ptr <= wr_ptr + 1;
                     occupancy <= occupancy + 1;
                 end
               
            end
            
            else if (rd_en) begin // read_en 
                if(!empty) begin
                    data_out <= fifo[rd_ptr]; 
                     rd_ptr <= rd_ptr + 1;
                     occupancy <= occupancy - 1;
                 end
                
            end
          end  */
   