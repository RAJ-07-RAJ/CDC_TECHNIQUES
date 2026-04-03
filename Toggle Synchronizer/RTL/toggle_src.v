
module toggle_src (
    input  wire clkA,
    input  wire rst,
    input  wire pulse_in,
    output reg  toggle
);

always @(posedge clkA or posedge rst) begin
    if (rst)
        toggle <= 1'b0;
    else if (pulse_in)
        toggle <= ~toggle;   // toggle on every event
end

endmodule
