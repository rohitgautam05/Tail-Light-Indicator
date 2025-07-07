`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2025 03:50:57
// Design Name: 
// Module Name: tail_light_tb
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


module tail_light_tb();
reg clk,rst,left,right,haz;
wire [5:0]light;

// Instamtiation of design under test
Tail_light dut(.clk(clk),.reset(rst),.left(left),.right(right),.haz(haz),.light(light));

// Clock generator and reset signal
initial 
begin   
    clk = 0;
    rst = 1;
    #10 rst = 0;
    
    forever #5 clk = ~clk;
    
end

// Stimulus block 
initial begin
    @(negedge rst);
    
    test_hazard();
    test_left();
    test_right();
    
    repeat (100) drive_random();
    $display("Simulation finished");
    $finish;
    
end

// Output monitor
always@(posedge clk)
    $display ("t=%0t L=%b H=%b state=%0d light=%08b", $time,left,right,haz,dut.p_state,light);
    
// Reusable tasks

task test_hazard;
    begin 
        haz =1; left=1; right=1;
        repeat (2) @(posedge clk);
        haz = 0; left = 0; right = 0;
        @(posedge clk);
     end
endtask

task test_left;
    begin
        left =1; right = 0; haz = 0;
        repeat (3) @(posedge clk);
        left = 0;
        @(posedge clk);
     end
endtask 

task test_right;
    begin
        right =1; left =0; haz =0;
        repeat (3) @(posedge clk);
        right = 0;
        @(posedge clk);
    end
endtask

task drive_random;
    begin 
        haz = $urandom_range(0,1);
        left = haz?1'b1: $urandom_range(0,1);
        right = haz? 1'b1: $urandom_range(0,1);
        @(posedge clk);
     end
endtask
       

endmodule
