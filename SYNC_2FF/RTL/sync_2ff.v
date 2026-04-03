module sync_2ff (
    input  wire clk_b,
    input  wire rst_n,
    input  wire async_in,
    output reg  sync_out
);

reg sync_ff1;

always @(posedge clk_b or negedge rst_n)
begin
    if(!rst_n)
    begin
        sync_ff1 <= 0;
        sync_out <= 0;
    end
    else
    begin
        sync_ff1 <= async_in;
        sync_out <= sync_ff1;
    end
end
