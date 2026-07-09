module MAC_4x4 (
    input signed [7:0] A11,A12,A13,A14,A21,A22,A23,A24,A31,A32,A33,A34,A41,A42,A43,A44,
                       B11,B12,B13,B14,B21,B22,B23,B24,B31,B32,B33,B34,B41,B42,B43,B44,
    //extra_bits = ceil(log2(num_passes))K is the reduction/inner dimension of the matmul — the dimension you're summing over. For A[M×K] × B[K×N], K is how many terms get accumulated into each output element, which directly equals how many passes your tensor core has to do (K/4 passes, since your core eats 4-wide chunks per pass).
    //For "basic ML model, just enough to test the core" — vague guess: K ≈ 512–1024 is plenty. That covers a small MLP/CNN layer or a toy transformer block (e.g. a tiny attention head or feedforward layer with hidden dim in the few-hundred-to-1024 range), without trying to match anything production-scale.
    //At K=1024 → 256 passes → 8 extra bits on top of single-pass width → comfortably fits in a 32-bit accumulator with margin to spare, so it doesn't even stress your already-planned width.
    //That's the one-time answer — back to the regularly scheduled design work whenever you're ready.
    input signed [31:0] C11,C12,C13,C14,C21,C22,C23,C24,C31,C32,C33,C34,C41,C42,C43,C44,
    output signed [31:0] D11,D12,D13,D14,D21,D22,D23,D24,D31,D32,D33,D34,D41,D42,D43,D44
);
    // intermediate just multiplication result
    wire signed [22:0] M11,M12,M13,M14,M21,M22,M23,M24,M31,M32,M33,M34,M41,M42,M43,M44;

    //instantiate 4x4 multiplier
    strassen4x4 M(
    .m11(A11), .m12(A12), .m13(A13), .m14(A14),
    .m21(A21), .m22(A22), .m23(A23), .m24(A24),
    .m31(A31), .m32(A32), .m33(A33), .m34(A34),
    .m41(A41), .m42(A42), .m43(A43), .m44(A44),

    .n11(B11), .n12(B12), .n13(B13), .n14(B14),
    .n21(B21), .n22(B22), .n23(B23), .n24(B24),
    .n31(B31), .n32(B32), .n33(B33), .n34(B34),
    .n41(B41), .n42(B42), .n43(B43), .n44(B44),
    
    .z11(M11), .z12(M12), .z13(M13), .z14(M14),
    .z21(M21), .z22(M22), .z23(M23), .z24(M24),
    .z31(M31), .z32(M32), .z33(M33), .z34(M34),
    .z41(M41), .z42(M42), .z43(M43), .z44(M44)
    );

    //accumulate
    assign D11 = C11 + M11;
    assign D12 = C12 + M12;
    assign D13 = C13 + M13;
    assign D14 = C14 + M14;

    assign D21 = C21 + M21;
    assign D22 = C22 + M22;
    assign D23 = C23 + M23;
    assign D24 = C24 + M24;

    assign D31 = C31 + M31;
    assign D32 = C32 + M32;
    assign D33 = C33 + M33;
    assign D34 = C34 + M34;

    assign D41 = C41 + M41;
    assign D42 = C42 + M42;
    assign D43 = C43 + M43;
    assign D44 = C44 + M44;

endmodule