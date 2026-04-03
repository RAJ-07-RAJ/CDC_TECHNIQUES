module sender_domain (
    input  wire       clk_a,
    input  wire       rstn,
    input  wire       send,
    input  wire [7:0] data_in,
    input  wire       ack_sync,
    output reg        req,
    output reg [7:0]  data_reg
);

always @(posedge clk_a or negedge rstn) begin
    if(!rstn) begin
        req      <= 0;
        data_reg <= 0;
    end
    else begin
        if(send && !req) begin
            data_reg <= data_in;
            req      <= 1;
        end
        else if(ack_sync) begin
            req <= 0;
        end
    end
end
