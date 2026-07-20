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
    if(reset)
    begin
        state     <= IDLE;
        data_out  <= 8'b0;
        rx_done   <= 1'b0;
        shift_reg <= 8'b0;
        bit_count <= 3'b0;
    end

    else
    begin
        case(state)

        // Wait for start bit
        IDLE:
        begin
            rx_done <= 1'b0;

            if(rx == 1'b0)
            begin
                bit_count <= 3'd0;
                state <= START;
            end
        end


        // Confirm start bit
        START:
        begin
            if(tick)
            begin
                state <= DATA;
            end
        end


        // Receive 8-bit data (LSB first)
        DATA:
        begin
            if(tick)
            begin
                shift_reg[bit_count] <= rx;

                if(bit_count == 3'd7)
                begin
                    state <= STOP;
                end

                else
                begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end


        // Receive stop bit
        STOP:
        begin
            if(tick)
            begin
                data_out <= shift_reg;
                rx_done <= 1'b1;
                state <= IDLE;
            end
        end


        default:
            state <= IDLE;

        endcase
    end

end

endmodule
