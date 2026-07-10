# Tiled GEMM Accelerator
A size parametrized matrix multiplier that pads uneven matrixes and feeds an array of 4 tensor cores based on a lockstep architechture. Tensor cores are a basix 4x4 matrix calculators based on Wallace multipliers and Strassens matrix algorithm for optimization. The design includes a memory unit to store operands and a self checking testbench with random value generator based on input parameters.
Before editing any parameters in the testbench make sure to follow these formulae. Also choose rows and columns that are multiples of 16 for the input matrixes.

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

        ADDR_WIDTH = $clog2( max(A_SIZE, B_SIZE, C_SIZE) )

Issues faced during design that were resolved: 
  1) do_reset's trailing @(posedge clk) raced against load_internal_mem's first write on the testbench, silently dropping the write to address 0 every single run.
  2) Without an explicit "freeze" mechanism, Tensor_Core kept re-latching real A/B wire values every cycle regardless of state, meaning the last k-term's contribution could get added twice during a naive DRAIN state, and prefetching the next tile during DRAIN would corrupt the in-flight accumulation.
  3) Both the start state and the store state asserted clr_C and let compute begin at k_reg=0, but Tensor_Core's registered pipeline lag meant start/store had already latched and "used" the k=0 tile. Letting compute re-request k=0 caused that term to be added into the accumulator twice.
