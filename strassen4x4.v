module strassen4x4(
     input signed [7:0] m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44,
     input signed [7:0] n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44,
     output signed [22:0] z11, z12, z13, z14, z21, z22, z23, z24, z31, z32, z33, z34, z41, z42, z43, z44
);

    wire signed [8:0] q111, q112, q121, q122, q211, q212, q221, q222, q311, q312, q321, q322;
    wire signed [8:0] q411, q412, q421, q422, q511, q512, q521, q522, q611, q612, q621, q622;
    wire signed [8:0] q711, q712, q721, q722, q811, q812, q821, q822, q911, q912, q921, q922, q1011, q1012, q1021, q1022;

    wire signed [19:0] st1_11, st1_12, st1_21, st1_22;
    wire signed [19:0] st2_11, st2_12, st2_21, st2_22;
    wire signed [19:0] st3_11, st3_12, st3_21, st3_22;
    wire signed [19:0] st4_11, st4_12, st4_21, st4_22;
    wire signed [19:0] st5_11, st5_12, st5_21, st5_22;
    wire signed [19:0] st6_11, st6_12, st6_21, st6_22;
    wire signed [19:0] st7_11, st7_12, st7_21, st7_22;

    wire signed [20:0] f1_4_11, f1_4_12, f1_4_21, f1_4_22;
    wire signed [21:0] f14_5_11, f14_5_12, f14_5_21, f14_5_22;
    wire signed [20:0] f1_2_11, f1_2_12, f1_2_21, f1_2_22;
    wire signed [21:0] f12_3_11, f12_3_12, f12_3_21, f12_3_22;

    wire signed [20:0] fz12_11, fz12_12, fz12_21, fz12_22;
    wire signed [20:0] fz21_11, fz21_12, fz21_21, fz21_22;

    add q_one(m11, m12, m21, m22, m33, m34, m43, m44, q111, q112, q121, q122);
    add q_two(n11, n12, n21, n22, n33, n34, n43, n44, q211, q212, q221, q222);
    add q_three(m31, m32, m41, m42, m33, m34, m43, m44, q311, q312, q321, q322);
    subtract q_four(n13, n14, n23, n24, n33, n34, n43, n44, q411, q412, q421, q422);
    subtract q_five(n31, n32, n41, n42, n11, n12, n21, n22, q511, q512, q521, q522);
    add q_six(m11, m12, m21, m22, m13, m14, m23, m24, q611, q612, q621, q622);
    subtract q_seven(m31, m32, m41, m42, m11, m12, m21, m22, q711, q712, q721, q722);
    add q_eight(n11, n12, n21, n22, n13, n14, n23, n24, q811, q812, q821, q822);
    subtract q_nine(m13, m14, m23, m24, m33, m34, m43, m44, q911, q912, q921, q922);
    add q_ten(n31, n32, n41, n42, n33, n34, n43, n44, q1011, q1012, q1021, q1022);

    strassen2x2 st_one(q111, q112, q121, q122, q211, q212, q221, q222, st1_11, st1_12, st1_21, st1_22);
    strassen2x2 st_two(q311, q312, q321, q322, {n11[7],n11}, {n12[7],n12}, {n21[7],n21}, {n22[7],n22}, st2_11, st2_12, st2_21, st2_22);
    strassen2x2 st_three({m11[7],m11}, {m12[7],m12}, {m21[7],m21}, {m22[7],m22}, q411, q412, q421, q422, st3_11, st3_12, st3_21, st3_22);
    strassen2x2 st_four({m33[7],m33}, {m34[7],m34}, {m43[7],m43}, {m44[7],m44}, q511, q512, q521, q522, st4_11, st4_12, st4_21, st4_22);
    strassen2x2 st_five(q611, q612, q621, q622, {n33[7],n33}, {n34[7],n34}, {n43[7],n43}, {n44[7],n44}, st5_11, st5_12, st5_21, st5_22);
    strassen2x2 st_six(q711, q712, q721, q722, q811, q812, q821, q822, st6_11, st6_12, st6_21, st6_22);
    strassen2x2 st_seven(q911, q912, q921, q922, q1011, q1012, q1021, q1022, st7_11, st7_12, st7_21, st7_22);

    add20 zz11_1(st1_11, st1_12, st1_21, st1_22, st4_11, st4_12, st4_21, st4_22, f1_4_11, f1_4_12, f1_4_21, f1_4_22);
    subtract21 zz11_2(f1_4_11, f1_4_12, f1_4_21, f1_4_22, {st5_11[19],st5_11}, {st5_12[19],st5_12}, {st5_21[19],st5_21}, {st5_22[19],st5_22}, f14_5_11, f14_5_12, f14_5_21, f14_5_22);
    add22 zz11(f14_5_11, f14_5_12, f14_5_21, f14_5_22, {{2{st7_11[19]}},st7_11}, {{2{st7_12[19]}},st7_12}, {{2{st7_21[19]}},st7_21}, {{2{st7_22[19]}},st7_22}, z11, z12, z21, z22);
    add20 zz12(st3_11, st3_12, st3_21, st3_22, st5_11, st5_12, st5_21, st5_22, fz12_11, fz12_12, fz12_21, fz12_22);
    assign z13 = {{2{fz12_11[20]}}, fz12_11};
    assign z14 = {{2{fz12_12[20]}}, fz12_12};
    assign z23 = {{2{fz12_21[20]}}, fz12_21};
    assign z24 = {{2{fz12_22[20]}}, fz12_22};
    add20 zz21(st2_11, st2_12, st2_21, st2_22, st4_11, st4_12, st4_21, st4_22, fz21_11, fz21_12, fz21_21, fz21_22);
    assign z31 = {{2{fz21_11[20]}}, fz21_11};
    assign z32 = {{2{fz21_12[20]}}, fz21_12};
    assign z41 = {{2{fz21_21[20]}}, fz21_21};
    assign z42 = {{2{fz21_22[20]}}, fz21_22};
    subtract20 z22_1(st1_11, st1_12, st1_21, st1_22, st2_11, st2_12, st2_21, st2_22, f1_2_11, f1_2_12, f1_2_21, f1_2_22);
    add21 zz22_2(f1_2_11, f1_2_12, f1_2_21, f1_2_22, {st3_11[19],st3_11}, {st3_12[19],st3_12}, {st3_21[19],st3_21}, {st3_22[19],st3_22}, f12_3_11, f12_3_12, f12_3_21, f12_3_22);
    add22 zz22(f12_3_11, f12_3_12, f12_3_21, f12_3_22, {{2{st6_11[19]}},st6_11}, {{2{st6_12[19]}},st6_12}, {{2{st6_21[19]}},st6_21}, {{2{st6_22[19]}},st6_22}, z33, z34, z43, z44);
endmodule


module add20(input signed [19:0] k11,k12,k21,k22, t11,t12,t21,t22, output signed [20:0] s11,s12,s21,s22);
    assign s11 = k11 + t11; assign s12 = k12 + t12; assign s21 = k21 + t21; assign s22 = k22 + t22;
endmodule

module subtract20(input signed [19:0] u11,u12,u21,u22, v11,v12,v21,v22, output signed [20:0] d11,d12,d21,d22);
    assign d11 = u11 - v11; assign d12 = u12 - v12; assign d21 = u21 - v21; assign d22 = u22 - v22;
endmodule

module add21(input signed [20:0] k11,k12,k21,k22, t11,t12,t21,t22, output signed [21:0] s11,s12,s21,s22);
    assign s11 = k11 + t11; assign s12 = k12 + t12; assign s21 = k21 + t21; assign s22 = k22 + t22;
endmodule

module add22(input signed [21:0] k11,k12,k21,k22, t11,t12,t21,t22, output signed [22:0] s11,s12,s21,s22);
    assign s11 = k11 + t11; assign s12 = k12 + t12; assign s21 = k21 + t21; assign s22 = k22 + t22;
endmodule

module subtract21(input signed [20:0] u11,u12,u21,u22, v11,v12,v21,v22, output signed [21:0] d11,d12,d21,d22);
    assign d11 = u11 - v11; assign d12 = u12 - v12; assign d21 = u21 - v21; assign d22 = u22 - v22;
endmodule


module strassen2x2(
    input signed [8:0] a00, a01, a10, a11,
    input signed [8:0] b00, b01, b10, b11,
    output signed [19:0] y00, y01, y10, y11
);
    wire signed [19:0] p [0:6];
    wire signed [9:0] s1 = b01 - b11;
    wire signed [9:0] s2 = a00 + a01;
    wire signed [9:0] s3 = a10 + a11;
    wire signed [9:0] s4 = b10 - b00;
    wire signed [9:0] s5 = a00 + a11;
    wire signed [9:0] s6 = b00 + b11;
    wire signed [9:0] s7 = a01 - a11;
    wire signed [9:0] s8 = b10 + b11;
    wire signed [9:0] s9 = a00 - a10;
    wire signed [9:0] s10 = b00 + b01;

    wallace10x10 wa1 ({a00[8],a00}, s1[9:0], p[0]);
    wallace10x10 wa2 (s2[9:0], {b11[8],b11}, p[1]);
    wallace10x10 wa3 (s3[9:0], {b00[8],b00}, p[2]);
    wallace10x10 wa4 ({a11[8],a11}, s4[9:0], p[3]);
    wallace10x10 wa5 (s5[9:0], s6[9:0], p[4]);
    wallace10x10 wa6 (s7[9:0], s8[9:0], p[5]);
    wallace10x10 wa7 (s9[9:0], s10[9:0], p[6]);

    assign y00 = p[4] + p[3] - p[1] + p[5];
    assign y01 = p[0] + p[1];
    assign y10 = p[2] + p[3];
    assign y11 = p[0] + p[4] - p[2] - p[6];
endmodule


module wallace10x10(
    input signed [9:0] A,
    input signed [9:0] B,
    output signed [19:0] Product 
);
    wire [9:0] A_pos, B_pos;
    wire result_sign;
    wire [19:0] unsigned_product;

    sign_check SC (A, B, A_pos, B_pos, result_sign);
    wallace_unsigned WU (A_pos, B_pos, unsigned_product);
    assign Product = result_sign ? -$signed(unsigned_product) : $signed(unsigned_product);
endmodule


module sign_check(
    input signed [9:0] A,
    input signed [9:0] B,
    output reg [9:0] A_pos,
    output reg [9:0] B_pos,
    output reg result_sign
);
    always @(*) begin
        A_pos = A[9] ? -A : A;
        B_pos = B[9] ? -B : B;
        result_sign = A[9] ^ B[9];
    end
endmodule

module add(input signed [7:0] k11,k12,k21,k22, t11,t12,t21,t22, output signed [8:0] s11,s12,s21,s22);
    assign s11 = k11 + t11; assign s12 = k12 + t12; assign s21 = k21 + t21; assign s22 = k22 + t22;
endmodule

module subtract(input signed [7:0] u11,u12,u21,u22, v11,v12,v21,v22, output signed [8:0] d11,d12,d21,d22);
    assign d11 = u11 - v11; assign d12 = u12 - v12; assign d21 = u21 - v21; assign d22 = u22 - v22;
endmodule


module wallace_unsigned(
    input [9:0] a,
    input [9:0] b,
    output [19:0] product
);
    wire [9:0] pp [9:0];
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : gen_pp
            assign pp[i] = a & {10{b[i]}};
        end
    endgenerate

    wire [19:0] pp_shifted [9:0];
    generate
        for (i = 0; i < 10; i = i + 1) begin : gen_shift
            assign pp_shifted[i] = ({10'b0, pp[i]}) << i;
        end
    endgenerate

    wire [19:0] acc [0:9];
    assign acc[0] = pp_shifted[0];

    genvar r, k;
    generate
        for (r = 1; r < 10; r = r + 1) begin : gen_row
            wire [19:0] sum_bits;
            wire [20:0] carry_chain;
            assign carry_chain[0] = 1'b0;
            for (k = 0; k < 20; k = k + 1) begin : gen_bit
                full_adder fa_inst(
                    acc[r-1][k],
                    pp_shifted[r][k],
                    carry_chain[k],
                    sum_bits[k],
                    carry_chain[k+1]
                );
            end
            assign acc[r] = sum_bits;
        end
    endgenerate

    assign product = acc[9];
endmodule

module half_adder(input a, b, output sum, cout);
    assign sum = a ^ b; assign cout = a & b;
endmodule

module full_adder(input a, b, cin, output sum, cout);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule