module slave_apb #( parameter N=8,A=16)
  (
    input PCLK,
    input PRESETn,
    input [N-1:0]PWDATA, 
    input [A-5:0]PADDR,
    input PSEL,
    input PWRITE,
    input PENABLE,
    output reg PREADY,
    output reg [N-1:0]PRDATA,
    output reg PSLVERR
  );
  localparam integer loc=(1<<(A-4));
  reg [N-1:0]mem[0:loc-1];
  always @(posedge PCLK)begin
  if(!PRESETn)begin
      PREADY<=0;
    end
 else begin
   if(!PSEL) begin
     PRDATA<=PRDATA;
     PREADY<=1'b1;
    end
   else begin
       PREADY<=1;
     case({PENABLE,PWRITE})
       2'b10:PRDATA<=mem[PADDR[A-5:0]]; 
       2'b11:mem[PADDR[A-5:0]]<=PWDATA;
       default:PRDATA<=PRDATA;
      endcase
   end
  end
 end
always @(posedge PCLK or negedge PRESETn)begin
  if(!PRESETn)
     PSLVERR<=0;
  else if(PENABLE) begin
    if(PADDR[A-5:0]>=loc || PADDR[A-5:0]=={A{1'bx}})
         PSLVERR<=1;
      else
         PSLVERR<=0;
  end
  else
     PSLVERR<=0;
end
endmodule
