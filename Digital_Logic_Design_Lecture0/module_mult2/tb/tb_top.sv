
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
         #(5.0/2.0) clk = ~clk;
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
   parameter WIDTH = 5;
   reg               start_p;
   reg [WIDTH  -1:0] a;
   reg [WIDTH  -1:0] b;
   wire              busy;
   wire[WIDTH*2-1:0] o;

   mult2#(
      .WIDTH(WIDTH)
   )I_MULT2(
      .start_p(start_p ),
      .a      (a       ),
      .b      (b       ),
      .busy   (busy    ),
      .o      (o       ),
      .clk    (clk     ),
      .rst_n  (rst_n   )
   );

   
   //////////////////////////////////////////////////////
   // TEST PATTERN
   //////////////////////////////////////////////////////
   reg [WIDTH*2-1:0] gld_o[$];//golden answer of o; //[$] is systemverilog queue
   reg [WIDTH*2-1:0] dut_o[$];//dut output    of o; //[$] is systemverilog queue

   ////////////////////
   //drive test data
   initial begin
      
      ////////////////////
      //reset input signal
      @(negedge rst_n);
      start_p <= 1'b0;
      a       <= {WIDTH{1'b0}};
      b       <= {WIDTH{1'b0}};
      wait(rst_n);
      
      ////////////////////
      //start input signal
      repeat(3)begin
         @(posedge clk);
         @(posedge clk);
         start_p <= 1'b1;
         a       <= $random();
         b       <= $random();
         
         @(posedge clk);
         start_p <= 1'b0;
         
         while(1)begin
            @(posedge clk);
            if(!busy)
               break;//<<break is systemverilog syntax
         end 

      end

      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      $display("******************"); 
      $display("simulation pass   "); 
      $display("******************"); 
      $finish;
   end 
 

   ////////////////////
   //monitor data
   initial begin
      @(negedge rst_n);
      wait(rst_n);
      while(1)begin
         @(posedge clk);
         if(start_p)begin
            $display($realtime,,"input  a: 'd%d",a); 
            $display($realtime,,"input  b: 'd%d",b); 
            gld_o.push_back(a*b);
            $display($realtime,,"gld_o   : 'd%d",gld_o[$]); 
         end 
      end 
   end 
   initial begin
      @(negedge rst_n);
      wait(rst_n);
      while(1)begin
         @(posedge clk);
         if(start_p)begin
            while(1)begin
               @(posedge clk);
               if(!busy)begin
                  $display($realtime,,"dut_o   : 'd%d",o); 
                  dut_o.push_back(o);
                  break;
               end 
            end 
         end 
      end 
   end 

   ////////////////////
   //check data
   initial begin
      while(1)begin
         wait(gld_o.size()>=1 && dut_o.size()>=1);
         if(gld_o[0] === dut_o[0])begin
            $display("check pass!!");
            gld_o.pop_front();
            dut_o.pop_front();
         end 
         else begin
            @(posedge clk);
            @(posedge clk);
            $display("******************"); 
            $display("simulation fail!!!"); 
            $display("******************"); 
            $finish;
         end 
      end 
   end 

endmodule

