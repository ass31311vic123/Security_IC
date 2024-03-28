module kexp(
   input              key_ld_p, //key load pulse
   input      [127:0] key     , //cipher key
   input              enc     , //0:decryption, 1:encryption
   output             rk_vld  , //round key valid
   output     [127:0] rk      , //round key
   input              rk_rdy  , //round key ready
   input              clk     , //clock
   input              rst_n     //active low asynchronous reset
   );

endmodule
