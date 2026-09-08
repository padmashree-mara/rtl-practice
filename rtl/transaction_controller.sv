`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2026 03:22:31 PM
// Design Name: 
// Module Name: transaction_controller
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


module transaction_controller(
    input logic clk, rst, start, work_done,
    output logic busy, done_pulse
    );
    
    typedef enum logic [1:0] {IDLE, BUSY, DONE} state_t;
    
    state_t current_state, next_state; 
    
    
     
    always_comb begin    
        next_state = current_state;
        case (current_state)        
            IDLE: 
                    if (start) begin
                        next_state = BUSY;
                    end
                    
            BUSY: 
               
                    if(work_done) begin
                        next_state = DONE;
                    end
                  
                
            DONE: 
                    next_state = IDLE;
                
                
            default: 
                    next_state = IDLE;
        endcase
    end
    
    always_comb begin
        busy = 0;
        done_pulse = 0;
        
         if( current_state == BUSY)begin
            busy = 1;
            done_pulse = 0;
        end
        
         else if( current_state == DONE)begin
          busy = 0;
          done_pulse = 1;
        end
    end
    
    always_ff @(posedge clk) begin
        if(rst)
            current_state <= IDLE;
        else 
        current_state <= next_state;
    end
    
    
endmodule
