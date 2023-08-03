/* CSED273 lab2 experiment 1 */
/* lab2_1.v */

/* Unsimplifed equation
 * You are allowed to use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
module lab2_1(
    output wire outGT, outEQ, outLT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    CAL_GT cal_gt(outGT, inA, inB);
    CAL_EQ cal_eq(outEQ, inA, inB);
    CAL_LT cal_lt(outLT, inA, inB);
    
endmodule

/* Implement output about "A>B" */
module CAL_GT(
    output wire outGT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );
    
    wire a1, a2, a3, a4, a5, a6;
    and(a1, ~inA[0], inA[1], ~inB[0], ~inB[1]);
    and(a2, inA[0], inA[1], ~inB[0], ~inB[1]);
    and(a3, inA[0], ~inA[1], ~inB[0], ~inB[1]);
    and(a4, inA[0], inA[1], ~inB[0], inB[1]);
    and(a5, inA[0], ~inA[1], ~inB[0], inB[1]);
    and(a6, inA[0], inA[1], inB[0], ~inB[1]);
    or(outGT, a1, a2, a3, a4, a5, a6);

endmodule

/* Implement output about "A=B" */
module CAL_EQ(
    output wire outEQ,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    wire a1, a2, a3, a4;
    and(a1, ~inA[0], ~inA[1], ~inB[0], ~inB[1]);
    and(a2, ~inA[0], inA[1], ~inB[0], inB[1]);
    and(a3, inA[0], inA[1], inB[0], inB[1]);
    and(a4, inA[0], ~inA[1], inB[0], ~inB[1]);
    or(outEQ, a1, a2, a3, a4);

endmodule

/* Implement output about "A<B" */
module CAL_LT(
    output wire outLT,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );

    wire a1, a2, a3, a4, a5, a6;
    and(a1, ~inA[0], ~inA[1], ~inB[0], inB[1]);
    and(a2, ~inA[0], ~inA[1], inB[0], inB[1]);
    and(a3, ~inA[0], ~inA[1], inB[0], ~inB[1]);
    and(a4, ~inA[0], inA[1], inB[0], inB[1]);
    and(a5, ~inA[0], inA[1], inB[0], ~inB[1]);
    and(a6, inA[0], ~inA[1], inB[0], inB[1]);
    or(outLT, a1, a2, a3, a4, a5, a6);

endmodule