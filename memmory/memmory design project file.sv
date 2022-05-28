//PROJECT: RTL Design of a parameterized memory with interface having modports, verified by a task/function based testbench
//NAME: SHAISTA RASOOL CHEEMA
//MAIN FILE  
`include "interface.sv"
module memory( my_memory inst); //my_memory come from interface file 
  
  
  //declear register 
  reg [`size_of_location-1:0]mem_reg[`no_of_locations-1:0];
  
  
  // using interface modport intentiate  inst.dut.portname
  always @(negedge  inst.dut.clk) begin 
      if(inst.dut.reset)begin 
         inst.dut.data_out<=0;
          for(int i=0; i< `no_of_locations; i++)
            mem_reg[i]<=0;
        end
      else begin 
        if( inst.dut.op)begin        // write operation 
              mem_reg[inst.dut.adress_reg] <= inst.dut.data_in;
            end  
          else  begin            // read opeartion 
              inst.dut.data_out <= mem_reg[inst.dut.adress_reg];
            end
            end
             end
endmodule
              
			  ////////////////////////////////////////////////////////////////// END OF FIRST FILE 
			  //INTERFACE.SV FILE DATA 
			 // add the file of macros of memory  
`include "include.sv"
// creat interface module
interface my_memory(input logic clk);
  logic reset;
  logic op;
  logic [$clog2(`no_of_locations)-1:0] adress_reg;
  logic [`size_of_location-1:0] data_in; 
  logic [`size_of_location-1:0] data_out;
  // modport to connect with design block 
  
  modport dut(input reset, op,clk, adress_reg ,data_in, output data_out);
  // modport to connect with test_bench 
  
  
  modport tb(output  reset, op, clk,  adress_reg ,data_in, input data_out);
endinterface
////////////////////////////////////////////////////////////////////////////// END OF SECOND 
//INCLUDE FILE.SV
//macros( size and no of locations ) of memmory 
`define size_of_location  16
`define no_of_locations  16
/////////////////////////////////////////////////////////////////////////////
//TESTBENTCH CODE
module  tb_top(); 
  bit clock;
  always #5  clock=~ clock;
  
  // interface object 
    my_memory inst(clock);
  
    //instantiate the tb  pass  modport tb of my_memory 
    memory dut0(inst); 
  
   //declear rest  function
  function  op_rst;
    input clear;
    begin 
      op_rst=clear; 
    end 
  endfunction 
  
    
    
    // declear write 
    task write; 
      repeat(20)@(posedge  clock) begin 
          inst.tb.op=1; 
          inst.tb.adress_reg= $random;
          inst.tb.data_in= $random;
        end 
    endtask
     // declear read 
    task read; 
      repeat(20)@(posedge  clock) 
        begin 
          inst.tb.op=0; 
          inst.tb.adress_reg= $random;
          inst.tb.data_in= $random;
        end 
    endtask
    // calling task and function reset ,write, read ,
    initial begin 
        inst.tb.reset=op_rst(1);
        #15 
        inst.tb.reset=op_rst(0);
        write();
        read();
      end 
    initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #400 $finish;
end
    endmodule

        











