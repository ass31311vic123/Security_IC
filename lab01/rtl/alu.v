module alu(
   input    [3:0]    op_in,
   input    [7:0]    a_in,
   input    [7:0]    b_in,
   output   [7:0]    result_out,
   output            ovflow_out
//All lines above cannot be modified !!
);

   reg [7:0]result_temp;
   reg ovflow;

   assign result_out = result_temp;
   assign ovflow_out = ovflow;

   always@* begin

      case(op_in)
         4'b0000: begin // Logic shift left 1-bit
            result_temp = a_in << 1; 
            ovflow = 1'b0;
         end
         4'b0001: begin // Logic shift right 1-bit
            result_temp = a_in >> 1; 
            ovflow = 1'b0;
         end
         4'b0010: begin // arithmetric shift left 1-bit
            //result_out = {a_in[6:0], 1'd0};
            result_temp = a_in <<< 1; 
            ovflow = 1'b0;
         end
         4'b0011: begin // arithmetric shift right 1-bit 
            result_temp = {a_in[7], a_in[7:1]}; 
            //result_temp = a_in >>> 1; 
            ovflow = 1'b0;
         end
         4'b0100: begin // Circular shift a_in left by 1-bit
            result_temp = {a_in[6:0], a_in[7]}; 
            ovflow = 1'b0;
         end
         4'b0101: begin // Circular shift a_in right by 1-bit
            result_temp = {a_in[0], a_in[7:1]}; 
            ovflow = 1'b0;
         end
         4'b0110: begin // AND of a_in and b_in
            result_temp = a_in & b_in; 
            ovflow = 1'b0;
         end
         4'b0111: begin // OR of a_in and b_in
            result_temp = a_in | b_in; 
            ovflow = 1'b0;
         end
         4'b1000: begin // XOR of a_in and b_in
            result_temp = a_in ^ b_in; 
            ovflow = 1'b0;
         end
         4'b1001: begin // NAND of a_in and b_in
            result_temp = ~(a_in & b_in); 
            ovflow = 1'b0;
         end
         4'b1010: begin // NOR of a_in and b_in
            result_temp = ~(a_in | b_in); 
            ovflow = 1'b0;
         end
         4'b1011: begin // XNOR of a_in and b_in
            result_temp = a_in ~^ b_in; 
            ovflow = 1'b0;
         end
         4'b1100: begin // Increment a_in
            result_temp = a_in + 8'd1; 
            ovflow = (a_in == 8'b0111_1111)? 1'b1 : 1'b0;
         end
         4'b1101: begin // Decrement a_in
            result_temp = a_in - 8'd1; 
            ovflow = (a_in == 8'b1000_0000)? 1'b1 : 1'b0;
         end
         4'b1110: begin // a_in add b_in
            result_temp = a_in + b_in; 
            ovflow =  ((a_in[7] ^ b_in[7]) == 1'b1)? 1'b0 : 1'b1;
         end
         4'b1111: begin // a_in subtract b_in
            result_temp = a_in - b_in; 
            if ( (a_in[7] == 1'b0) && (b_in[7] == 1'b1) && (result_temp[7] == 1'b1))
               ovflow = 1'b1;
            else if ( (a_in[7] == 1'b1) && (b_in[7] == 1'b0) && (result_temp[7] == 1'b0))
               ovflow = 1'b1;
            else
               ovflow = 1'b0;
         end
         /*
         default: begin
            result_temp = a_in << 1; 
            ovflow = 1'b0;
         end
         */
      endcase

   end

endmodule
