module tb_handshake_cdc;

reg clk_a;
reg clk_b;
reg rstn;
reg send;
reg [7:0] data_in;

wire [7:0] data_out;

/* Instantiate DUT */

handshake_cdc_top dut(
    .clk_a(clk_a),
    .clk_b(clk_b),
    .rstn(rstn),
    .send(send),
    .data_in(data_in),
    .data_out(data_out)
);

/* Clock A */

initial clk_a = 0;
always #5 clk_a = ~clk_a;

/* Clock B */

initial clk_b = 0;
always #7 clk_b = ~clk_b;

/* Stimulus */

initial begin

rstn = 0;
send = 0;
data_in = 0;

#20 rstn = 1;

#20
data_in = 8'hA5;
send = 1;

#10
send = 0;

#300
//#100

data_in = 8'h3C;
send = 1;

#10
send = 0;



end

endmodule
