module BAUD_RATE_GENERATOR_rx#(parameter BAUD_RATE=9600,clk_freq=100000000)
  (
    input r_clk,
    input r_rst,
    output reg rx_en
  );
  localparam integer cycle=clk_freq/(BAUD_RATE*16);
  reg[$clog2(cycle)-1:0]c=0;
  always @(posedge r_clk or negedge r_rst) begin
    if(!r_rst) begin
    c<=0;
    rx_en<=0;
  end
    else begin
      if(c==cycle-1) begin
      rx_en<=1;
      c<=0;
     end
    else begin
      rx_en<=0;
      c<=c+1;
    end
   end
  end
endmodule
