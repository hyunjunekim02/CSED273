/* CSED273 lab6 experiment 3 */
/* lab6_3.v */

`timescale 1ps / 1fs

/* Implement 369 game counter (0, 3, 6, 9, 13, 6, 9, 13, 6 ...)
 * You must first implement D flip-flop in lab6_ff.v
 * then you use D flip-flop of lab6_ff.v */
module counter_369(input reset_n, input clk, output [3:0] count);

    ////////////////////////
    wire Da, Db, Dc, Dd;
    wire [3:0] Q_;
    
    or(Da, count[3]&Q_[2], count[1]&Q_[0]);
    assign Db = count[0];
    or(Dc, Q_[3]&Q_[2], count[2]&count[0]);
    or(Dd, count[3]&Q_[2], Q_[0]);
    
    edge_trigger_D_FF d_A(reset_n, Da, clk, count[3], Q_[3]);
    edge_trigger_D_FF d_B(reset_n, Db, clk, count[2], Q_[2]);
    edge_trigger_D_FF d_C(reset_n, Dc, clk, count[1], Q_[1]);
    edge_trigger_D_FF d_D(reset_n, Dd, clk, count[0], Q_[0]);    
    ////////////////////////
	
endmodule
