module mux_synchronizer #(
    parameter WIDTH = 8
)(
    input  wire                 clka,
    input  wire                 clkb,
    input  wire                 en,        // enable from CLKA domain
    input  wire [WIDTH-1:0]     data_in,   // multi-bit data
    output reg  [WIDTH-1:0]     data_out   // synchronized output
);

reg fa;
reg fb0;
reg fb1;

wire [WIDTH-1:0] d1;

//////////////////////////////////////////////////////
// CLKA DOMAIN
//////////////////////////////////////////////////////

always @(posedge clka)
begin
    fa <= en;
end

//////////////////////////////////////////////////////
// CLKB DOMAIN (synchronizer)
//////////////////////////////////////////////////////

always @(posedge clkb)
begin
    fb0 <= fa;
    fb1 <= fb0;
end

//////////////////////////////////////////////////////
// MUX LOGIC
//////////////////////////////////////////////////////

assign d1 = fb1 ? data_in : data_out;

//////////////////////////////////////////////////////
// DESTINATION REGISTER
//////////////////////////////////////////////////////

always @(posedge clkb)
begin
    data_out <= d1;
end

endmodule
