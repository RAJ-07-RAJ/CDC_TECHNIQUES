module handshake_cdc_top(

    input  wire       clk_a,
    input  wire       clk_b,
    input  wire       rstn,

    input  wire       send,
    input  wire [7:0] data_in,

    output wire [7:0] data_out
);

wire req;
wire ack;

wire req_sync;
wire ack_sync;

wire [7:0] data_reg;

/* Sender */

sender_domain sender (
    .clk_a(clk_a),
    .rstn(rstn),
    .send(send),
    .data_in(data_in),
    .ack_sync(ack_sync),
    .req(req),
    .data_reg(data_reg)
);

/* Synchronize REQ into CLK_B */

sync_2ff req_sync_block (
    .clk(clk_b),
    .rstn(rstn),
    .din(req),
    .dout(req_sync)
);

/* Receiver */

receiver_domain receiver (
    .clk_b(clk_b),
    .rstn(rstn),
    .req_sync(req_sync),
    .data_in(data_reg),
    .ack(ack),
    .data_out(data_out)
);

/* Synchronize ACK back into CLK_A */

sync_2ff ack_sync_block (
    .clk(clk_a),
    .rstn(rstn),
    .din(ack),
    .dout(ack_sync)
);

endmodule
