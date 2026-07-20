
module baud_generator #(
    parameter DIVISOR = 5208
)(
    input clk,
    input reset,
    output reg tick
);

reg [12:0] counter;

always @(posedge clk)
begin
    if (reset)
    begin
        counter <= 13'd0;
        tick <= 1'b0;
    end
    else
    begin
        if (counter == DIVISOR - 1)
        begin
            counter <= 13'd0;
            tick <= 1'b1;
        end
        else
        begin
            counter <= counter + 1'b1;
            tick <= 1'b0;
        end
    end
end

endmodule// New file
