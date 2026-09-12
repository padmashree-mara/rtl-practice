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
        write_n(4);
        read_n(4);       
              
        // case empty read rejection
        @(posedge clk);
        read_n(2);
        
        //case fill to full
        @(posedge clk);
        write_n(8);
        
        // case write while full
        @(posedge clk);
        write_n(2);
        
        //simultaneous read and write while full
        @(posedge clk);
        read_write_one($urandom());
        
        // case drain to empty
        read_n(7);
        
        //simultaneous read and write while empty
        @(posedge clk);
        read_write_one($urandom());

        // pointer wraparound
        @(posedge clk);
        write_n(8);
        
        @(posedge clk);
        read_n(2);
        
        @(posedge clk);
        write_n(3);
        
        @(posedge clk);
        read_n(3);
       
        
        // rst while partially filled
        @(posedge clk);
        rst <= 1;
        @(posedge clk);
        rst <= 0;
        @(posedge clk);
        write_n(5);
        
        @(posedge clk);
        read_n(4);

        
         //simultaneous read and write while partially filled
        @(posedge clk);
        read_write_one($urandom());
        
        @(posedge clk);
        write_n(2);
        
        repeat(5) @(posedge clk);
    
        $display("PASS: FIFO test completed");
        $finish;
       
    end
    
    task automatic write_one (input logic [7:0] data);
        wr_en <= 1;
        rd_en <= 0;
        data_in <= data;
        @(posedge clk);
        wr_en <= 0;
    endtask: write_one
    
    task automatic read_one ();
        wr_en <= 0;
        rd_en <= 1;
        @(posedge clk);
        rd_en <= 0;
    endtask: read_one
    
    task automatic read_write_one ( input logic [7:0] data );
        wr_en <= 1;
        rd_en <= 1;
        data_in <= data;
        @(posedge clk);
        rd_en <= 0;
        wr_en <= 0;
    endtask: read_write_one
    
    
    task automatic write_n(input int n);
        repeat(n) begin
            write_one($urandom());
        end
    endtask: write_n
    
    task automatic read_n(input int n);
        repeat(n) begin
            read_one();
        end
    endtask: read_n
    

    //*********************REFERENCE MODEL******************************
          
      logic [7:0] exp_fifo_q[$];
      logic [7:0] exp_data;
      logic exp_fifo_full;
      logic exp_fifo_empty;
      logic exp_rd_vld;
      logic exp_rd;
      logic exp_wr;

    always @ (posedge clk) begin 
        if (rst) begin
            exp_fifo_q.delete();
            exp_data        =0;
            exp_fifo_full   = 0;
            exp_fifo_empty  = 1;
            exp_rd_vld      = 0;
            exp_rd          = 0;
            exp_wr          = 0;
        end
      
        else begin
            exp_rd_vld = 0;
            exp_rd = rd_en && !exp_fifo_empty;
            exp_wr = wr_en && !exp_fifo_full;
            
            if (exp_rd)begin
               exp_data = exp_fifo_q.pop_front();
               exp_rd_vld = 1;
            end
            if (exp_wr) begin
                exp_fifo_q.push_back(data_in);
            end
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
