module Tensor_Core(
    input clk,
    input rst,
    input clr_C,
    input idle,
    input signed [7:0] A11,A12,A13,A14,A21,A22,A23,A24,A31,A32,A33,A34,A41,A42,A43,A44,
                       B11,B12,B13,B14,B21,B22,B23,B24,B31,B32,B33,B34,B41,B42,B43,B44,
    output signed [31:0] D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44,
    output reg valid
);
    reg signed [7:0] A_in_11, A_in_12, A_in_13, A_in_14,
    A_in_21, A_in_22, A_in_23, A_in_24,
    A_in_31, A_in_32, A_in_33, A_in_34,
    A_in_41, A_in_42, A_in_43, A_in_44,
    B_in_11, B_in_12, B_in_13, B_in_14,
    B_in_21, B_in_22, B_in_23, B_in_24,
    B_in_31, B_in_32, B_in_33, B_in_34,
    B_in_41, B_in_42, B_in_43, B_in_44;

    reg signed [31:0] C_in_11, C_in_12, C_in_13, C_in_14,
    C_in_21, C_in_22, C_in_23, C_in_24,
    C_in_31, C_in_32, C_in_33, C_in_34,
    C_in_41, C_in_42, C_in_43, C_in_44;

    wire signed [31:0] mac_out_11, mac_out_12, mac_out_13, mac_out_14,
    mac_out_21, mac_out_22, mac_out_23, mac_out_24,
    mac_out_31, mac_out_32, mac_out_33, mac_out_34,
    mac_out_41, mac_out_42, mac_out_43, mac_out_44;

    always @(posedge clk) begin
        if(rst) begin
            A_in_11 <= 8'sd0;  A_in_12 <= 8'sd0;  A_in_13 <= 8'sd0;  A_in_14 <= 8'sd0;
            A_in_21 <= 8'sd0;  A_in_22 <= 8'sd0;  A_in_23 <= 8'sd0;  A_in_24 <= 8'sd0;
            A_in_31 <= 8'sd0;  A_in_32 <= 8'sd0;  A_in_33 <= 8'sd0;  A_in_34 <= 8'sd0;
            A_in_41 <= 8'sd0;  A_in_42 <= 8'sd0;  A_in_43 <= 8'sd0;  A_in_44 <= 8'sd0;

            B_in_11 <= 8'sd0;  B_in_12 <= 8'sd0;  B_in_13 <= 8'sd0;  B_in_14 <= 8'sd0;
            B_in_21 <= 8'sd0;  B_in_22 <= 8'sd0;  B_in_23 <= 8'sd0;  B_in_24 <= 8'sd0;
            B_in_31 <= 8'sd0;  B_in_32 <= 8'sd0;  B_in_33 <= 8'sd0;  B_in_34 <= 8'sd0;
            B_in_41 <= 8'sd0;  B_in_42 <= 8'sd0;  B_in_43 <= 8'sd0;  B_in_44 <= 8'sd0;

            C_in_11 <= 32'sd0;  C_in_12 <= 32'sd0;  C_in_13 <= 32'sd0;  C_in_14 <= 32'sd0;
            C_in_21 <= 32'sd0;  C_in_22 <= 32'sd0;  C_in_23 <= 32'sd0;  C_in_24 <= 32'sd0;
            C_in_31 <= 32'sd0;  C_in_32 <= 32'sd0;  C_in_33 <= 32'sd0;  C_in_34 <= 32'sd0;
            C_in_41 <= 32'sd0;  C_in_42 <= 32'sd0;  C_in_43 <= 32'sd0;  C_in_44 <= 32'sd0;
            valid <= 1'b0;
        end

        else if(idle) begin
            A_in_11 <= 8'sd0;  A_in_12 <= 8'sd0;  A_in_13 <= 8'sd0;  A_in_14 <= 8'sd0;
            A_in_21 <= 8'sd0;  A_in_22 <= 8'sd0;  A_in_23 <= 8'sd0;  A_in_24 <= 8'sd0;
            A_in_31 <= 8'sd0;  A_in_32 <= 8'sd0;  A_in_33 <= 8'sd0;  A_in_34 <= 8'sd0;
            A_in_41 <= 8'sd0;  A_in_42 <= 8'sd0;  A_in_43 <= 8'sd0;  A_in_44 <= 8'sd0;

            B_in_11 <= 8'sd0;  B_in_12 <= 8'sd0;  B_in_13 <= 8'sd0;  B_in_14 <= 8'sd0;
            B_in_21 <= 8'sd0;  B_in_22 <= 8'sd0;  B_in_23 <= 8'sd0;  B_in_24 <= 8'sd0;
            B_in_31 <= 8'sd0;  B_in_32 <= 8'sd0;  B_in_33 <= 8'sd0;  B_in_34 <= 8'sd0;
            B_in_41 <= 8'sd0;  B_in_42 <= 8'sd0;  B_in_43 <= 8'sd0;  B_in_44 <= 8'sd0;

            C_in_11 <= mac_out_11;  C_in_12 <= mac_out_12;  C_in_13 <= mac_out_13;  C_in_14 <= mac_out_14;
            C_in_21 <= mac_out_21;  C_in_22 <= mac_out_22;  C_in_23 <= mac_out_23;  C_in_24 <= mac_out_24;
            C_in_31 <= mac_out_31;  C_in_32 <= mac_out_32;  C_in_33 <= mac_out_33;  C_in_34 <= mac_out_34;
            C_in_41 <= mac_out_41;  C_in_42 <= mac_out_42;  C_in_43 <= mac_out_43;  C_in_44 <= mac_out_44;

            valid <= 1'b1;
        end

        else if(!clr_C) begin
            A_in_11 <= A11;  A_in_12 <= A12;  A_in_13 <= A13;  A_in_14 <= A14;
            A_in_21 <= A21;  A_in_22 <= A22;  A_in_23 <= A23;  A_in_24 <= A24;
            A_in_31 <= A31;  A_in_32 <= A32;  A_in_33 <= A33;  A_in_34 <= A34;
            A_in_41 <= A41;  A_in_42 <= A42;  A_in_43 <= A43;  A_in_44 <= A44;

            B_in_11 <= B11;  B_in_12 <= B12;  B_in_13 <= B13;  B_in_14 <= B14;
            B_in_21 <= B21;  B_in_22 <= B22;  B_in_23 <= B23;  B_in_24 <= B24;
            B_in_31 <= B31;  B_in_32 <= B32;  B_in_33 <= B33;  B_in_34 <= B34;
            B_in_41 <= B41;  B_in_42 <= B42;  B_in_43 <= B43;  B_in_44 <= B44;

            C_in_11 <= mac_out_11;  C_in_12 <= mac_out_12;  C_in_13 <= mac_out_13;  C_in_14 <= mac_out_14;
            C_in_21 <= mac_out_21;  C_in_22 <= mac_out_22;  C_in_23 <= mac_out_23;  C_in_24 <= mac_out_24;
            C_in_31 <= mac_out_31;  C_in_32 <= mac_out_32;  C_in_33 <= mac_out_33;  C_in_34 <= mac_out_34;
            C_in_41 <= mac_out_41;  C_in_42 <= mac_out_42;  C_in_43 <= mac_out_43;  C_in_44 <= mac_out_44;
            valid <= 1'b1;
        end

        else if(clr_C) begin
            A_in_11 <= A11;  A_in_12 <= A12;  A_in_13 <= A13;  A_in_14 <= A14;
            A_in_21 <= A21;  A_in_22 <= A22;  A_in_23 <= A23;  A_in_24 <= A24;
            A_in_31 <= A31;  A_in_32 <= A32;  A_in_33 <= A33;  A_in_34 <= A34;
            A_in_41 <= A41;  A_in_42 <= A42;  A_in_43 <= A43;  A_in_44 <= A44;
            B_in_11 <= B11;  B_in_12 <= B12;  B_in_13 <= B13;  B_in_14 <= B14;
            B_in_21 <= B21;  B_in_22 <= B22;  B_in_23 <= B23;  B_in_24 <= B24;
            B_in_31 <= B31;  B_in_32 <= B32;  B_in_33 <= B33;  B_in_34 <= B34;
            B_in_41 <= B41;  B_in_42 <= B42;  B_in_43 <= B43;  B_in_44 <= B44;
            C_in_11 <= 32'sd0;  C_in_12 <= 32'sd0;  C_in_13 <= 32'sd0;  C_in_14 <= 32'sd0;
            C_in_21 <= 32'sd0;  C_in_22 <= 32'sd0;  C_in_23 <= 32'sd0;  C_in_24 <= 32'sd0;
            C_in_31 <= 32'sd0;  C_in_32 <= 32'sd0;  C_in_33 <= 32'sd0;  C_in_34 <= 32'sd0;
            C_in_41 <= 32'sd0;  C_in_42 <= 32'sd0;  C_in_43 <= 32'sd0;  C_in_44 <= 32'sd0;
            valid <= 1'b0;
        end
    end

    MAC_4x4 PE(
    .A11(A_in_11), .A12(A_in_12), .A13(A_in_13), .A14(A_in_14),
    .A21(A_in_21), .A22(A_in_22), .A23(A_in_23), .A24(A_in_24),
    .A31(A_in_31), .A32(A_in_32), .A33(A_in_33), .A34(A_in_34),
    .A41(A_in_41), .A42(A_in_42), .A43(A_in_43), .A44(A_in_44),

    .B11(B_in_11), .B12(B_in_12), .B13(B_in_13), .B14(B_in_14),
    .B21(B_in_21), .B22(B_in_22), .B23(B_in_23), .B24(B_in_24),
    .B31(B_in_31), .B32(B_in_32), .B33(B_in_33), .B34(B_in_34),
    .B41(B_in_41), .B42(B_in_42), .B43(B_in_43), .B44(B_in_44),

    .C11(C_in_11), .C12(C_in_12), .C13(C_in_13), .C14(C_in_14),
    .C21(C_in_21), .C22(C_in_22), .C23(C_in_23), .C24(C_in_24),
    .C31(C_in_31), .C32(C_in_32), .C33(C_in_33), .C34(C_in_34),
    .C41(C_in_41), .C42(C_in_42), .C43(C_in_43), .C44(C_in_44),

    .D11(mac_out_11), .D12(mac_out_12), .D13(mac_out_13), .D14(mac_out_14),
    .D21(mac_out_21), .D22(mac_out_22), .D23(mac_out_23), .D24(mac_out_24),
    .D31(mac_out_31), .D32(mac_out_32), .D33(mac_out_33), .D34(mac_out_34),
    .D41(mac_out_41), .D42(mac_out_42), .D43(mac_out_43), .D44(mac_out_44)
    );

    assign D11 = mac_out_11;  assign D12 = mac_out_12;  assign D13 = mac_out_13;  assign D14 = mac_out_14;
    assign D21 = mac_out_21;  assign D22 = mac_out_22;  assign D23 = mac_out_23;  assign D24 = mac_out_24;
    assign D31 = mac_out_31;  assign D32 = mac_out_32;  assign D33 = mac_out_33;  assign D34 = mac_out_34;
    assign D41 = mac_out_41;  assign D42 = mac_out_42;  assign D43 = mac_out_43;  assign D44 = mac_out_44;

endmodule