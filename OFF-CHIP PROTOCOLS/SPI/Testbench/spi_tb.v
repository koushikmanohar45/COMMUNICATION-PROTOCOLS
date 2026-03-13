`timescale 1ns/1ps
module spi_tb;
  reg clk;
  reg rst_n;
  reg transfer_en;
  reg [7:0]m_data_in;
  reg [7:0]s_data_in;
  reg [1:0]slav_sel;
  reg CPOL;
  reg CPHA;
  wire [7:0]m_data_out;
  wire [7:0]s_data_out;
  spi_top DUT (.*);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin 
  $monitor("clk=%0d rst_n=%b transfer_en=%b m_data_in=%0d s_data_in=%0d slav_sel=%b CPOL=%b CPHA=%b  m_data_out=%0D s_Data_out=%0d",$time,rst_n,transfer_en,m_data_in,s_data_in,slav_sel,CPOL,CPHA,m_data_out,s_data_out);       rst_n=0;transfer_en=0;m_data_in=8'd00;s_data_in=8'd00;slav_sel=2'b00;CPOL=0;CPHA=0;
#20 rst_n=1;
#20 CPOL=0;CPHA=0;m_data_in=8'd45;s_data_in=8'd36;slav_sel=2'b00;transfer_en=1;
#10 transfer_en=0;
#1000 CPOL=0;CPHA=1;m_data_in=8'd18;s_data_in=8'd07;slav_sel=2'b00;transfer_en=1;
#10 transfer_en=0;
#1000 CPHA=0;m_data_in=8'd48;s_data_in=8'd76;slav_sel=2'b10;transfer_en=1;
#10 transfer_en=0;
#1000 CPOL=1;CPHA=1;m_data_in=8'd122;s_data_in=8'd13;slav_sel=2'b00;transfer_en=1;
#10 transfer_en=0;
#1000 $finish;
end
  initial begin
    $dumpfile("v.vcd");
    $dumpvars(0,spi_tb);
  end
endmodule
