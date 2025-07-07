`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2025 03:47:17
// Design Name: 
// Module Name: Tail_light
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


module Tail_light(
input clk,
input reset,
input left,
input right,
input haz,
output reg [5:0] light);

localparam[2:0] //state-assignment
Idle = 3'b000,
L1 = 3'b001,
L2 = 3'b011,
L3 = 3'b010,
R1 = 3'b101,
R2 = 3'b111,
R3 = 3'b110,
LR3 = 3'b100;

reg [2:0] p_state, next_state;

// Next state Logic
always @(*)begin

case(p_state)
Idle: if(haz || (left && right))
        next_state = LR3;
        else if(left && ~haz && ~right)
        next_state = L1;
        else if(right && ~haz && ~left)
        next_state = R1;
        else
        next_state = Idle;
        
L1: if(haz)
        next_state = LR3;
        else if(~haz)
        next_state = L2;
        else
        next_state = L1;
        
L2: if(haz)
        next_state = LR3;
        else if (~haz)
        next_state = L3;
        else
        next_state = L2;
L3: next_state = Idle;

R1: if(haz)
        next_state = LR3;
        else if(~haz)
        next_state = R2;
        else
        next_state = R1;
R2: if(haz)
        next_state = LR3;
        else if(~haz)
        next_state = R3;
        else
        next_state = R2;
R3: next_state = Idle;
default: 
        next_state = Idle;

endcase
end

// Present state logic
always@(posedge clk, posedge reset) 
begin
    if(reset)
        p_state <= Idle;
    else
        p_state <= next_state;
end


//Output Logic

always @(posedge clk)
begin
    if(p_state == Idle)
        light = 8'b000000;
    else if (p_state == L1)
        light = 8'b001000;
    else if (p_state == L2)
        light = 8'b011000;
    else if (p_state == L3)
        light = 8'b111000;
     else if (p_state == R1)
        light = 8'b000100;
     else if (p_state == R2)
        light = 8'b000110;
     else if (p_state == R3)
        light = 8'b000111;
     else if (p_state == LR3)
        light = 8'b111111;
        
end


endmodule
