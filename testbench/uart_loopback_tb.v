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

// 100 MHz Clock (10 ns period)
always #5 clk = ~clk;


// Baud tick generation (simulation only)
// Generates a tick every 20 ns
always begin
    #20;
    tick = 1;
    #10;
    tick = 0;
end


// Test sequence
initial begin

    // Waveform file
    $dumpfile("uart_tx.vcd");
    $dumpvars(0, uart_tx_tb);

    // Initial values
    clk = 0;
    reset = 1;
    tick = 0;
    tx_start = 0;
    data_in = 8'h00;


    // Reset
    #20;
    reset = 0;


    // Transmit byte A5
    #20;
    data_in = 8'hA5;
    tx_start = 1;

    #10;
    tx_start = 0;


    // Wait for transmission
    wait(tx_done);

    #50;

    $display("UART Transmission Completed");
    $finish;

end


// Monitor signals
initial begin
    $monitor("Time=%0t | tx=%b | tx_done=%b | data=%h",
              $time, tx, tx_done, data_in);
end

endmodule
