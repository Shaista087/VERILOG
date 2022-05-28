// NAME: Shaista Rasool Cheema 
///////////////////////////////
// PPROJECT: parallel_in_parallel_out shift register 
///////////////////////////////////////////////////

module PIPO( input clock,
             input clear,
            input  [3:0]data_in,
            output reg [3:0]out);

  always @(posedge clock )
    if (clear==1)
      out=4'b0000;
  else 
    out=data_in;
endmodule 
// Code your testbench here

module PIPO_tb;
  //inputs
  reg clk ;
   reg clr ;
   reg [3:0]Data_in;
  //instantate 
  PIPO uut (.clock(clk),
             .clear(clr),
             .data_in(Data_in));
            initial 
              begin 
                // initialize input 
                clk=0;
                clr=1;
               Data_in=4'b1010;
                #5 clr=0;
                #2 Data_in=4'b0000;
                #2 Data_in=4'b0011;
                #2 Data_in=4'b1011;
                 #10 clr=1;
                #3 Data_in=4'b1000;
                #3 Data_in=4'b1011;
                #3 Data_in=4'b1111;
              end 
  always #1clk=~clk;
           
            initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #230
    $finish;
end
endmodule 
            