module apb #( parameter N=8,A=16)
  (
    input PCLK,
    input PRESETn,
    input [N-1:0] PWDATA, 
    input [A-1:0]PADDR,
    input transfer,
    input PWRITE,
    output [N-1:0]PRDATA,
    output PSLVERR,
    output [2:0]PSEL
  );  
  wire PENABLE;
  wire PREADY;
  
  master_apb #(.N(N),.A(A)) m1(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA),.PREADY(PREADY),.transfer(transfer),.PSLVERR(PSLVERR),.PADDR(PADDR),.PSEL(PSEL),.PENABLE(PENABLE),.PWRITE(PWRITE),.PWDATA(PWDATA));
  slave_apb #(.N(N),.A(A)) s1(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA),.PREADY(PREADY),.PSLVERR(PSLVERR),.PADDR(PADDR),.PSEL(PSEL),.PENABLE(PENABLE),.PWRITE(PWRITE),.PWDATA(PWDATA));

endmodule



        
