`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2026 02:07:57 PM
// Design Name: 
// Module Name: sync_counter_tb
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


module sync_counter_tb;
     logic [7:0]count;
     logic clk, en, rst;
   
    logic [7:0]prev_count;
    
    sync_counter dut(
    .clk (clk),
    .rst (rst),
    .en (en),
    .count (count)
    );
    
    
    
    always begin // clk generation
        #5 clk = ~ clk; 
    end
    
    initial begin // initialization
        clk = 0;
        en = 0;
        rst = 1;
        prev_count = count;
        @(negedge clk);
        #3;

         rst = 0;

        en = 1; // rst = 0 en = 1
        
        #10;
        
        rst = 1; // rst = 1 en = 1
        
        #10;
        
         rst = 0; // rst = 0 en = 1
        
        #10;
        
        en = 0;  // rst = 0 en = 0
        
        #10; 
        
        en =1;   // rst = 0 en = 1  
        
        wait( count == 8'hff); // waits till the counter hits 8'hff for the first time
        
      //  repeat(256) @(posedge clk); // waits till the counter hits 8'hff for the second time
        @(posedge clk);
        @(negedge clk);
        $display("Overflow scenario exercised");

        #1;
        $display("Pass: Sync counter test completed");
        
        $finish;
    end
    
    
    
    always @(negedge clk) begin 
    
       if (rst) begin
            if (count != 0)begin
                $fatal("Error!, rst not asserted"); // reset error
            end
       end
       else if(en) begin
            if(count != prev_count+ 8'd1 ) begin // normal count operation 
                $fatal("Error!, Counting error - counting failing when en asserted");
            end
       end
       else if(count != prev_count) begin  // hold
            $fatal("Error!, faulty enable - counting continues when deasserted");
       end
            
        prev_count = count ; 
       
    end
    
endmodule
