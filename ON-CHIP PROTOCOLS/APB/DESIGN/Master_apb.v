module master_apb#( parameter N=8,A=16)
  (
    input PCLK,
    input PRESETn,
    input [N-1:0]PRDATA, 
    input PREADY,
    input transfer,
    input PSLVERR,
    input PWRITE,
    input [N-1:0]PWDATA,
    input [A-1:0]PADDR,
    output reg [7:0]PSEL,
    output reg PENABLE,
    output reg [A-5:0]a_r,
    output reg [N-1:0]d_r,
    output reg wr_en
    
  );
  localparam [1:0] IDLE=2'b00,SETUP=2'b01,ACCESS=2'b10;
  reg[1:0] state,nxt_state;
  always @(posedge PCLK or negedge PRESETn) begin
    if(!PRESETn) begin
      PENABLE<=1'b0;
      a_r<={A-4{1'b0}};
      d_r<={N{1'b0}};
      PSEL<=0;
      state<=IDLE;
    end
    else
      state<=nxt_state;
  end
  always@(*) begin
     case(state)
       IDLE:begin
         if(transfer)
           nxt_state=SETUP;
         else
            nxt_state=IDLE;
         end
        SETUP: nxt_state=ACCESS;
         ACCESS: begin
           if(PREADY) begin
             if(transfer)
               nxt_state=SETUP;
             else
               nxt_state=IDLE;
            end
           else
             nxt_state=ACCESS;
         end
        default:nxt_state=IDLE;
      endcase
    end
  always @(posedge PCLK)begin       
     case(state)
       IDLE:begin
         PSEL<=8'B00000000;
       end
        SETUP:begin
          PENABLE<=1'B0;
          a_r<=PADDR[A-5:0];
          d_r<=PWDATA;
          wr_en<=PWRITE;
           case({PADDR[A-1:A-4]})
            4'h0:PSEL=8'B00000001;
            4'h1:PSEL=8'B00000010;
            4'h2:PSEL=8'B00000100;
            4'h3:PSEL=8'B00001000;
            4'h4:PSEL=8'B00010000;
            4'h5:PSEL=8'B00100000;
            4'h6:PSEL=8'B01000000;
            4'h7:PSEL=8'B10000000;
            default:PSEL=8'B00000000;
           endcase
          end
         ACCESS:begin
           PENABLE<=1'B1;
           PSEL<=PSEL;
           a_r<=a_r;
           d_r<=d_r;
           wr_en<=wr_en;
         end
     endcase
   end
  endmodule
