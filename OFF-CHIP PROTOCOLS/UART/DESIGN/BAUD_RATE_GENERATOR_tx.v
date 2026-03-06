module BAUD_RATE_GENERATOR_tx#(parameter BAUD_RATE=9600,clk_freq=50000000)
  (
    input t_clk,
    input t_rst,
    output reg tx_en
  );

  localparam integer cycle=clk_freq/BAUD_RATE;
  reg[$clog2(cycle)-1:0]c=0;
  always @(posedge t_clk or negedge t_rst) begin
  if(!t_rst) begin
    c<=0;
    tx_en<=0;
   end
  else begin
    if(c==cycle-1) begin
      tx_en<=1;
      c<=0;
     end
    else begin
      tx_en<=0;
      c<=c+1;
    end
   end
  end
endmodule
