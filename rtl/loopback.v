module uart_loopback(
    input clk,
    input reset,
    input tx_start,
    input [7:0] data_in,
    output tx,
    output tx_done,
    output [7:0] rx_data,
    output rx_done
);

wire rx_signal;
wire tick;

assign rx_signal = tx;

baud_generator #(
    .DIVISOR(4)
) baud_gen (
    .clk(clk),
    .reset(reset),
    .tick(tick)
);

uart_tx transmitter(
    .clk(clk),
    .reset(reset),
    .tick(tick),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .tx_done(tx_done)
);

uart_rx receiver(
    .clk(clk),
    .reset(reset),
    .tick(tick),
    .rx(rx_signal),
    .data_out(rx_data),
    .rx_done(rx_done)
);

endmodule
