/* CSED273 lab1 experiment 2_iii */
/* lab1_2_iii.v */


module lab1_2_iii(outAND, outOR, outNOT, inA, inB);
    output wire outAND, outOR, outNOT;
    input wire inA, inB;

    AND(outAND, inA, inB);
    OR(outOR, inA, inB);
    NOT(outNOT, inA);

endmodule


/* Implement AND, OR, and NOT modules with {NAND}
 * You are only allowed to wire modules below
 * i.e.) No and, or, not, etc. Only nand, AND, OR, NOT are available*/
module AND(outAND, inA, inB);
    output wire outAND;
    input wire inA, inB; 

    wire a;
    nand(a, inA, inB);
    nand(outAND, a, a);

endmodule

module OR(outOR, inA, inB);
    output wire outOR;
    input wire inA, inB; 
    
    wire a;
    wire b;
    nand(a, inA, inA);
    nand(b, inB, inB);
    nand(outOR, a, b);

endmodule

module NOT(outNOT, inA);
    output wire outNOT;
    input wire inA; 

    nand(outNOT, inA, inA);

endmodule