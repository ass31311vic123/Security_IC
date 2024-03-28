module mult2#(
   //parameter declaration
   parameter WIDTH = 8
   )(
   //port declaration
   input                    start_p,
   input      [WIDTH  -1:0] a    ,//input a
   input      [WIDTH  -1:0] b    ,//input b
   output reg               busy ,//mult2 is busy
   output reg [WIDTH*2-1:0] o    ,//output o=a*b
   input                    clk  ,
   input                    rst_n
   );
   
   ////internal signal declaration
   wire [WIDTH*2-1:0]no;//next_o, next value of o
   always@(posedge clk or negedge rst_n)begin
      if(!rst_n)        busy <= 1'b0;
      else if(start_p)  busy <= 1'b1;
      else if(busy)     busy <= 1'b0;
   end 
   
   assign no = {8'b0,a}*{8'b0,b};
   always@(posedge clk or negedge rst_n)begin
      if(!rst_n)     o <= {WIDTH*2{1'b0}};
      else if(busy)  o <= no;
   end 

endmodule //end of this module


