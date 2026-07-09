module Scheduler #(
    parameter ROWS_A = 16,
    parameter COLS_A_ROWS_B  = 16,
    parameter COLS_B = 16,
    parameter I_WIDTH = 5,
    parameter K_WIDTH = 5,
    parameter J_WIDTH = 5
)(
    input clk, rst, initiate, valid_1, valid_2, valid_3, valid_4,
    output reg wb_en,
    output reg [I_WIDTH-1:0] I, wb_I1, wb_I2, wb_I3, wb_I4,
    output reg [K_WIDTH-1:0] k,
    output reg [J_WIDTH-1:0 ]J_b1, wb_J1,
                J_b2, wb_J2,
                J_b3, wb_J3,
                J_b4, wb_J4,
    output reg rst_cores,
    output reg clr_C, done, idle_core
);

    parameter PAD_ROWS_A = ((ROWS_A+3)/4)*4;
    parameter PAD_COLS_A_ROWS_B  = ((COLS_A_ROWS_B+3)/4)*4;
    parameter PAD_COLS_B = ((COLS_B+3)/4)*4;

    parameter I_tiles = PAD_ROWS_A/4;
    parameter k_tiles = PAD_COLS_A_ROWS_B/4;
    parameter J_tiles = PAD_COLS_B/4;

    parameter idle=3'b000, start=3'b001, compute=3'b010, drain=3'b011, store=3'b100, dn=3'b101;

    reg [2:0] state, next_state;
    reg [I_WIDTH-1:0] row, next_row;
    reg [J_WIDTH-1:0]base_j, next_base_j;
    reg [K_WIDTH-1:0] k_reg, next_k_reg;

    always @(posedge clk) begin
        rst_cores<=0;
        if(rst) begin
            row<=0;
            state<=idle;
            k_reg<=0;
            rst_cores<=1;
            base_j<=0;
        end
        else begin
            row<=next_row;
            state<=next_state;
            k_reg<=next_k_reg;
            base_j<=next_base_j;
            if(next_state==dn) rst_cores<=1;
        end
    end

    always @(*) begin
        wb_en     = 1'b0;
        I         = 2'b00;
        k         = 2'b00;
        J_b1      = 2'b00;
        wb_I1     = 2'b00;
        wb_J1     = 2'b00;
        J_b2      = 2'b00;
        wb_I2     = 2'b00;
        wb_J2     = 2'b00;
        J_b3      = 2'b00;
        wb_I3     = 2'b00;
        wb_J3     = 2'b00;
        J_b4      = 2'b00;
        wb_I4     = 2'b00;
        wb_J4     = 2'b00;
        clr_C      = 1'b0;
        done       = 1'b0;
        idle_core  = 1'b0;
        next_row   = row;
        next_k_reg = k_reg;
        next_state = state;
        next_base_j = base_j;

        case(state)
            idle: begin
                idle_core=1;
                if(initiate) next_state=start;
                else next_state=idle;
            end

            start: begin
                I         = row;
                k         = 0;

                J_b1      = base_j;
                J_b2      = base_j+1;
                J_b3      = base_j+2;
                J_b4      = base_j+3;

                clr_C      = 1'b1;
                next_k_reg = 1;
                next_state = compute;
            end

            compute: begin
                I         = row;
                k         = k_reg;
                J_b1      = base_j;
                J_b2      = base_j+1;
                J_b3      = base_j+2;
                J_b4      = base_j+3;

                if(k_reg<k_tiles-1) begin
                    next_k_reg = k_reg+1;
                    next_state = compute;
                end
                else if(valid_1 && valid_2 && valid_3 && valid_4) begin
                    next_state=drain;
                end
            end

            drain: begin
                idle_core=1;
                next_state=store;
                next_row=row;
                next_base_j=base_j+4;
            end

            store: begin
                wb_en     = 1'b1;
                k         = 0;
                if(base_j<=J_tiles-1) begin
                    I = row;
                    wb_I1     = row;
                    wb_J1     = base_j-4;

                    wb_I2     = row;
                    wb_J2     = base_j-3;

                    wb_I3     = row;
                    wb_J3     = base_j-2;                    

                    wb_I4     = row;
                    wb_J4     = base_j-1; 

                    J_b1      = base_j;
                    

                    J_b2      = base_j+1;


                    J_b3      = base_j+2;


                    J_b4      = base_j+3;
                end
                else if(base_j>J_tiles-1) begin
                    I = row+1;
                    next_base_j=0;
                    wb_I1     = row;
                    wb_J1     = J_tiles-4;

                    wb_I2     = row;
                    wb_J2     = J_tiles-3;

                    wb_I3     = row;
                    wb_J3     = J_tiles-2;                    

                    wb_I4     = row;
                    wb_J4     = J_tiles-1;
                    J_b1      = 0;
                    

                    J_b2      = 1;


                    J_b3      = 2;


                    J_b4      = 3;
                end           

                clr_C      = 1'b1;
                next_k_reg = 1;

                if(row < I_tiles) begin
                    next_state = compute;

                    if(base_j<=J_tiles-1) begin
                        next_row = row;
                    end
                    else if(base_j>J_tiles-1) begin
                        next_row        = row+1;
                    end
                end
                else begin
                    done=1;
                    next_state=dn;
                end
            end

            dn: begin
                idle_core=1;
                next_state=idle;
            end
        endcase
    end
endmodule