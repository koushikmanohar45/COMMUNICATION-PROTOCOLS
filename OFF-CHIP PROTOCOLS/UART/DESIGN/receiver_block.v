module receiver_block #(parameter N=8)
  (
    input r_clk,
    input r_rst,
    input rx_en,
    input rx,
    output reg [N-1:0] data_out,
    output reg parity_error,rdy,frame_error
  );
   localparam integer a=$clog2(N);
   reg [a-1:0] count={a{1'b0}};
   localparam [2:0] IDLE=3'B000,START=3'B001,DATA=3'B010,PARITY=3'B011,STOP=3'B100;
  reg [2:0] state,nxt_state;
  reg parity_bit;
  reg[3:0]sample;
  reg rx_sync, rx_prev;
  
  always @(posedge r_clk or negedge r_rst) begin
    if(!r_rst) begin
      state<=IDLE;
    end
    else 
      state<=nxt_state;
  end
  always @(posedge r_clk or negedge r_rst) begin
    if(!r_rst)
      count<=0;
    else if(state==DATA && rx_en && sample==15)
      count<=count+1;
    else if(state!=DATA)
    count<=0;
end

  always @(posedge r_clk or negedge r_rst) begin
  if(!r_rst)
      sample<=0;
  else if(rx_en) begin
    if(sample==15)
      sample<=0;
    else
      sample<=sample+1;
    end
  end
  
  always @(*)begin
          nxt_state=state;
    case(state)
      IDLE:begin
        if(rx==0)
            nxt_state=START;
       else
            nxt_state=IDLE;
      end
      START:begin
        if(rx==1 && sample==4'd8)begin
          nxt_state=IDLE; end
        else begin
          if(rx_en && sample==4'd15) begin
             nxt_state=DATA;
              end
          else
             nxt_state=START;
              end
      end
      DATA:begin
          if(rx_en && count==N-1 && sample==4'd15)
            nxt_state=PARITY;
         else
            nxt_state=DATA;
        end
      PARITY:begin
          if(rx_en && sample==4'd15) 
              nxt_state=STOP;
           else  
              nxt_state=PARITY;
        end
      STOP:begin
        if(rx_en && sample==4'd15 && rx) 
              nxt_state=IDLE;
           
           else
              nxt_state=STOP;
          end
      
       default:nxt_state=IDLE;
      endcase
    end
  always @(posedge r_clk or negedge r_rst) begin
      if(!r_rst) begin
         rdy<=1'b0;
         data_out<={N{1'b0}};
         frame_error<=1'b0;
         parity_error<=1'b0;
      end
      else begin
        case(state)
          IDLE: begin
            if(!rx && rx_en)
              rdy<=1'b0;
            else
              rdy<=1'b1;
          end
          START:begin
            rdy<=1'b0;
           end
          DATA: begin
              rdy<=1'b0;
            if(rx_en && sample==4'd8) 
              data_out<={rx,data_out[N-1:1]};
            end
               
          PARITY:begin
            rdy<=1'b0;
            if(rx_en && sample==4'd8) begin
              parity_error<=(^data_out!=rx);
            end
          end
          STOP:begin
            rdy<=1'b0;
            if(rx_en && sample==4'd8)
                 frame_error<=~rx;
           end
          default:begin
            rdy<=1'b0;
            data_out<={N{1'b0}};
            frame_error<=1'b0;
            parity_error<=1'b0;
          end
        endcase
      end
   end
endmodule
