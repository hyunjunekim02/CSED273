/* CSED273 lab2 experiment 2 */
/* lab2_2.v */

/* Simplifed equation by K-Map method
 * You are allowed to use keword "assign" and operator "&","|","~",
 * or just implement with gate-level-modeling (and, or, not) */
module lab2_2(
    output wire outGT, outEQ, outLT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );

    CAL_GT_2 cal_gt2(outGT, inA, inB);
    CAL_EQ_2 cal_eq2(outEQ, inA, inB);
    CAL_LT_2 cal_lt2(outLT, inA, inB);

endmodule

/* Implement output about "A>B" */
module CAL_GT_2(
    output wire outGT,
    input wire [1:0] inA,
    input wire [1:0] inB
    );
    
    wire a1, a2, a3;
    and(a1, inA[0], ~inB[0]);
    and(a2, inA[1], ~inB[0], ~inB[1]);
    and(a3, inA[0], inA[1], ~inB[1]);
    or(outGT, a1, a2, a3);
    
endmodule

/* Implement output about "A=B" */
module CAL_EQ_2(
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
module CAL_LT_2(
    output wire outLT,
    input wire [1:0] inA, 
    input wire [1:0] inB
    );
    
    wire a1, a2, a3;
    and(a1, ~inA[0], inB[0]);
    and(a2, ~inA[0], ~inA[1], inB[1]);
    and(a3, ~inA[1], inB[0], inB[1]);
    or(outLT, a1, a2, a3);

endmodule