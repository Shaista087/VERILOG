//UP_DOWN_COUNTER 
//SHAISTA RASOOL CHEEMA 
module upp(input wire clk,
               input wire rst,
               input wire enable,
               input wire count_load,
                  input wire up,
               input wire [3:0] load_value,
               output wire [3:0] count);
  reg [3:0] temp_cnt;
  always@(posedge clk)
    begin
      if(rst)
        temp_cnt <= 0;
      else if(count_load)
        temp_cnt <= load_value;
      else if(enable & up  )
        temp_cnt <= temp_cnt + 1; 
      else if(enable  & ~up  ) 
        temp_cnt <= temp_cnt - 1; 
      else 
        temp_cnt <= temp_cnt;
    end 
          
endmodule
//testbentch
// Code your testbench here
// or browse Examples
module tst_updown();
  reg  clk;
  reg  rst;
  reg enable ;
 reg count_load;
  reg up ;
  reg [3:0] load_value ;
  wire [3:0] count;
  upp updown(.*); 
  
initial 
  begin
  clk=0;
  forever #2 clk = ~clk;  
end 
 initial
 begin 
rst<=0;
 enable <=1;
 count_load<=1;
 load_value<= 4'b001 ; 
 #5;
 rst<=0;
 enable <=0;
 count_load<=1;
 load_value<= 4'b001;  
#5;
rst<=0;
enable <=1;
count_load<=0;
load_value<= 4'b001 ; 
 #5;
 rst<=0;
end 
   initial 
    begin
 $dumpfile("dff.vcd");
 $dumpvars();
      #100;
 end
endmodule











