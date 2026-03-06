`timescale 1ns/1ps

module UART_tb#(parameter N=8);
reg t_clk;
reg r_clk;
reg t_rst;
reg r_rst;
reg w_en;
reg [N-1:0] data_in;
wire[N-1:0] data_out;
wire rdy;
wire busy;
wire parity_error;
wire frame_error;
UART #(N) DUT(.*);
always #10 t_clk=~t_clk;   // 50 MHz
always #5  r_clk=~r_clk;   // 100 MHz

task send_data;
input [7:0] data;
begin
    @(posedge t_clk);
    wait(busy==0);
    data_in=data;
    w_en=1;
    @(posedge t_clk);
    w_en=0;
   wait(busy==1);
    wait(busy==0); 
end
endtask


initial begin
    t_clk=0;r_clk=0;t_rst=0;r_rst=0;w_en=0;data_in=0;
    #100;t_rst=1;r_rst=1;
    #50;
  send_data(8'd15);
  send_data(8'd36);
  send_data(8'd60);
  send_data(8'd55);
  send_data(8'd06);
  send_data(8'd99);
  send_data(8'd45);
  send_data(8'd200);
  send_data(8'd156);
  send_data(8'd124);
  send_data(8'd74);
  send_data(8'd43);
end

always @(posedge rdy) begin
    $display("------------------------------------");
    $display("Time = %0t", $time);
    $display("Received Data = %0d",data_out);
    $display("Parity Error= %b",parity_error);
    $display("Frame Error= %b",frame_error);
end

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0,UART_tb);
end

endmodule
