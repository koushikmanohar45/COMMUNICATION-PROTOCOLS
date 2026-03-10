module master
  (
    input clk,
    input rst_n,
    input [7:0]data_in,
    input MISO,
    input [1:0]slav_sel,
    input CPOL,CPHA,
    output reg SCLK,
    output reg MOSI,
    output reg CS0,
    output reg CS1,
    output reg CS2,
    output reg m_busy,
    output reg m_done
  );
  localparam [1:0] IDLE=2'b00,LOAD=2'b01;TRANSFER=2'b10,STOP=2'b11;
  reg [1:0] state,nxt_state;
  reg SCLK_en,SCLK_prev;
  reg [7:0]tx_reg,rx_reg;
  reg[2:0] bit_count;
  
  always@(posedge clk) begin
      if(!rst) begin
       count<=2'b00;
       SCLK<=CPOL;
      end
    else if(SCLK_en) begin
       count<=count+1;
       if(count==2'b11) begin
         SCLK<=1'b0;
         count<=2'b00;
       end
      else if(count==2'b01)begin
        SCLK<=1'b1;
       end
      end
     end
   always @(posedge SCLK or negedge rst_n)begin
      if(!rst_n)begin
        MOSI<=1'bx;
        CS0<=1'b1;
        CS1<=1'b1;
        CS2<=1'b1;
        state<=IDLE;
      end
      else
        state<=nxt_state;
    end
  always@(*)begin
      case(state)
        IDLE:begin
          if(transfer_en && !(CS0 && CS1 && CS2))begin
            nxt_state=START;
          end
          else 
            nxt_state=IDLE;
        end
        LOAD:begin
          nxt_state=TRANSFER;
        end
        TRANSFER:begin
          if(bit_count==3'b111) begin
            nxt_state=STOP;
            bit_count=3'b000;
          end
          else begin
            nxt_state=TRANSFER;
          end
        end
        STOP:begin
          if(CS0 || CS1|| CS2)
            nxt_state=IDLE;
          else
            nxt_state=STOP;
        end
        default:nxt_state=IDLE;
      endcase
    end   
  
  
  
  
 always@(posedge clk)begin
     if(!rst)begin
        SCLK_prev<=1'B0;
        SCLK_en<=1'B0;
        m_busy<=1'b1;
        m_done<=1'b1;
        end
        else begin
          SCLK_prev<=SCLK;
        case(state)
        IDLE:begin
        if(transfer_en)begin
            case(slav_sel)
              2'b00:CS0<=0;
              2'b01:CS1<=0;
              2'b10:CS2<=0;
              2'b11:begin
                CS0<=1'b1;
                CS1<=1'b1;
                CS2<=1'b1:
                CS3<=1'b1;
              end
              default:begin
                CS0<=1'b1;
                CS1<=1'b1;
                CS2<=1'b1:
                CS3<=1'b1;
              end
             endcase
             bit_count<=0;
             SCLK_en<=0;
             m_busy<=0;
             m_done <= 0;   
          end
         end
       LOAD:begin
          tx_reg<=data_in;
          rx_reg<=1'b0;
          bit_count<=1'b0;
          m_busy<=1'b1;
          m_done<=1'b0;
         end
        TRANSFER:begin
          SCLK_en=1'b1;
          case({CPOL,CPHA})
            2'b00:begin
              if(SCLK_prev==1 && SCLK==0)begin
                MOSI<=tx_reg[7];
                tx_reg<={1'b0,tx_reg[6:0]}
              end
              else if(SCLK_prev==0 && SCLK==1)begin
                rx_reg<={rx_reg[6:0],MISO};
              end
            end
            2'b01:begin
              if(SCLK_prev==0 && SCLK==1)begin
                MOSI<=tx_reg[7];
                tx_reg<={tx_reg[6:0],1'b0}
                bit_count<=bit_count+1;
              end
              else if(SCLK_prev==1 && SCLK==0)begin
                rx_reg<={rx_reg[6:0],MISO};
              end             
            end
            2'b10:begin
              if(SCLK_prev==1 && SCLK==0)begin
                rx_reg<={rx_reg[6:0],MISO};
              end
              else if(SCLK_prev==0 && SCLK==1)begin
                MOSI<=tx_reg[7];
                tx_reg<={tx_reg[6:0],1'b0}
                bit_count<=bit_count+1;
              end              
            end
            2'b11:begin
              if(SCLK_prev==1 && SCLK==0)begin
                rx_reg<={rx_reg[6:0],MISO};
              end
              else if(SCLK_prev==0 && SCLK==1)begin
                MOSI<=tx_reg[7];
                tx_reg<={tx_reg[6:0],1'b0}
                bit_count<=bit_count+1;
              end  
            end
         end
        STOP:begin
          slav_sel=2'b11;
        end
      endcase
        end
       end
  endmodule
          
