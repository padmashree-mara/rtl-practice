`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2026 02:07:01 PM
// Design Name: 
// Module Name: sync_fifo_tb
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


module sync_fifo_tb;
    logic       clk;
    logic       rst;
    logic       wr_en;
    logic       rd_en;
    logic [7:0] data_in;
    
    logic [7:0] data_out;
    logic       full;
    logic       empty;
    
   //***********************DUT INSTANTIATION***************************          
    
    sync_fifo dut(.clk(clk),
              .rst(rst),
              .wr_en(wr_en),
              .rd_en(rd_en),
              .data_in(data_in),
              .data_out(data_out),
              .full(full),
              .empty(empty));
              
    //***********************CLK GENERATION***************************          
              
    always #5 clk = ~clk;
    
    //*********************STIMULUS BLOCK******************************
       
    initial begin 
        clk     = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 0;
        rst     = 1;
        @(posedge clk);
        rst <= 0;
        @(posedge clk);

       // case normal operation 
        wr_en <= 1;
        do_write(4);
        wr_en <= 0;
        
        @(posedge clk);
        rd_en <= 1;
        repeat(4)
        @(posedge clk);
        rd_en <= 0;
        
        // case empty read rejection
        @(posedge clk);
        rd_en <= 1;
        repeat(2)
        @(posedge clk);
        rd_en <= 0;
        
        //case fill to full
        @(posedge clk);
        wr_en <= 1;
        do_write(8);
        wr_en <= 0;
        
        // case write while full
        @(posedge clk);
        wr_en <= 1;
        do_write(2);
        wr_en <= 0;
        
        //simultaneous read and write while full
        @(posedge clk);
        rd_en <= 1;
        wr_en <= 1;
        do_write(1);
        rd_en <= 0;
        wr_en <= 0;
        
        // case drain to empty
        @(posedge clk);
        rd_en <= 1;
        repeat(7)
        @(posedge clk);
        rd_en <= 0;
        
        //simultaneous read and write while empty
        @(posedge clk);
        rd_en <= 1;
        wr_en <= 1;
        do_write(1);
        rd_en <= 0;
        wr_en <= 0;
        
        // pointer wraparound
        @(posedge clk);
        wr_en <= 1;
        do_write(8);
        wr_en <= 0;
        
        @(posedge clk);
        rd_en <= 1;
        repeat(4)
        @(posedge clk);
        rd_en <= 0;
        
        @(posedge clk);
        wr_en <= 1;
        do_write(3); 
        wr_en <= 0;
        
        @(posedge clk);
        rd_en <= 1;
        repeat(6) 
        @(posedge clk);
        rd_en <= 0;
        
        // rst while partially filled
        @(posedge clk);
        rst <= 1;
        @(posedge clk);
        rst <= 0;
        @(posedge clk);
        wr_en <= 1;
        do_write(5);  
        wr_en <= 0;
        
        @(posedge clk);
        rd_en <= 1;
        repeat(4)  
        @(posedge clk);
        rd_en <= 0;
        
         //simultaneous read and write while partially filled
        @(posedge clk);
        rd_en <= 1;
        wr_en <= 1;
        do_write(1);
        rd_en <= 0;
        wr_en <= 0;
        
        @(posedge clk);
        wr_en <= 1;
        do_write(2);  
        wr_en <= 0;
        
        
        
        
        repeat(5) @(posedge clk);
    
        $display("PASS: FIFO test completed");
        $finish;
            
       
    end
    
    task automatic do_write (input int n);
        repeat (n) begin
            data_in <= $urandom();
            @(posedge clk);
        end
    endtask: do_write
    

    //*********************REFERENCE MODEL******************************
          
      logic [7:0] exp_fifo_q[$];
      logic [7:0] exp_data;
      logic exp_fifo_full;
      logic exp_fifo_empty;
      logic exp_rd_vld;

    always @ (posedge clk) begin 
        if (rst) begin
            exp_fifo_q.delete();
            exp_data =0;
            exp_fifo_full = 0;
            exp_fifo_empty = 1;
            exp_rd_vld = 0;
            
        end
      
        else begin 
            exp_rd_vld = 0;
            case ({rd_en, wr_en})
                2'b00:  begin
                        end
                2'b01:  begin
                            if(!exp_fifo_full) begin
                                exp_fifo_q.push_back(data_in);
                            end
                        end
                2'b10:  begin
                            if(!exp_fifo_empty) begin
                                exp_data = exp_fifo_q.pop_front();
                                exp_rd_vld = 1;
                            end
                        end
                2'b11:  begin
                            if(!exp_fifo_empty) begin
                                exp_data = exp_fifo_q.pop_front();
                                exp_rd_vld = 1;
                            end
                            if(!exp_fifo_full) begin
                                exp_fifo_q.push_back(data_in);
                            end
                        end
            endcase
        end
        
        exp_fifo_full = (exp_fifo_q.size() == 8)? 1 : 0;  
        exp_fifo_empty = (exp_fifo_q.size() == 0)? 1 : 0;  
    
    end
    
   //*********************CHECKER******************************

    
    always@(negedge clk) begin 
        if(exp_rd_vld == 1) begin
            if(data_out !== exp_data)begin
                $fatal(1,"ERROR! Data mismatch exp_data = %b; actual data = %b", exp_data, data_out);
            end
        end
        
        if (full !== exp_fifo_full) begin
            $fatal(1,"ERROR! fifo state mismatch! Dut state full : %d Ref state full : %d", full, exp_fifo_full); 
        end
         if (empty !== exp_fifo_empty) begin
            $fatal(1,"ERROR! fifo state mismatch! Dut state empty : %d Ref state empty : %d", empty, exp_fifo_empty); 
        end
    end
    
    
    
endmodule
