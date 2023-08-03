/* CSED273 lab6 experiment 1 */
/* lab6_1.v */

`timescale 1ps / 1fs

/* Implement synchronous BCD decade counter (0-9)
 * You must use JK flip-flop of lab6_ff.v */
module decade_counter(input reset_n, input clk, output [3:0] count);

    ////////////////////////
    wire Ja, Ka;
    wire Jb, Kb;
    wire Jc, Kc;
    wire Jd, Kd;
    wire [3:0] Q_;
    
    and(Ja, count[2], count[1], count[0]);
    assign Ka = count[0];
    
    and(Jb, count[1], count[0]);
    and(Kb, count[1], count[0]);
    
    and(Jc, Q_[3], count[0]);
    assign Kc = count[0];
    
    assign Jd = 1;
    assign Kd = 1;
    
    edge_trigger_JKFF D(reset_n, Jd, Kd, clk, count[0], Q_[0]);
    edge_trigger_JKFF C(reset_n, Jc, Kc, clk, count[1], Q_[1]);
    edge_trigger_JKFF B(reset_n, Jb, Kb, clk, count[2], Q_[2]);
    edge_trigger_JKFF A(reset_n, Ja, Ka, clk, count[3], Q_[3]);
    ////////////////////////
	
endmodule