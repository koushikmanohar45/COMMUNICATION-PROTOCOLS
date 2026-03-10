module spi_slave(
    input SCLK,
    input MOSI,
    input CS,
    input CPOL,
    input CPHA,
    output reg MISO,
    output reg s_busy,
    output reg s_done
);
  reg [7:0] tx_reg,rx_reg;
  reg [2:0] bit_count;
  reg SCLK_prev;
  wire rising_edge,falling_edge;
  always @(posedge SCLK or posedge CS) begin
    if(CS) begin
      SCLK_prev<=0;
      MISO<=1'bz;
      s_busy<=1'b0;
      s_done<=1'b0;
      bit_count<=3'd0;
     end
    else begin
      SCLK_prev<=SCLK;
      s_busy<=1'b1;
      if(bit_count==3'd7)
        s_done<=1'b1;
    end
  end
  assign rising_edge=(SCLK_prev==0 && SCLK==1);
  assign falling_edge=(SCLK_prev==1 && SCLK==0);
  always@(posedge SCLK)begin
    if(!CS && (bit_count< 8))begin
        case({CPOL,CPHA})
            2'b00:begin
              if(falling_edge) begin
                MISO<=tx_reg[7];
                tx_reg<={tx_reg[6:0],1'b0};
              end
               if(rising_edge) begin
                 rx_reg<={rx_reg[6:0],MOSI};
                 bit_count<=bit_count+1;
              end
             end
            2'b01:begin
               if(rising_edge) begin
                 MISO<=tx_reg[7];
                 tx_reg<={tx_reg[6:0],1'b0};
               end
               if(falling_edge) begin
                 rx_reg<={rx_reg[6:0],MOSI};
                 bit_count<=bit_count+1;
                end
               end
            2'b10:begin
              if(rising_edge) begin
                  MISO<=tx_reg[7];
                  tx_reg<={tx_reg[6:0],1'b0};
                end            
              if(falling_edge) begin
                  rx_reg<={rx_reg[6:0],MOSI};
                  bit_count<=bit_count+1;
                end
              end
            2'b11:begin
              if(falling_edge) begin
                  MISO<=tx_reg[7];
                  tx_reg<={tx_reg[6:0],1'b0};
                end
              if(rising_edge) begin
                  rx_reg<={rx_reg[6:0],MOSI};
                  bit_count<=bit_count+1;
                end
             end
          endcase
       end
     end
   endmodule
