`timescale 1ns/1ps

module tb_toggle_synchronizer;

reg clkA;
reg clkB;
reg rst;
reg pulse_in;

wire pulse_out;

// DUT
toggle_synchronizer dut (
    .clkA(clkA),
    .clkB(clkB),
    .rst(rst),
    .pulse_in(pulse_in),
    .pulse_out(pulse_out)
);


// Clock A : 10ns period
always #5 clkA = ~clkA;

// Clock B : 14ns period (asynchronous to clkA)
always #7 clkB = ~clkB;


initial begin

    clkA = 0;
    clkB = 0;
    rst  = 1;
    pulse_in = 0;

    // reset
    #20;
    rst = 0;

    // first pulse
    #15 pulse_in = 1;
    #10 pulse_in = 0;

    // second pulse
    #40 pulse_in = 1;
    #10 pulse_in = 0;

    // third pulse
    #30 pulse_in = 1;
    #10 pulse_in = 0;

    // random pulse
    #50 pulse_in = 1;
    #10 pulse_in = 0;

    #100 $finish;

end

endmodule
