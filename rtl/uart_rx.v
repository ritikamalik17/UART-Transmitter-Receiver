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
reg [3:0] tick_count;

always @(posedge clk) begin
    if(reset) begin
        state      <= IDLE;
        data_out   <= 8'b0;
        rx_done    <= 1'b0;
        shift_reg  <= 8'b0;
        bit_count  <= 3'b0;
        tick_count <= 4'b0;
    end else begin
        case(state)
        IDLE: begin
            rx_done    <= 1'b0;
            tick_count <= 4'd0;
            if(rx == 1'b0) begin
                bit_count <= 3'd0;
                state     <= START;
            end
        end

        START: begin
            if(tick) begin
                if(tick_count == 4'd7) begin
                    tick_count <= 4'd0;
                    state      <= DATA;
                end else begin
                    tick_count <= tick_count + 1'b1;
                end
            end
        end

        DATA: begin
            if(tick) begin
                if(tick_count == 4'd15) begin
                    tick_count <= 4'd0;
                    shift_reg[bit_count] <= rx;
                    if(bit_count == 3'd7)
                        state <= STOP;
                    else
                        bit_count <= bit_count + 1'b1;
                end else begin
                    tick_count <= tick_count + 1'b1;
                end
            end
        end

        STOP: begin
            if(tick) begin
                if(tick_count == 4'd15) begin
                    data_out <= shift_reg;
                    rx_done  <= 1'b1;
                    state    <= IDLE;
                end else begin
                    tick_count <= tick_count + 1'b1;
                end
            end
        end

        default: state <= IDLE;
        endcase
    end
end

endmodule
