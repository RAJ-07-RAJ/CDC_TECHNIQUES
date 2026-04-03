

`timescale 1ns/1ps

module tb_mux_synchronizer;

parameter WIDTH = 8;

reg clka;
reg clkb;
reg en;
reg [WIDTH-1:0] data_in;
wire [WIDTH-1:0] data_out;

//////////////////////////////////////////////////////
// DUT
//////////////////////////////////////////////////////

mux_synchronizer #(.WIDTH(WIDTH)) dut (
    .clka(clka),
    .clkb(clkb),
    .en(en),
    .data_in(data_in),
    .data_out(data_out)
);

//////////////////////////////////////////////////////
// CLOCK GENERATION
//////////////////////////////////////////////////////

// CLKA = 10ns period
initial
begin
    clka = 0;
    forever #5 clka = ~clka;
end

// CLKB = 14ns period (asynchronous to CLKA)
initial
begin
    clkb = 0;
    forever #7 clkb = ~clkb;
end

//////////////////////////////////////////////////////
// STIMULUS
//////////////////////////////////////////////////////

initial
begin

    en = 0;
    data_in = 0;

    #20;

    // first transfer
    @(posedge clka);
    data_in = 8'hA5;
    en = 1;

    repeat(5)@(posedge clka);
    en = 0;

    #100;

    // second transfer
    @(posedge clka);
    data_in = 8'h3C;
    en = 1;


 repeat(5) @(posedge clka);
    en = 0;

    #100;

    // third transfer
    @(posedge clka);
    data_in = 8'hF0;
    en = 1;


repeat(5)@(posedge clka);
    en = 0;

   #100;
   
  
    @(posedge clka);
    data_in = 8'hF7;
    en = 1;


  repeat(5) @(posedge clka);
    en = 0;

  //  $finish;

end

//////////////////////////////////////////////////////
// MONITOR
//////////////////////////////////////////////////////

initial
begin
    $monitor("TIME=%0t | EN=%b | DATA_IN=%h | DATA_OUT=%h",
              $time, en, data_in, data_out);
end

//////////////////////////////////////////////////////
// WAVEFORM DUMP
//////////////////////////////////////////////////////

//initial
//begin
//    $dumpfile("mux_sync.vcd");
//    $dumpvars(0,tb_mux_synchronizer);
//end

endmodule
