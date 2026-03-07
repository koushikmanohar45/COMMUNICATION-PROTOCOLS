module slave_apb #( parameter N=8,A=16)
  (
    input PCLK,
    input PRESETn,
    input [N-1:0] PWDATA, 
    input [A-1:0]PADDR,
    input [2:0]PSEL,
    input PWRITE,
    input PENABLE,
    output reg PREADY,
    output reg [N-1:0]PRDATA,
    output reg PSLVERR
  );
  localparam integer loc=(1<<(A-4));
  reg [N-1:0]mem0[0:loc-1];
  reg [N-1:0]mem1[0:loc-1];
  reg [N-1:0]mem2[0:loc-1];
  reg [N-1:0]mem3[0:loc-1];
  reg [N-1:0]mem4[0:loc-1];
  reg [N-1:0]mem5[0:loc-1];
  reg [N-1:0]mem6[0:loc-1];
  reg [N-1:0]mem7[0:loc-1];
  always @(posedge PCLK)begin
  if(!PRESETn)begin
      PREADY<=0;
    end
 else begin
   if(!PENABLE && !PWRITE) 
        PREADY<=1;
   else if(!PENABLE && PWRITE) 
        PREADY<=1;
   else if(PENABLE && !PWRITE) begin
        PREADY<=1;  
    case(PSEL)
      3'b000:begin
        PRDATA<=mem0[PADDR[A-5:0]];
        end
      3'b001:begin
        PRDATA<=mem1[PADDR[A-5:0]];
         end
      3'b010:begin
        PRDATA<=mem2[PADDR[A-5:0]];
         end
      3'b011:begin
        PRDATA<=mem3[PADDR[A-5:0]];
         end
      3'b100:begin
        PRDATA<=mem4[PADDR[A-5:0]];
         end
      3'b101:begin
        PRDATA<=mem5[PADDR[A-5:0]];
         end
      3'b110:begin
        PRDATA<=mem6[PADDR[A-5:0]];
         end
      3'b111:begin
        PRDATA<=mem7[PADDR[A-5:0]];
         end
       default PRDATA<=8'B0;
    endcase
   end
  else if(PENABLE && PWRITE) begin
        PREADY<=1;  
    case(PSEL)
      3'b000:begin
        mem0[PADDR[A-5:0]]<=PWDATA;
        end
      3'b001:begin
        mem1[PADDR[A-5:0]]<=PWDATA;
         end
      3'b010:begin
        mem2[PADDR[A-5:0]]<=PWDATA;
         end
      3'b011:begin
        mem3[PADDR[A-5:0]]<=PWDATA;
         end
      3'b100:begin
        mem4[PADDR[A-5:0]]<=PWDATA;
         end
      3'b101:begin
        mem5[PADDR[A-5:0]]<=PWDATA;
         end
      3'b110:begin
        mem6[PADDR[A-5:0]]<=PWDATA;
         end
      3'b111:begin
        mem7[PADDR[A-5:0]]<=PWDATA;
         end
    endcase
   end
  end
 end
always @(posedge PCLK or negedge PRESETn)
begin
  if(!PRESETn)
     PSLVERR<=0;
  else if(PENABLE) begin
      if(PADDR[A-5:0]>=loc)
         PSLVERR<=1;
      else
         PSLVERR<=0;
  end
  else
     PSLVERR<=0;
end
endmodule
