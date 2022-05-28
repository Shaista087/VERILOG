// PROJECT: Design and verify a register file integrated with ALU module
////////////////////////////////////////////////////////////////////////
// NAME: SHAISTA RASOOL CHEEMA 
///////////////////////////////
module  pro_unit(input  [3:0]  alu_op,
                       input clk,
                       input clr,
                       input [4:0] readreg1,
                       input [4:0] readreg2,
                       input [4:0] writereg,
                       input wr_op,
                       input [31:0] data_in,
                       output [31:0] sig1,
                       output [31:0] sig2,
                       output reg [63:0] out);

// instantiation  ALU File

alu alu_inst(.alu_op(alu_op),
             .A(sig1),
             .B(sig2),
             .out(out));
  
// instantiation of  Reg File
             
register reg_inst(.clk(clk),
                  .clr(clr),
                  .readreg1(readreg1),
                  .readreg2(readreg2),
                  .writereg(writereg),
                  .wr_op(wr_op),
                  .data_in(data_in),
                  .read1(sig1),
                  .read2(sig2));
 
endmodule



module register(input clk,
                input clr,
                input [4:0] readreg1,
                input [4:0] readreg2,
                input [4:0] writereg,
                input wr_op,
                input [31:0] data_in,
                output reg [31:0] read1,
                output reg [31:0] read2);
// 32 bits addressable  memory of this register file
reg [31:0] register_memory [32];   
//  to clear the data   
  always @ (negedge clk) begin
    
  if (clr) begin
      read1 <= 0;
      read2 <= 0;
    for (int i=0; i<32;i++)
      register_memory [i] <=0; 
  end

  else begin
    
    if (wr_op) begin     // ifwr_op==1 then write data in memory 
         
     register_memory [writereg] <= data_in;

  end 
end
end

always @ (*) begin

read1 <= register_memory [readreg1];  
read2 <= register_memory [readreg2];  

end
endmodule


// ALU FiLE
// Two inputs A and B and one output is out
// ALU operation is base on alu_op

 
module alu(input [3:0] alu_op,
           input [31:0] A,
           input [31:0] B,
           output reg [63:0] out) ;
 always @(*)
    begin
 case(alu_op)
        4'b0000: // Addition
            out = A + B ; 
        4'b0001: // Subtraction
            out = A - B ;
        4'b0010: // Multiplication
           out = A * B;
        4'b0011: // Division
           out = A/B;
        4'b0100: // Logical shift left
           out = A<<1;
         4'b0101: // Logical shift right
            out = A>>1;
         4'b0110: // Rotate left
            out = {A[6:0],A[7]};
         4'b0111: // Rotate right
            out = {A[0],A[7:1]};
          4'b1000: //  Logical and 
           out = A & B;
          4'b101: //  Logical or
            out = A | B;
          4'b1010: //  Logical xor 
            out = A ^ B;
          4'b1011: //  Logical nor
            out = ~(A | B);
          4'b1100: // Logical nand 
            out = ~(A & B);
          4'b1101: // Logical xnor
           out = ~(A ^ B);
          4'b1110: // Greater comparison
            out= (A>B)?8'd1:8'd0 ;
          4'b1111: // Equal comparison   
             out = (A==B)?8'd1:8'd0 ;
          default:  out = A + B ; 
        endcase
        end

 endmodule

///////////////////////////////////////////////////////////////////
//TESTBENTCH
//////////////////////////////////////////////////////////////////
module pro_unit_tb();
 reg [3:0]alu_op;
reg clk;
reg clr;
reg [4:0] readreg1;
reg [4:0] readreg2;
reg [4:0] writereg;
reg wr_op;
reg [31:0] data_in;
wire [31:0] sig1;
wire [31:0] sig2;
wire [63:0] out;
pro_unit dut(.alu_op(alu_op),
                    .clk(clk),
                    .clr(clr),
                    .readreg1(readreg1),
                    .readreg2(readreg2),
                    .writereg(writereg),
                    .wr_op(wr_op),
                    .data_in(data_in),
                    .sig1(sig1),
                    .sig2(sig2),
                    .out(out));
// clock generation
always #5 clk = ~clk ;
initial begin
    data_in=0;             
    clk = 0;
    clr <= 1;  // reset  memory 
    #15  
    clr <= 0;  // reset =0 to change data_in
for (int i=0; i<32; i++) @ (posedge clk) begin
    writereg = i;
    readreg1 = i;
    readreg2 = i;
    wr_op  = 1;
    data_in = 64+i;
    alu_op  = $random;
end
end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #230
    $finish;
end  
endmodule
