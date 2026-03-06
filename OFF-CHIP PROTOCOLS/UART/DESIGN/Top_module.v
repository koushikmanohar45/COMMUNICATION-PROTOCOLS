`timescale 1ns/1ps
module UART #(parameter N=8)
  (
    input t_clk,t_rst,w_en,
    input r_clk,r_rst,
    input [N-1:0] data_in,
    output[N-1:0] data_out,
    output rdy,busy,parity_error,frame_error
  );
    wire tx;
    wire rx_en,tx_en;
  BAUD_RATE_GENERATOR_tx m1(.t_clk(t_clk),.tx_en(tx_en),.t_rst(t_rst));
  BAUD_RATE_GENERATOR_rx m2(.r_clk(r_clk),.rx_en(rx_en),.r_rst(r_rst));
  transmitter_block #(.N(N)) m3 (.t_clk(t_clk),.w_en(w_en),.tx_en(tx_en),.t_rst(t_rst),.data_in(data_in),.busy(busy),.tx(tx));
  receiver_block #(.N(N)) m4 (.r_clk(r_clk),.rx_en(rx_en),.r_rst(r_rst),.data_out(data_out),.rdy(rdy),.rx(tx),.parity_error(parity_error),.frame_error(frame_error));
endmodule
