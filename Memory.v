module Memory #(
    parameter ROWS_A = 16,
    parameter COLS_A_ROWS_B  = 16,
    parameter COLS_B = 16,
    parameter I_WIDTH = 5,
    parameter K_WIDTH = 5,
    parameter J_WIDTH = 5,
    parameter ADDR_WIDTH = 8
)(
    input clk, rst, wr_en, wr_sel, wb_en,
    input [ADDR_WIDTH-1:0] wr_addr, rd_addr,
    input signed [7:0] wr_data,
    input [I_WIDTH-1:0] I, wb_I1, wb_I2, wb_I3, wb_I4,
    input [K_WIDTH-1:0] k,
    input [J_WIDTH-1:0 ]J_b1, wb_J1,
                J_b2, wb_J2,
                J_b3, wb_J3,
                J_b4, wb_J4,

    input signed [31:0] D11_1, D12_1, D13_1, D14_1,
                        D21_1, D22_1, D23_1, D24_1,
                        D31_1, D32_1, D33_1, D34_1,
                        D41_1, D42_1, D43_1, D44_1,

                        D11_2, D12_2, D13_2, D14_2,
                        D21_2, D22_2, D23_2, D24_2,
                        D31_2, D32_2, D33_2, D34_2,
                        D41_2, D42_2, D43_2, D44_2,

                        D11_3, D12_3, D13_3, D14_3,
                        D21_3, D22_3, D23_3, D24_3,
                        D31_3, D32_3, D33_3, D34_3,
                        D41_3, D42_3, D43_3, D44_3,

                        D11_4, D12_4, D13_4, D14_4,
                        D21_4, D22_4, D23_4, D24_4,
                        D31_4, D32_4, D33_4, D34_4,
                        D41_4, D42_4, D43_4, D44_4,

    output signed [7:0] A11,A12,A13,A14,A21,A22,A23,A24,A31,A32,A33,A34,A41,A42,A43,A44,

                        B11_1, B12_1, B13_1, B14_1,
                        B21_1, B22_1, B23_1, B24_1,
                        B31_1, B32_1, B33_1, B34_1,
                        B41_1, B42_1, B43_1, B44_1,

                        B11_2, B12_2, B13_2, B14_2,
                        B21_2, B22_2, B23_2, B24_2,
                        B31_2, B32_2, B33_2, B34_2,
                        B41_2, B42_2, B43_2, B44_2,

                        B11_3, B12_3, B13_3, B14_3,
                        B21_3, B22_3, B23_3, B24_3,
                        B31_3, B32_3, B33_3, B34_3,
                        B41_3, B42_3, B43_3, B44_3,

                        B11_4, B12_4, B13_4, B14_4,
                        B21_4, B22_4, B23_4, B24_4,
                        B31_4, B32_4, B33_4, B34_4,
                        B41_4, B42_4, B43_4, B44_4,
    
    output signed [31:0] rd_data
);

    parameter PAD_ROWS_A = ((ROWS_A+3)/4)*4;
    parameter PAD_COLS_A_ROWS_B = ((COLS_A_ROWS_B+3)/4)*4;
    parameter PAD_COLS_B = ((COLS_B+3)/4)*4;

    parameter A_SIZE = PAD_ROWS_A * PAD_COLS_A_ROWS_B;
    parameter B_SIZE = PAD_COLS_A_ROWS_B * PAD_COLS_B;
    parameter C_SIZE = PAD_ROWS_A * PAD_COLS_B;

    reg signed [7:0]  mem_A [0:A_SIZE-1];
    reg signed [7:0]  mem_B [0:B_SIZE-1];
    reg signed [31:0] mem_D [0:C_SIZE-1];

    integer i;

    always @(posedge clk)begin
        if(rst) begin
            for (i = 0; i < A_SIZE; i = i + 1) begin
                mem_A[i] <= 8'sd0;
            end
            for (i = 0; i < B_SIZE; i = i + 1) begin
                mem_B[i] <= 8'sd0;
            end
            for (i = 0; i < C_SIZE; i = i + 1) begin
                mem_D[i] <= 32'sd0;
            end
        end

        else if(wr_en) begin
            if(!wr_sel) begin
                mem_A[wr_addr] <= wr_data;
            end

            else if(wr_sel) begin
                mem_B[wr_addr] <= wr_data;
            end
        end

        if(wb_en) begin
            // Block 1
            mem_D[(4*wb_I1 + 0)*PAD_COLS_B + (4*wb_J1 + 0)] <= D11_1;
            mem_D[(4*wb_I1 + 0)*PAD_COLS_B + (4*wb_J1 + 1)] <= D12_1;
            mem_D[(4*wb_I1 + 0)*PAD_COLS_B + (4*wb_J1 + 2)] <= D13_1;
            mem_D[(4*wb_I1 + 0)*PAD_COLS_B + (4*wb_J1 + 3)] <= D14_1;

            mem_D[(4*wb_I1 + 1)*PAD_COLS_B + (4*wb_J1 + 0)] <= D21_1;
            mem_D[(4*wb_I1 + 1)*PAD_COLS_B + (4*wb_J1 + 1)] <= D22_1;
            mem_D[(4*wb_I1 + 1)*PAD_COLS_B + (4*wb_J1 + 2)] <= D23_1;
            mem_D[(4*wb_I1 + 1)*PAD_COLS_B + (4*wb_J1 + 3)] <= D24_1;

            mem_D[(4*wb_I1 + 2)*PAD_COLS_B + (4*wb_J1 + 0)] <= D31_1;
            mem_D[(4*wb_I1 + 2)*PAD_COLS_B + (4*wb_J1 + 1)] <= D32_1;
            mem_D[(4*wb_I1 + 2)*PAD_COLS_B + (4*wb_J1 + 2)] <= D33_1;
            mem_D[(4*wb_I1 + 2)*PAD_COLS_B + (4*wb_J1 + 3)] <= D34_1;

            mem_D[(4*wb_I1 + 3)*PAD_COLS_B + (4*wb_J1 + 0)] <= D41_1;
            mem_D[(4*wb_I1 + 3)*PAD_COLS_B + (4*wb_J1 + 1)] <= D42_1;
            mem_D[(4*wb_I1 + 3)*PAD_COLS_B + (4*wb_J1 + 2)] <= D43_1;
            mem_D[(4*wb_I1 + 3)*PAD_COLS_B + (4*wb_J1 + 3)] <= D44_1;

            // Block 2
            mem_D[(4*wb_I2 + 0)*PAD_COLS_B + (4*wb_J2 + 0)] <= D11_2;
            mem_D[(4*wb_I2 + 0)*PAD_COLS_B + (4*wb_J2 + 1)] <= D12_2;
            mem_D[(4*wb_I2 + 0)*PAD_COLS_B + (4*wb_J2 + 2)] <= D13_2;
            mem_D[(4*wb_I2 + 0)*PAD_COLS_B + (4*wb_J2 + 3)] <= D14_2;

            mem_D[(4*wb_I2 + 1)*PAD_COLS_B + (4*wb_J2 + 0)] <= D21_2;
            mem_D[(4*wb_I2 + 1)*PAD_COLS_B + (4*wb_J2 + 1)] <= D22_2;
            mem_D[(4*wb_I2 + 1)*PAD_COLS_B + (4*wb_J2 + 2)] <= D23_2;
            mem_D[(4*wb_I2 + 1)*PAD_COLS_B + (4*wb_J2 + 3)] <= D24_2;

            mem_D[(4*wb_I2 + 2)*PAD_COLS_B + (4*wb_J2 + 0)] <= D31_2;
            mem_D[(4*wb_I2 + 2)*PAD_COLS_B + (4*wb_J2 + 1)] <= D32_2;
            mem_D[(4*wb_I2 + 2)*PAD_COLS_B + (4*wb_J2 + 2)] <= D33_2;
            mem_D[(4*wb_I2 + 2)*PAD_COLS_B + (4*wb_J2 + 3)] <= D34_2;

            mem_D[(4*wb_I2 + 3)*PAD_COLS_B + (4*wb_J2 + 0)] <= D41_2;
            mem_D[(4*wb_I2 + 3)*PAD_COLS_B + (4*wb_J2 + 1)] <= D42_2;
            mem_D[(4*wb_I2 + 3)*PAD_COLS_B + (4*wb_J2 + 2)] <= D43_2;
            mem_D[(4*wb_I2 + 3)*PAD_COLS_B + (4*wb_J2 + 3)] <= D44_2;

            // Block 3
            mem_D[(4*wb_I3 + 0)*PAD_COLS_B + (4*wb_J3 + 0)] <= D11_3;
            mem_D[(4*wb_I3 + 0)*PAD_COLS_B + (4*wb_J3 + 1)] <= D12_3;
            mem_D[(4*wb_I3 + 0)*PAD_COLS_B + (4*wb_J3 + 2)] <= D13_3;
            mem_D[(4*wb_I3 + 0)*PAD_COLS_B + (4*wb_J3 + 3)] <= D14_3;

            mem_D[(4*wb_I3 + 1)*PAD_COLS_B + (4*wb_J3 + 0)] <= D21_3;
            mem_D[(4*wb_I3 + 1)*PAD_COLS_B + (4*wb_J3 + 1)] <= D22_3;
            mem_D[(4*wb_I3 + 1)*PAD_COLS_B + (4*wb_J3 + 2)] <= D23_3;
            mem_D[(4*wb_I3 + 1)*PAD_COLS_B + (4*wb_J3 + 3)] <= D24_3;

            mem_D[(4*wb_I3 + 2)*PAD_COLS_B + (4*wb_J3 + 0)] <= D31_3;
            mem_D[(4*wb_I3 + 2)*PAD_COLS_B + (4*wb_J3 + 1)] <= D32_3;
            mem_D[(4*wb_I3 + 2)*PAD_COLS_B + (4*wb_J3 + 2)] <= D33_3;
            mem_D[(4*wb_I3 + 2)*PAD_COLS_B + (4*wb_J3 + 3)] <= D34_3;

            mem_D[(4*wb_I3 + 3)*PAD_COLS_B + (4*wb_J3 + 0)] <= D41_3;
            mem_D[(4*wb_I3 + 3)*PAD_COLS_B + (4*wb_J3 + 1)] <= D42_3;
            mem_D[(4*wb_I3 + 3)*PAD_COLS_B + (4*wb_J3 + 2)] <= D43_3;
            mem_D[(4*wb_I3 + 3)*PAD_COLS_B + (4*wb_J3 + 3)] <= D44_3;

            // Block 4
            mem_D[(4*wb_I4 + 0)*PAD_COLS_B + (4*wb_J4 + 0)] <= D11_4;
            mem_D[(4*wb_I4 + 0)*PAD_COLS_B + (4*wb_J4 + 1)] <= D12_4;
            mem_D[(4*wb_I4 + 0)*PAD_COLS_B + (4*wb_J4 + 2)] <= D13_4;
            mem_D[(4*wb_I4 + 0)*PAD_COLS_B + (4*wb_J4 + 3)] <= D14_4;

            mem_D[(4*wb_I4 + 1)*PAD_COLS_B + (4*wb_J4 + 0)] <= D21_4;
            mem_D[(4*wb_I4 + 1)*PAD_COLS_B + (4*wb_J4 + 1)] <= D22_4;
            mem_D[(4*wb_I4 + 1)*PAD_COLS_B + (4*wb_J4 + 2)] <= D23_4;
            mem_D[(4*wb_I4 + 1)*PAD_COLS_B + (4*wb_J4 + 3)] <= D24_4;

            mem_D[(4*wb_I4 + 2)*PAD_COLS_B + (4*wb_J4 + 0)] <= D31_4;
            mem_D[(4*wb_I4 + 2)*PAD_COLS_B + (4*wb_J4 + 1)] <= D32_4;
            mem_D[(4*wb_I4 + 2)*PAD_COLS_B + (4*wb_J4 + 2)] <= D33_4;
            mem_D[(4*wb_I4 + 2)*PAD_COLS_B + (4*wb_J4 + 3)] <= D34_4;

            mem_D[(4*wb_I4 + 3)*PAD_COLS_B + (4*wb_J4 + 0)] <= D41_4;
            mem_D[(4*wb_I4 + 3)*PAD_COLS_B + (4*wb_J4 + 1)] <= D42_4;
            mem_D[(4*wb_I4 + 3)*PAD_COLS_B + (4*wb_J4 + 2)] <= D43_4;
            mem_D[(4*wb_I4 + 3)*PAD_COLS_B + (4*wb_J4 + 3)] <= D44_4;
        end
    end

    // -------------------- A --------------------
    assign A11 = mem_A[(4*I + 0)*PAD_COLS_A_ROWS_B + (4*k + 0)];
    assign A12 = mem_A[(4*I + 0)*PAD_COLS_A_ROWS_B + (4*k + 1)];
    assign A13 = mem_A[(4*I + 0)*PAD_COLS_A_ROWS_B + (4*k + 2)];
    assign A14 = mem_A[(4*I + 0)*PAD_COLS_A_ROWS_B + (4*k + 3)];

    assign A21 = mem_A[(4*I + 1)*PAD_COLS_A_ROWS_B + (4*k + 0)];
    assign A22 = mem_A[(4*I + 1)*PAD_COLS_A_ROWS_B + (4*k + 1)];
    assign A23 = mem_A[(4*I + 1)*PAD_COLS_A_ROWS_B + (4*k + 2)];
    assign A24 = mem_A[(4*I + 1)*PAD_COLS_A_ROWS_B + (4*k + 3)];

    assign A31 = mem_A[(4*I + 2)*PAD_COLS_A_ROWS_B + (4*k + 0)];
    assign A32 = mem_A[(4*I + 2)*PAD_COLS_A_ROWS_B + (4*k + 1)];
    assign A33 = mem_A[(4*I + 2)*PAD_COLS_A_ROWS_B + (4*k + 2)];
    assign A34 = mem_A[(4*I + 2)*PAD_COLS_A_ROWS_B + (4*k + 3)];

    assign A41 = mem_A[(4*I + 3)*PAD_COLS_A_ROWS_B + (4*k + 0)];
    assign A42 = mem_A[(4*I + 3)*PAD_COLS_A_ROWS_B + (4*k + 1)];
    assign A43 = mem_A[(4*I + 3)*PAD_COLS_A_ROWS_B + (4*k + 2)];
    assign A44 = mem_A[(4*I + 3)*PAD_COLS_A_ROWS_B + (4*k + 3)];


    // -------------------- B1 --------------------
    assign B11_1 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b1 + 0)];
    assign B12_1 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b1 + 1)];
    assign B13_1 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b1 + 2)];
    assign B14_1 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b1 + 3)];

    assign B21_1 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b1 + 0)];
    assign B22_1 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b1 + 1)];
    assign B23_1 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b1 + 2)];
    assign B24_1 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b1 + 3)];

    assign B31_1 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b1 + 0)];
    assign B32_1 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b1 + 1)];
    assign B33_1 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b1 + 2)];
    assign B34_1 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b1 + 3)];

    assign B41_1 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b1 + 0)];
    assign B42_1 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b1 + 1)];
    assign B43_1 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b1 + 2)];
    assign B44_1 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b1 + 3)];


    // -------------------- B2 --------------------
    assign B11_2 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b2 + 0)];
    assign B12_2 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b2 + 1)];
    assign B13_2 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b2 + 2)];
    assign B14_2 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b2 + 3)];

    assign B21_2 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b2 + 0)];
    assign B22_2 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b2 + 1)];
    assign B23_2 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b2 + 2)];
    assign B24_2 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b2 + 3)];

    assign B31_2 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b2 + 0)];
    assign B32_2 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b2 + 1)];
    assign B33_2 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b2 + 2)];
    assign B34_2 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b2 + 3)];

    assign B41_2 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b2 + 0)];
    assign B42_2 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b2 + 1)];
    assign B43_2 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b2 + 2)];
    assign B44_2 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b2 + 3)];


    // -------------------- B3 --------------------
    assign B11_3 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b3 + 0)];
    assign B12_3 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b3 + 1)];
    assign B13_3 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b3 + 2)];
    assign B14_3 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b3 + 3)];

    assign B21_3 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b3 + 0)];
    assign B22_3 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b3 + 1)];
    assign B23_3 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b3 + 2)];
    assign B24_3 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b3 + 3)];

    assign B31_3 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b3 + 0)];
    assign B32_3 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b3 + 1)];
    assign B33_3 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b3 + 2)];
    assign B34_3 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b3 + 3)];

    assign B41_3 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b3 + 0)];
    assign B42_3 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b3 + 1)];
    assign B43_3 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b3 + 2)];
    assign B44_3 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b3 + 3)];


    // -------------------- B4 --------------------
    assign B11_4 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b4 + 0)];
    assign B12_4 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b4 + 1)];
    assign B13_4 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b4 + 2)];
    assign B14_4 = mem_B[(4*k + 0)*PAD_COLS_B + (4*J_b4 + 3)];

    assign B21_4 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b4 + 0)];
    assign B22_4 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b4 + 1)];
    assign B23_4 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b4 + 2)];
    assign B24_4 = mem_B[(4*k + 1)*PAD_COLS_B + (4*J_b4 + 3)];

    assign B31_4 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b4 + 0)];
    assign B32_4 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b4 + 1)];
    assign B33_4 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b4 + 2)];
    assign B34_4 = mem_B[(4*k + 2)*PAD_COLS_B + (4*J_b4 + 3)];

    assign B41_4 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b4 + 0)];
    assign B42_4 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b4 + 1)];
    assign B43_4 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b4 + 2)];
    assign B44_4 = mem_B[(4*k + 3)*PAD_COLS_B + (4*J_b4 + 3)];


    assign rd_data = mem_D[rd_addr];

endmodule