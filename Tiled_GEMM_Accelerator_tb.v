`timescale 1ns/1ps

module Tiled_GEMM_Accelerator_tb;


    /*  refer to this before changing parameters:
      PAD_ROWS_A        = ((ROWS_A + 3)/4) * 4
        PAD_COLS_A_ROWS_B = ((COLS_A_ROWS_B + 3)/4) * 4
        PAD_COLS_B        = ((COLS_B + 3)/4) * 4

        I_tiles = PAD_ROWS_A        / 4
        k_tiles = PAD_COLS_A_ROWS_B / 4
        J_tiles = PAD_COLS_B        / 4

        I_WIDTH    = $clog2(I_tiles+1)
        K_WIDTH    = $clog2(k_tiles)
        J_WIDTH    = $clog2(J_tiles+4)

        A_SIZE = PAD_ROWS_A        * PAD_COLS_A_ROWS_B
        B_SIZE = PAD_COLS_A_ROWS_B * PAD_COLS_B
        C_SIZE = PAD_ROWS_A        * PAD_COLS_B

        ADDR_WIDTH = $clog2( max(A_SIZE, B_SIZE, C_SIZE) )  */

    parameter ROWS_A         = 256;
    parameter COLS_A_ROWS_B  = 16;
    parameter COLS_B         = 704;

    parameter I_WIDTH = 7;
    parameter K_WIDTH = 2;
    parameter J_WIDTH = 8;

    parameter ADDR_WIDTH = 18;


    parameter PAD_ROWS_A        = ((ROWS_A+3)/4)*4;
    parameter PAD_COLS_A_ROWS_B = ((COLS_A_ROWS_B+3)/4)*4;
    parameter PAD_COLS_B        = ((COLS_B+3)/4)*4;

    parameter A_SIZE = PAD_ROWS_A * PAD_COLS_A_ROWS_B;
    parameter B_SIZE = PAD_COLS_A_ROWS_B * PAD_COLS_B;
    parameter C_SIZE = PAD_ROWS_A * PAD_COLS_B;

    reg clk, rst, start, wr_en, wr_sel;
    reg [ADDR_WIDTH-1:0] wr_addr, rd_addr;
    reg signed [7:0] wr_data;

    wire signed [31:0] rd_data;
    wire finished;

    integer error_count;
    integer test_count;
    integer i;

    reg signed [7:0]  mem_a [0:A_SIZE-1];
    reg signed [7:0]  mem_b [0:B_SIZE-1];

    reg signed [31:0] predicted_mem_d [0:C_SIZE-1];
    reg signed [31:0] actual_mem_d    [0:C_SIZE-1];


    Tiled_GEMM_Accelerator #(
        .ROWS_A(ROWS_A),
        .COLS_A_ROWS_B(COLS_A_ROWS_B),
        .COLS_B(COLS_B),
        .I_WIDTH(I_WIDTH),
        .K_WIDTH(K_WIDTH),
        .J_WIDTH(J_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut(.clk(clk), .rst(rst), .start(start), .wr_en(wr_en), .wr_sel(wr_sel),
          .wr_addr(wr_addr), .rd_addr(rd_addr), .wr_data(wr_data),
          .rd_data(rd_data), .finished(finished));

    initial begin
        clk=0;
        forever #5 clk=~clk;
    end

    task do_reset;
        begin
            rst=1;
            repeat(2) @(posedge clk);
            rst=0;
            #20;
        end
    endtask

    task load_internal_mem;
        begin
            wr_en=1;
            for(i=0;i<A_SIZE;i=i+1) begin
                wr_sel=0;
                wr_addr=i;
                wr_data=mem_a[i];
                #1;
                @(posedge clk);
            end
            for(i=0;i<B_SIZE;i=i+1) begin
                wr_sel=1;
                wr_addr=i;
                wr_data=mem_b[i];
                #1;
                @(posedge clk);
            end
            wr_en=0;
        end
    endtask

    task generate_input_matrix;
        begin
            for(i=0;i<A_SIZE;i=i+1)
                mem_a[i] = $urandom & 8'hFF;
            for(i=0;i<B_SIZE;i=i+1)
                mem_b[i] = $urandom & 8'hFF;
        end
    endtask

    task calc_output_matrix;
        integer j,k,row,column,sum;
        begin
            for(j=0;j<C_SIZE;j=j+1) begin
                row    = j/PAD_COLS_B;
                column = j%PAD_COLS_B;
                sum=0;
                for(k=0;k<PAD_COLS_A_ROWS_B;k=k+1) begin
                    sum = mem_a[row*PAD_COLS_A_ROWS_B+k] * mem_b[k*PAD_COLS_B+column] + sum;
                end
                predicted_mem_d[j]=sum;
            end
        end
    endtask

    task extract_output;
        begin
            for(i=0;i<C_SIZE;i=i+1) begin
                rd_addr=i;
                #1;
                actual_mem_d[i]=rd_data;
                #1;
            end
        end
    endtask

    task check_output;
        begin
            error_count=0;
            test_count=0;
            for(i=0;i<C_SIZE;i=i+1) begin
                test_count=test_count+1;
                if(predicted_mem_d[i]!=actual_mem_d[i]) begin
                    error_count=error_count+1;
                    $display("Error at address: %d", i);
                    $display("correct: %d", predicted_mem_d[i]);
                    $display("actual: %d", actual_mem_d[i]);
                end
            end
            if(error_count) begin
                $display("FAIL! ROWS_A=%0d COLS_A_ROWS_B=%0d COLS_B=%0d Total test count: %d errors: %0d", ROWS_A, COLS_A_ROWS_B, COLS_B, test_count, error_count);
            end
            else begin
                $display("PASS! ROWS_A=%0d COLS_A_ROWS_B=%0d COLS_B=%0d Total test count: %d", ROWS_A, COLS_A_ROWS_B, COLS_B, test_count);
            end
        end
    endtask

    initial begin
        do_reset;
        generate_input_matrix;
        load_internal_mem;
        start=1;
        @(posedge clk);
        start=0;
        @(posedge clk);
        wait(finished);
        @(posedge clk);
        calc_output_matrix;
        extract_output;
        check_output;

        #100;
        $finish;
    end
endmodule