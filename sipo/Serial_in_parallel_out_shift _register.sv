// NAME: Shaista Rasool Cheema 
///////////////////////////////
// PPROJECT: Serial in parallel out shift register 
///////////////////////////////////////////////////

module SIPO( input clock,
             input clear,
            input data_in,
            output reg [3:0]out);
reg[3:0] temp; // temporary  register of same size of out 3 bit reg means  temp0, temp1, temp2 temp3 it can store 4 bit of data 
  always @(posedge clock )
    if (clear==1)
      out=4'b0000;
  else 
    begin 
       temp=1>>out;
       out={data_in,temp[2:0]}; 
    end 
endmodule 
//testbentch 
// Code your testbench here
module SIPO_tb;
  //inputs
  reg clk ;
   reg clr ;
   reg Data_in;
  //instantate 
  SIPO uut (.clock(clk),
             .clear(clr),
             .data_in(Data_in));
            initial 
              begin 
                // initialize input 
                clk=5;
                clr=1;
               Data_in=0;
                #10 clr=1'b0;
              end 
            always #1 clk=~clk;
            always #1 Data_in=~Data_in;
            initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #230
    $finish;
end
endmodule 
            