`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2026 02:21:40 PM
// Design Name: 
// Module Name: transaction_controller_tb
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


module transaction_controller_tb;

 logic clk, rst, start, work_done;
 logic busy, done_pulse;
 
 typedef enum logic[1:0]{
    EXP_IDLE,
    EXP_BUSY,
    EXP_DONE
    } exp_state_t;
    
    exp_state_t expected_state;
 
 transaction_controller dut (.clk(clk), .rst(rst), .start(start), .work_done(work_done), .busy(busy), .done_pulse(done_pulse));
 
 always begin // clk gen
    #5 clk = ~clk;
 end
 
 initial begin 
    clk = 0;
    start = 0;
    work_done = 0;
    rst = 1;
    repeat(2)@(posedge clk);
    rst <= 0;
     // initializing
   
    
    @(posedge clk);
    start <= 1;
      
    repeat(5)@(posedge clk);
    start <= 0;
    work_done <= 1;
    
    @(posedge clk);
    work_done <= 0;
    
    @(posedge clk);
    work_done <= 1;  // pulsing work_done when in idle state
     @(posedge clk);
    work_done <= 0;
    
    repeat(2) @(posedge clk);
    start <= 1;
    
    repeat(2) @(posedge clk);
    start <= 0;
    
    repeat(2) @(posedge clk);// pulsing start when in busy state
    start <= 1;
    @(posedge clk);
      start <= 0;
     
    repeat(2)@(posedge clk);
    rst <= 1;
    
    repeat(5) @(posedge clk);
    
    $display("PASS: transaction_controller test completed");
    $finish;
 end
 
 always @(posedge clk) begin
    if (rst) expected_state = EXP_IDLE;
    else begin
        case (expected_state)
            EXP_IDLE: if(start) expected_state = EXP_BUSY;
                      else expected_state = EXP_IDLE;
            EXP_BUSY: if( work_done) expected_state = EXP_DONE;
                      else expected_state = EXP_BUSY;
            EXP_DONE: expected_state = EXP_IDLE;
            default: expected_state = EXP_IDLE;
        endcase
    end
 end
    
    
 always @(negedge clk) begin
       
      case (expected_state)
            EXP_IDLE: if({busy,done_pulse}!== 2'b00) 
                      $fatal( " Error; invalid busy or done_pulse when Expected state is %s - Busy = %d, done_pulse = %d", expected_state, busy, done_pulse);
            EXP_BUSY: if({busy,done_pulse}!== 2'b10) 
                      $fatal( " Error; invalid busy or done_pulse when Expected state is %s - Busy = %d, done_pulse = %d", expected_state, busy, done_pulse);
            EXP_DONE: if({busy,done_pulse}!== 2'b01) 
                      $fatal( " Error; invalid busy or done_pulse when Expected state is %s - Busy = %d, done_pulse = %d", expected_state, busy, done_pulse);
        endcase
    end
    
endmodule
