
module tb_top;
   
   //////////////////////////////////////////////////////
   // DUMPWAVE
   //////////////////////////////////////////////////////
   `ifdef USE_FSDB
   initial begin
      if($test$plusargs("FSDB")) begin//+FSDB to enable
         $fsdbDumpfile("wave.fsdb");
         // $fsdbDumpvars(depth, instance);
         $fsdbDumpvars();
      end
   end
   `endif
 
   //////////////////////////////////////////////////////
   // TIMEOUT
   //////////////////////////////////////////////////////
   integer timeout;
   initial begin
      if(!$value$plusargs("TO=%d",timeout)) begin//+TO=XXXX to overwrite
         timeout = 1000;//default
      end
      #timeout;
      $display("******************"); 
      $display("simulation timeout"); 
      $display("******************"); 
      $finish;
   end 

   //////////////////////////////////////////////////////
   // CLK RESET  
   //////////////////////////////////////////////////////
   reg clk  ;
   reg rst_n;

   initial begin
      clk = 1'b1;
      forever begin
         #(500.0/200.0) clk = ~clk;
      end
   end
   initial begin
      rst_n = 1'b1;
      #7;
      rst_n = 1'b0;
      #7;
      rst_n = 1'b1;
   end

   
   //////////////////////////////////////////////////////
   // DUT
   //////////////////////////////////////////////////////
   reg   [3:0] op_in;
   reg   [7:0] a_in;
   reg   [7:0] b_in;
   wire  [7:0] result_out;
   wire        ovflow_out;
   
   alu I_ALU(
   .op_in      (op_in),
   .a_in       (a_in),
   .b_in       (b_in),
   .result_out (result_out),
   .ovflow_out (ovflow_out)
   );
   
   //////////////////////////////////////////////////////
   // TEST PATTERN
   //////////////////////////////////////////////////////


   ////////////////////
   //driver
   //initial begin
   //end
   initial begin

      $display("              op_in  a_in  result_out  ovflow_out  b_in");

      // initialize input
      op_in = 4'b0000;
      a_in  = 8'b0000_0000;
      b_in  = 8'b0000_0000;
      // test 0/1/2/4/5
      #10;
      a_in  = 8'b0001_0111;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b0001;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b0010;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b0100;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b0101;
      // test 3
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b0011;
      a_in  = 8'b1001_0111;
      // test 6/7/8/9/10/11
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      a_in  = 8'b0001_0111;
      b_in  = 8'b1010_1010;
      op_in = 4'b0110;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b0111;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b1000;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b1001;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b1010;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b1011;
      // test 12
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b1100;
      a_in  = 8'b1111_1111;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      a_in  = 8'b0111_1111;
      // test 13
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b1101;
      a_in  = 8'b0000_0000;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      a_in  = 8'b1000_0000;
      // test 14
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b1110;
      a_in  = 8'b1111_1001;
      b_in  = 8'b0000_0111;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      a_in  = 8'b0111_1111;
      b_in  = 8'b0000_0001;
      // test 15
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      op_in = 4'b1111;
      a_in  = 8'b1111_1001;
      b_in  = 8'b0000_0111;
      #10;
      test00(op_in, a_in, b_in, result_out, ovflow_out);
      a_in  = 8'b1000_0000;
      b_in  = 8'b0000_0001;
   end
   ////////////////////
   //in monitor
   //initial begin
   //end 

   ////////////////////
   //out monitor
   //initial begin
   //end 

   ////////////////////
   //model
   //initial begin
   //end 

   ////////////////////
   //check data
   ////////////////////
   /*
   initial begin
      $display("******************"); 
      $display("simulation pass   "); 
      $display("******************"); 
      $display("******************"); 
      $display("simulation fail   "); 
      $display("******************"); 
   end
   */
   
   task test00;

   input   [3:0] op;
   input   [7:0] a;
   input   [7:0] b;
   input   [7:0] result;
   input         ovflow;

      begin
         if (
               (op_in === 4'b0000 && a_in === 8'b0001_0111 && result === 8'b0010_1110 && ovflow === 1'b0) ||  
               (op_in === 4'b0001 && a_in === 8'b0001_0111 && result === 8'b0000_1011 && ovflow === 1'b0) ||
               (op_in === 4'b0010 && a_in === 8'b0001_0111 && result === 8'b0010_1110 && ovflow === 1'b0) ||
               (op_in === 4'b0011 && a_in === 8'b1001_0111 && result === 8'b1100_1011 && ovflow === 1'b0) ||
               (op_in === 4'b0100 && a_in === 8'b0001_0111 && result === 8'b0010_1110 && ovflow === 1'b0) ||
               (op_in === 4'b0101 && a_in === 8'b0001_0111 && result === 8'b1000_1011 && ovflow === 1'b0) ||
               (op_in === 4'b0110 && a_in === 8'b0001_0111 && result === 8'b0000_0010 && ovflow === 1'b0 && b_in === 8'b1010_1010) ||
               (op_in === 4'b0111 && a_in === 8'b0001_0111 && result === 8'b1011_1111 && ovflow === 1'b0 && b_in === 8'b1010_1010) ||
               (op_in === 4'b1000 && a_in === 8'b0001_0111 && result === 8'b1011_1101 && ovflow === 1'b0 && b_in === 8'b1010_1010) ||
               (op_in === 4'b1001 && a_in === 8'b0001_0111 && result === 8'b1111_1101 && ovflow === 1'b0 && b_in === 8'b1010_1010) ||
               (op_in === 4'b1010 && a_in === 8'b0001_0111 && result === 8'b0100_0000 && ovflow === 1'b0 && b_in === 8'b1010_1010) ||
               (op_in === 4'b1011 && a_in === 8'b0001_0111 && result === 8'b0100_0010 && ovflow === 1'b0 && b_in === 8'b1010_1010) ||
               (op_in === 4'b1100 && a_in === 8'b1111_1111 && result === 8'b0000_0000 && ovflow === 1'b0) ||
               (op_in === 4'b1100 && a_in === 8'b0111_1111 && result === 8'b1000_0000 && ovflow === 1'b1) ||
               (op_in === 4'b1101 && a_in === 8'b0000_0000 && result === 8'b1111_1111 && ovflow === 1'b0) ||
               (op_in === 4'b1101 && a_in === 8'b1000_0000 && result === 8'b0111_1111 && ovflow === 1'b1) ||
               (op_in === 4'b1110 && a_in === 8'b1111_1001 && result === 8'b0000_0000 && ovflow === 1'b0 && b_in === 8'b0000_0111) ||
               (op_in === 4'b1110 && a_in === 8'b0111_1111 && result === 8'b1000_0000 && ovflow === 1'b1 && b_in === 8'b0000_0001) ||
               (op_in === 4'b1111 && a_in === 8'b1111_1001 && result === 8'b1111_0010 && ovflow === 1'b0 && b_in === 8'b0000_0111) ||
               (op_in === 4'b1111 && a_in === 8'b1000_0000 && result === 8'b0111_1111 && ovflow === 1'b1 && b_in === 8'b0000_0001) 
            ) begin
            $display("test00 pass   %4b  %8b  %8b  %1b  %8b",op_in, a_in, result, ovflow, b_in);
         end
         else begin
            $display("test00 fail   %4b  %8b  %8b  %1b  %8b",op_in, a_in, result, ovflow, b_in);
         end
      end
   endtask



endmodule

