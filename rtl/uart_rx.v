module uart_rx(
    input clk,
    input reset,
    input tick,
    input rx,
    output reg [7:0] data_out,
    output reg rx_done
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_count;

always @(posedge clk)
begin
    if (reset)
    begin
        state     <= IDLE;
        data_out  <= 8'b0;
        rx_done   <= 1'b0;
        shift_reg <= 8'b0;
        bit_count <= 3'b0;
    end
    else
    begin
        case (state)

        // Wait for line to go low (start bit)
        IDLE: begin
            rx_done <= 1'b0;
            if (rx == 1'b0) begin
                bit_count <= 3'b0;
                state     <= START;
            end
        end

        // Confirm start bit, wait one tick to move into data bits
        START: begin
            if (tick) begin
                state <= DATA;
            end
        end

        // Shift in 8 data bits, LSB first
        DATA: begin
            if (tick) begin
                shift_reg <= {rx, shift_reg[7:1]};  // shift right, new bit at MSB position
                bit_count <= bit_count + 1'b1;
                if (bit_count == 3'd7) begin
                    state <= STOP;
                end
            end
        end

        // Check stop bit, latch received byte
        STOP: begin
            if (tick) begin
                data_out <= shift_reg;
                rx_done  <= 1'b1;
                state    <= IDLE;
            end
        end

        endcase
    end
end

endmodule
