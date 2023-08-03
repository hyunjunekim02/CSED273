/* CSED273 lab6 experiments */
/* lab6_tb.v */

`timescale 1ps / 1fs

module lab6_tb();

    integer Passed;
    integer Failed;

    /* Define input, output and instantiate module */
    ////////////////////////
    reg reset1, clock1;
    reg reset2, clock2;
    reg reset3, clock3;
    wire [3:0] count1;
    wire [7:0] count2;
    wire [3:0] count3;
    
    decade_counter COUNTER1(
        .reset_n(reset1),
        .clk(clock1),
        .count(count1)
    );
    
    decade_counter_2digits COUNTER2(
        .reset_n(reset2),
        .clk(clock2),
        .count(count2)
    );
    
    counter_369 COUNTER3(
        .reset_n(reset3),
        .clk(clock3),
        .count(count3)
    );
    ////////////////////////

    initial begin
        Passed = 0;
        Failed = 0;

        lab6_1_test;
        lab6_2_test;
        lab6_3_test;

        $display("Lab6 Passed = %0d, Failed = %0d", Passed, Failed);
        $finish;
    end

    /* Implement test task for lab6_1 */
    task lab6_1_test;
        ////////////////////////
        integer i;
        reg [3:0] count_expected1;
        begin
            $display("lab6_1_test");
            count_expected1 = 4'h0;
            
            clock1 = 1'b1;
            reset1 = 1'b0;
            clock2 = 1'b1;
            reset2 = 1'b0;
            clock3 = 1'b1;
            reset3 = 1'b0;
            
            #2 clock1 = 1'b0;
            #2 clock1 = 1'b1;
            reset1 = 1'b1;
            
            for(i=0; i<20; i=i+1) begin
                count_expected1 = count_expected1+1;
                if(count_expected1==10) begin
                    count_expected1 = 0;
                end
                
                #2 clock1 = 1'b0;
                #2 clock1 = 1'b1;
                if(count1 == count_expected1) begin
                    Passed = Passed+1;
                end
                else begin
                    Failed = Failed+1;
                end
            end
        end
        ////////////////////////
    endtask

    /* Implement test task for lab6_2 */
    task lab6_2_test;
        ////////////////////////
        integer i;
        reg [7:0] count_expected2;
        begin
            $display("lab6_2_test");
            count_expected2 = 8'h00;
            
            clock1 = 1'b1;
            reset1 = 1'b0;
            clock2 = 1'b1;
            reset2 = 1'b0;
            clock3 = 1'b1;
            reset3 = 1'b0;
            
            #2 clock2 = 1'b0;
            #2 clock2 = 1'b1;
            reset2 = 1'b1;
            
            for(i=0;i<200;i=i+1) begin
                count_expected2 = count_expected2+1;
                if(count_expected2[3:0]==10) begin
                    count_expected2[7:4]=count_expected2[7:4]+1;
                    count_expected2[3:0]=0;
                end
                if(count_expected2[7:4]==10) begin
                    count_expected2[7:4]=0;
                    count_expected2[3:0]=0;
                end
                
                #2 clock2 = 1'b0;
                #2 clock2 = 1'b1;
                if(count2 == count_expected2)begin
                    Passed = Passed +1;
                end
                else begin
                    Failed = Failed+1;
                end
            end
        end
        ////////////////////////
    endtask

    /* Implement test task for lab6_3 */
    task lab6_3_test;
        ////////////////////////
        integer i;
        reg [3:0] count_expected3;
        begin
            $display("lab6_3_test");
            count_expected3 = 4'h0;
            
            clock1 = 1'b1;
            reset1 = 1'b0;
            clock2 = 1'b1;
            reset2 = 1'b0;
            clock3 = 1'b1;
            reset3 = 1'b0;
            
            #2 clock3 = 1'b0;
            #2 clock3 = 1'b1;
            reset3 = 1'b1;
            
            for(i=0; i<30; i=i+1) begin
                if(count_expected3 == 13) begin
                    count_expected3 = 6;
                end
                else if(count_expected3==9) begin
                    count_expected3 = 13;
                end
                else begin
                    count_expected3 = count_expected3+3;
                end
                
                #2 clock3 = 1'b0;
                #1;
                if(count3 == count_expected3) begin
                    Passed = Passed+1;
                end
                else begin
                    Failed = Failed+1;
                end
                #1 clock3 = 1'b1;
            end
        end
        ////////////////////////
    endtask

endmodule