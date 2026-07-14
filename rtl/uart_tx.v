module uart_tx(
    input clk,
    input reset,

    input tick,
    input tx_start,
    input [7:0] data_in,

    output reg tx,
    output reg tx_done
);


// FSM states

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;


// Internal registers

reg [1:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_count;


// FSM

always @(posedge clk)
begin

    if(reset)
    begin
        state <= IDLE;
        tx <= 1'b1;
        tx_done <= 1'b0;
        shift_reg <= 8'b0;
        bit_count <= 3'b0;
    end


    else
    begin

        case(state)


        // -------------------
        // IDLE STATE
        // -------------------
        IDLE:
        begin
            tx <= 1'b1;
            tx_done <= 1'b0;

            if(tx_start)
            begin
                shift_reg <= data_in;
                bit_count <= 3'b0;
                state <= START;
            end

        end



        // -------------------
        // START BIT
        // -------------------
        START:
        begin
            tx <= 1'b0;

            if(tick)
            begin
                state <= DATA;
            end

        end



        // -------------------
        // DATA BITS
        // -------------------
        DATA:
        begin
            tx <= shift_reg[0];

            if(tick)
            begin
                shift_reg <= shift_reg >> 1;
                bit_count <= bit_count + 1'b1;

                if(bit_count == 3'd7)
                begin
                    state <= STOP;
                end
            end

        end



        // -------------------
        // STOP BIT
        // -------------------
        STOP:
        begin
            tx <= 1'b1;

            if(tick)
            begin
                tx_done <= 1'b1;
                state <= IDLE;
            end

        end


        endcase

    end

end


endmodule
