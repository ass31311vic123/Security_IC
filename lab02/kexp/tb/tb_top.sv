
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
         timeout = 1000000;//default
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
   
   event rst_start;
   event rst_done;

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
      -> rst_start;
      #7;
      rst_n = 1'b1;
      -> rst_done;
   end

   
   //////////////////////////////////////////////////////
   // DUT
   //////////////////////////////////////////////////////
   reg          key_ld_p;
   reg  [127:0] key     ;
   reg          enc     ;
   wire         rk_vld  ;
   wire [127:0] rk      ;
   reg          rk_rdy  ;
   
   kexp I_KEXP(
      .key_ld_p(key_ld_p),
      .key     (key     ),
      .enc     (enc     ),
      .rk_vld  (rk_vld  ),
      .rk      (rk      ),
      .rk_rdy  (rk_rdy  ),
      .clk     (clk     ),
      .rst_n   (rst_n   ) 
   );
   
   //////////////////////////////////////////////////////
   // TEST PATTERN
   //////////////////////////////////////////////////////

   ////////////////////
   //driver
   //initial begin
   //end 

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
   initial begin
      $display("******************"); 
      $display("simulation pass   "); 
      $display("******************"); 
      $display("******************"); 
      $display("simulation fail   "); 
      $display("******************"); 
   end 
   

endmodule

