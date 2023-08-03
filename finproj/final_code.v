`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/14 00:06:03
// Design Name: 
// Module Name: final_0614
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

///////////////////////////////////////////////////////////
// Negative Edge-triggered JK FF
module JKFF(
    input reset_n,
    input J,
    input K,
    input ck,
    output reg Q,
    output reg Q_
);
    initial begin
    Q = 0;
    Q_ = 1;
    end
    always@(negedge ck) begin
    Q <= reset_n & (J & ~Q | ~K & Q);
    Q_ <= (~reset_n | ~(J & ~Q | ~K & Q));
    end
endmodule
///////////////////////////////////////////////////////////
// T FF made with JK FF
module TFF(
    input reset_n,
    input T,
    input ck,
    output Q,
    output Q_
);
    JKFF TFFJKFF(reset_n, T, T, ck, Q, Q_);
endmodule
///////////////////////////////////////////////////////////
//switch reg
module SWITCH(
    input switch_in,
    output switch_out,
    output switch_out_
);
    TFF FF_switch(1, switch_in, ~switch_in, switch_out, switch_out_);
endmodule
///////////////////////////////////////////////////////////
// Register_GawiBawiBo: Default= 00, Rock=01, Scissor=10, Paper=11
module REGISTER_GBB(
    input EN,
    input R,
    input S,
    input P,
    input ck,
    input reset_n,
    output [1:0] gbb,
    output [1:0] gbb_
);
    wire reg1_J, reg1_K, reg0_J, reg0_K;
    assign reg1_J = EN & ((~R & S & ~P)|(~R & ~S & P));
    assign reg1_K = EN & (R & ~S & ~P);
    assign reg0_J = EN & ((R & ~S & ~P)|(~R & ~S & P));
    assign reg0_K = EN & (~R & S & ~P);
    JKFF reg1(reset_n, reg1_J, reg1_K, ck, gbb[1], gbb_[1]);
    JKFF reg0(reset_n, reg0_J, reg0_K, ck, gbb[0], gbb_[0]);    
endmodule
///////////////////////////////////////////////////////////
// Compare p1p2 and derive result
module COMPARE(
    input[1:0] p1,
    input[1:0] p2,
    output[1:0] result
);

    assign result[1] = ~p1[1] & p1[0] & p2[1] |
                       p1[1] & ~p1[0] & p2[0] |
                       p1[1] & p1[0] & (p2[1] & ~p2[0] | ~ p2[1] & p2[0]);
    assign result[0] = ~p1[1] & p1[0] & p2[0] |
                       p1[1] & ~p1[0] & (p2[1] & ~p2[0] | ~p2[1] & p2[0]) |
                       p1[1] & p1[0] & p2[1];

endmodule
///////////////////////////////////////////////////////////
// Count score
module COUNTER(
    input reset_n,
    input ck,
    input count,
    output count_plus
);

    wire Q, Q_;
    TFF tff(reset_n, count, ck, Q, Q_);
    assign count_plus = Q;
    
endmodule
// Finite State Machine
module FSM(
    input switch,
    input count_p1_in,
    input count_p2_in,
    input gbb_a,
    input gbb_b,
    input ck,
    output reset_gbb,
    output LED_winner_p1,
    output LED_winner_p2,
    output LED_p1,
    output LED_p2,
    output count_p1_out,
    output count_p2_out,
    output win_p1,
    output win_p2
);

    wire[2:0] state;
    wire[2:0] state_;
    wire ta, tb, tc;
    
// T FFs
        assign ta = switch &
                ((~state[2] & state[1] & switch & ~gbb_a & gbb_b) | 
                (state[2] & ~state[1] & ~state[0] & (~switch | (switch & ~count_p1_in))) | 
                (state[2] & ~state[1] & state[0] & (~switch | (switch & ~count_p2_in))) |
                state[2] & state[1] & ~switch);
    assign tb = switch &
                (~state[2] & ~state[1] & state[0] & switch & gbb_a |
                ~state[2] & state[1] & (~switch | switch & ~gbb_a & gbb_b) |
                state[2] & ~state[1] & switch & (~state[0] & count_p1_in | state[0] & count_p2_in) |
                state[2] & state[1] & ~switch);
    assign tc = switch &
                (~state[2] & ~state[1] & ~state[0] & switch |
                ~state[2] & state[0] & (~switch | switch & gbb_a & ~gbb_b) |
                ~state[2] & state[1] & ~state[0] & switch & gbb_a & gbb_b |
                state[2] & ~state[1] & ~state[0] & switch & ~count_p1_in | 
                state[2] & state[0] & ~switch);
    
    TFF TA(switch, ta, ck, state[2], state_[2]);
    TFF TB(switch, tb, ck, state[1], state_[1]);
    TFF TC(switch, tc, ck, state[0], state_[0]);

// Outputs
    assign LED_winner_p1 = (state[2] & state[1] & ~state[0] & switch);
    assign LED_winner_p2 = (state[2] & state[1] & state[0] & switch);
    assign count_p1_out = state[2] & ~state[1] & ~state[0] & ~(~gbb_a & gbb_b);
    assign count_p2_out = state[2] & ~state[1] & state[0] & ~(~gbb_a & gbb_b);
    assign reset_gbb = (~state[2] & ~state[1] & ~state[0] & switch) |
                       (~state[2] & switch) & ~(~state[1] & ~state[0]) & ~(~gbb_a & ~gbb_b) | 
                       (state[2] & ~state[1]);
                       
    assign LED_p1 = (switch & count_p1_in) & ~(state[2] & state[1] & state[0]);
    assign LED_p2 = (switch & count_p2_in) & ~(state[2] & state[1] & ~state[0]);
    
endmodule
///////////////////////////////////////////////////////////
// MukJjiBba game
module MJB(
    input switch,
    input ck,
    input R1,
    input S1,
    input P1,
    input R2,
    input S2,
    input P2,
    output LED_winner_p1,
    output LED_winner_p2,
    output LED_p1,
    output LED_p2,
    output win_led_p1,
    output win_led_p2,
    output button_led
);

    wire[1:0] p1;
    wire[1:0] p1_;
    wire[1:0] p2;
    wire[1:0] p2_;
    wire[1:0] gbbab;
    wire count_p1_in, count_p1_out, count_p2_in, count_p2_out;
    wire button, button_;
    wire re_gbb;
    
    wire win_p1, win_p2;
    
    assign win_led_p1 = win_p1;
    assign win_led_p2 = win_p2;
    assign button_led = button;
    
    SWITCH button_input(switch, button, button_);
    REGISTER_GBB player1(button, ~R1, ~S1, ~P1, ck, ~re_gbb, {p1[1], p1[0]}, {p1_[1], p1_[0]});
    REGISTER_GBB player2(button, ~R2, ~S2, ~P2, ck, ~re_gbb, {p2[1], p2[0]}, {p2_[1], p2_[0]});
    COMPARE cmp({p1[1], p1[0]}, {p2[1], p2[0]}, {gbbab[1], gbbab[0]});
    COUNTER counter_p1(button, ck, count_p1_in, count_p1_out);
    COUNTER counter_p2(button, ck, count_p2_in, count_p2_out);
    FSM mukjjibba(button, count_p1_out, count_p2_out, gbbab[1], gbbab[0], ck, re_gbb, LED_winner_p1, LED_winner_p2, LED_p1, LED_p2, count_p1_in, count_p2_in, win_p1, win_p2);
   
endmodule