module receiver_domain (
    input  wire       clk_b,
    input  wire       rstn,
    input  wire       req_sync,
    input  wire [7:0] data_in,
    output reg        ack,
    output reg [7:0]  data_out
);

always @(posedge clk_b or negedge rstn) begin
    if(!rstn) begin
        ack      <= 0;
        data_out <= 0;
    end
    else begin
        if(req_sync && !ack) begin
            data_out <= data_in;
            ack      <= 1;
        end
        else if(!req_sync) begin
            ack <= 0;
        end
    end
end

endmodule
