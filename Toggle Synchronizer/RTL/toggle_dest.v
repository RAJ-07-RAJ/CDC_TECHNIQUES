module toggle_dest (
    input  wire clkB,
    input  wire rst,
    input  wire toggle_async,
    output wire pulse_out
);

reg b1, b2, b3;

always @(posedge clkB or posedge rst) begin
    if (rst) begin
        b1 <= 0;
        b2 <= 0;
        b3 <= 0;
    end
    else begin
        b1 <= toggle_async;
        b2 <= b1;
        b3 <= b2;
    end
end

// edge detection
assign pulse_out = b2 ^ b3;

endmodule
