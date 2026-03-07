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
    output reg [2:0]PSEL,
    output reg PENABLE
  );
  localparam [1:0] IDLE=2'b00,SETUP=2'b01,ACCESS=2'b10;
  reg[1:0] state,nxt_state;
  always @(posedge PCLK or negedge PRESETn) begin
    if(!PRESETn) 
      state<=IDLE;
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
  always @(*)begin       
     case(state) 
        SETUP:begin
          PENABLE=1'B0;
          case({PADDR[A-1:A-4]})
            4'h0:PSEL=3'B000;
            4'h1:PSEL=3'B001;
            4'h2:PSEL=3'B010;
            4'h3:PSEL=3'B011;
            4'h4:PSEL=3'B100;
            4'h5:PSEL=3'B101;
            4'h6:PSEL=3'B110;
            4'h7:PSEL=3'B111;
            default:PSEL=3'BX;
          endcase
          end
         ACCESS:begin
           PENABLE=1'B1;
        end
      endcase
    end
  endmodule
