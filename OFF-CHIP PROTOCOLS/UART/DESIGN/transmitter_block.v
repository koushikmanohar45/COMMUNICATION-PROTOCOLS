module transmitter_block#(parameter N=8)
  (
    input t_clk,
    input w_en,
    input tx_en,
    input t_rst,
    input [N-1:0]data_in,
    output reg busy,
    output reg tx
  );
  localparam integer a=$clog2(N);
  reg [a-1:0] count={a{1'b0}};
  localparam [2:0] IDLE=3'B000,START=3'B001,DATA=3'B010,PARITY=3'B011,STOP=3'B100;
  reg [2:0] state,nxt_state;
  reg [N-1:0]q;
  
  always @(posedge t_clk or negedge t_rst) begin
    if(!t_rst) begin
      state<=IDLE;
    end
    else 
      state<=nxt_state;
  end
  
  always @(posedge t_clk or negedge t_rst) begin
  if(!t_rst)
    count<=0;
    else if(state==DATA && tx_en)
    count<=count+1;
  else if(state!=DATA)
    count<=0;
end
  
  always@(*) begin
    case(state)
      IDLE: begin
        if(w_en) 
          nxt_state=START;
        else
          nxt_state=IDLE;
        end
      START:begin
        if(tx_en) begin	
          nxt_state=DATA;
        end
        else
          nxt_state=START;
        end
      DATA:begin
          if(tx_en==1 && count==N-1) 
              nxt_state=PARITY;
            else
              nxt_state=DATA;
          end
      PARITY:begin
        if(tx_en) 
          nxt_state=STOP;
        else
          nxt_state=PARITY; 
        end
      STOP:begin
        if(tx_en)
          nxt_state=IDLE;
        else
           nxt_state=STOP;
          end
      default:nxt_state=IDLE;
      endcase
    end
   
  always@(posedge t_clk or negedge t_rst) begin
        if(!t_rst) begin
         busy<=1'b0;
         tx<=1'b1;
         q<={N{1'b0}};
        end
      else begin
        case(state)
          START: begin 
            busy<=1'b1;
            if(tx_en)begin
               tx<=1'b0;
                q<=data_in;
              end  
           end
          DATA:begin
            if(tx_en) begin
              tx<=q[0];
              q<={1'b0,q[N-1:1]};
             end
            end
          PARITY: begin
            if(tx_en)
              tx<=^data_in;
            end
          STOP: begin
            if(tx_en) begin
              tx<=1'b1;
              busy<=1'b0;
             end
            end
           default: begin
             tx<=1'b1;
             busy<=1'b0;
           end
        endcase
      end
   end
 endmodule
