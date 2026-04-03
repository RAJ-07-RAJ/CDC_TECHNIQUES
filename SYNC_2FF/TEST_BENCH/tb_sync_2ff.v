`timescale 1ns/1ps

module tb_sync_2ff;

reg clk_a;
reg clk_b;
reg rst_n;
reg async_in;

wire sync_out;

//////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////

sync_2ff dut (
    .clk_b(clk_b),
    .rst_n(rst_n),
    .async_in(async_in),
    .sync_out(sync_out)
);

//////////////////////////////////////////////////
// CLOCK GENERATION
//////////////////////////////////////////////////

// clkA = 10ns
initial begin
    clk_a = 0;
    forever #5 clk_a = ~clk_a;
end

// clkB = 16ns
initial begin
    clk_b = 0;
    forever #8 clk_b = ~clk_b;
end

//////////////////////////////////////////////////
// STIMULUS
//////////////////////////////////////////////////

initial begin

    rst_n = 0;
    async_in = 0;

    #20;
    rst_n = 1;

    // generate async pulses
  
  
        @(posedge clk_a);
        async_in = 1;

       repeat(2) @(posedge clk_a);
        async_in = 0;

   
    #200;
  

end

//////////////////////////////////////////////////
// MONITOR
//////////////////////////////////////////////////

initial begin
    $monitor("TIME=%0t | ASYNC_IN=%b | SYNC_OUT=%b",
              $time, async_in, sync_out);
end

endmodule
