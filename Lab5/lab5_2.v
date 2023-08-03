/* CSED273 lab5 experiment 2 */
/* lab5_2.v */

`timescale 1ns / 1ps

/* Implement srLatch */
module srLatch(
    input s, r,
    output q, q_
    );

    ////////////////////////
    
    nor(q, r, q_);
    nor(q_, s, q);
    
    ////////////////////////

endmodule

/* Implement master-slave JK flip-flop with srLatch module */
module lab5_2(
    input reset_n, j, k, clk,
    output q, q_
    );

    ////////////////////////
    
    wire J1, K1, J2, K2, J3, K3, p, p_;
    
    and(J1, q, k, clk);
    and(K1, q_, j, clk);
    or(J2, ~reset_n, J1);
    and(K2, reset_n, K1);
    srLatch master(K2, J2, p, p_);
    and(J3, p_, ~clk);
    and(K3, p, ~clk);
    srLatch slave(K3, J3, q, q_);
    
    ////////////////////////
    
endmodule