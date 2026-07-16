`timescale 1ns/1ps

module uart_tx_tb;

// Inputs
reg clk;
reg reset;
reg tick;
reg tx_start;
reg [7:0] data_in;

// Outputs
wire tx;
wire tx_done;

// Instantiate UART Transmitter
uart_tx uut (
    .clk(clk),
    .reset(reset),
    .tick(tick),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .tx_done(tx_done)
);

// Clock Generation (100 MHz)
always #5 clk = ~clk;

// Tick Generation (for simulation only)
always #20 tick = ~tick;

// Test Sequence
initial
begin
    clk = 0;
    reset = 1;
    tick = 0;
    tx_start = 0;
    data_in = 8'h00;

    // Hold reset
    #20;
    reset = 0;

    // Send one byte
    #20;
    data_in = 8'hA5;
    tx_start = 1;

    #10;
    tx_start = 0;

    // Wait long enough for transmission
    #500;

    $finish;
end

endmodule
