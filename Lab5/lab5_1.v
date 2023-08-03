/* CSED273 lab5 experiment 1 */
/* lab5_1.v */

`timescale 1ps / 1fs

/* Implement adder 
 * You must not use Verilog arithmetic operators */
module adder(
    input [3:0] x,
    input [3:0] y,
    input c_in,             // Carry in
    output [3:0] out,
    output c_out            // Carry out
); 

    ////////////////////////
    
    wire a0, a1, a2;
    xor(out[0], x[0], y[0], c_in);
    or(a0, x[0]&y[0], y[0]&c_in, x[0]&c_in);
    
    xor(out[1], x[1], y[1], a0);
    or(a1, x[1]&y[1], y[1]&a0, x[1]&a0);
    
    xor(out[2], x[2], y[2], a1);
    or(a2, x[2]&y[2], y[2]&a1, x[2]&a1);
    
    xor(out[3], x[3], y[3], a2);
    or(c_out, x[3]&y[3], y[3]&a2, x[3]&a2);
    
    ////////////////////////

endmodule

/* Implement arithmeticUnit with adder module
 * You must use one adder module.
 * You must not use Verilog arithmetic operators */
module arithmeticUnit(
    input [3:0] x,
    input [3:0] y,
    input [2:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    ////////////////////////
    
    wire b0, b1, b2, b3;
    or(b0, select[1]&y[0], select[2]&(~y[0]));
    or(b1, select[1]&y[1], select[2]&(~y[1]));
    or(b2, select[1]&y[2], select[2]&(~y[2]));
    or(b3, select[1]&y[3], select[2]&(~y[3]));
    adder ADD({b3, b2, b1, b0}, {x[3], x[2], x[1], x[0]}, select[0], {out[3], out[2], out[1], out[0]}, c_out);
    
    ////////////////////////

endmodule

/* Implement 4:1 mux */
module mux4to1(
    input [3:0] in,
    input [1:0] select,
    output out
);

    ////////////////////////
    
    wire c0, c1, c2, c3;
    and(c0, in[0], ~select[0], ~select[1]);
    and(c1, in[1], select[0], ~select[1]);
    and(c2, in[2], ~select[0], select[1]);
    and(c3, in[3], select[0], select[1]);
    or(out, c0, c1, c2, c3);
    
    ////////////////////////

endmodule

/* Implement logicUnit with mux4to1 */
module logicUnit(
    input [3:0] x,
    input [3:0] y,
    input [1:0] select,
    output [3:0] out
);

    ////////////////////////
    
    mux4to1 muxA({~x[0], x[0]^y[0], x[0]|y[0], x[0]&y[0]}, {select[1], select[0]}, out[0]);
    mux4to1 muxB({~x[1], x[1]^y[1], x[1]|y[1], x[1]&y[1]}, {select[1], select[0]}, out[1]);
    mux4to1 muxC({~x[2], x[2]^y[2], x[2]|y[2], x[2]&y[2]}, {select[1], select[0]}, out[2]);
    mux4to1 muxD({~x[3], x[3]^y[3], x[3]|y[3], x[3]&y[3]}, {select[1], select[0]}, out[3]);
    
    ////////////////////////

endmodule

/* Implement 2:1 mux */
module mux2to1(
    input [1:0] in,
    input  select,
    output out
);

    ////////////////////////
    
    wire d0, d1;
    and(d0, ~select, in[0]);
    and(d1, select, in[1]);
    or(out, d0, d1);
    
    ////////////////////////

endmodule

/* Implement ALU with mux2to1 */
module lab5_1(
    input [3:0] x,
    input [3:0] y,
    input [3:0] select,
    output [3:0] out,
    output c_out            // Carry out
);

    ////////////////////////
    
    wire [3:0] e;
    wire [3:0] f;
    
    arithmeticUnit A({x[3],x[2],x[1],x[0]},{y[3],y[2],y[1],y[0]},{select[2],select[1],select[0]},{e[3],e[2],e[1],e[0]},c_out);
    logicUnit L({x[3],x[2],x[1],x[0]},{y[3],y[2],y[1],y[0]},{select[1],select[0]},{f[3],f[2],f[1],f[0]});
    mux2to1 M1({f[3],e[3]},select[3],out[3]);
    mux2to1 M2({f[2],e[2]},select[3],out[2]);
    mux2to1 M3({f[1],e[1]},select[3],out[1]);
    mux2to1 M4({f[0],e[0]},select[3],out[0]);
    
    ////////////////////////

endmodule
