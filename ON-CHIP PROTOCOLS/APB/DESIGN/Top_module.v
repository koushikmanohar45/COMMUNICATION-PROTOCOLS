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
    output [7:0]PSEL,
    output PENABLE
  );  
  wire PREADY;
  wire [N-1:0] PRDATA_s[7:0];
  wire PREADY_s[7:0];
  wire PSLVERR_s[7:0];
  wire[A-5:0]a_r;
  wire [N-1:0]d_r;
  wire wr_en;
  
  master_apb #(.N(N),.A(A)) m1(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA),.PREADY(PREADY),.transfer(transfer),.PSLVERR(PSLVERR),.PADDR(PADDR),.PSEL(PSEL),.PENABLE(PENABLE),.PWRITE(PWRITE),.PWDATA(PWDATA),.a_r(a_r),.d_r(d_r),.wr_en(wr_en));
  
  slave_apb #(.N(N),.A(A))
s1(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA_s[0]),.PREADY(PREADY_s[0]),.PSLVERR(PSLVERR_s[0]),.PADDR(a_r),.PSEL(PSEL[0]),.PENABLE(PENABLE),.PWRITE(wr_en),.PWDATA(d_r));
  
  slave_apb #(.N(N),.A(A)) s2(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA_s[1]),.PREADY(PREADY_s[1]),.PSLVERR(PSLVERR_s[1]),.PADDR(a_r),.PSEL(PSEL[1]),.PENABLE(PENABLE),.PWRITE(wr_en),.PWDATA(d_r));
  
  slave_apb #(.N(N),.A(A)) s3(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA_s[2]),.PREADY(PREADY_s[2]),.PSLVERR(PSLVERR_s[2]),.PADDR(a_r),.PSEL(PSEL[2]),.PENABLE(PENABLE),.PWRITE(wr_en),.PWDATA(d_r));
  
  slave_apb #(.N(N),.A(A)) s4(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA_s[3]),.PREADY(PREADY_s[3]),.PSLVERR(PSLVERR_s[3]),.PADDR(a_r),.PSEL(PSEL[3]),.PENABLE(PENABLE),.PWRITE(wr_en),.PWDATA(d_r));
  
  slave_apb #(.N(N),.A(A)) s5(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA_s[4]),.PREADY(PREADY_s[4]),.PSLVERR(PSLVERR_s[4]),.PADDR(a_r),.PSEL(PSEL[4]),.PENABLE(PENABLE),.PWRITE(wr_en),.PWDATA(d_r));
  
  slave_apb #(.N(N),.A(A)) s6(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA_s[5]),.PREADY(PREADY_s[5]),.PSLVERR(PSLVERR_s[5]),.PADDR(a_r),.PSEL(PSEL[5]),.PENABLE(PENABLE),.PWRITE(wr_en),.PWDATA(d_r));
  
  slave_apb #(.N(N),.A(A)) s7(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA_s[6]),.PREADY(PREADY_s[6]),.PSLVERR(PSLVERR_s[6]),.PADDR(a_r),.PSEL(PSEL[6]),.PENABLE(PENABLE),.PWRITE(wr_en),.PWDATA(d_r));
  
  slave_apb #(.N(N),.A(A)) s8(.PCLK(PCLK),.PRESETn(PRESETn),.PRDATA(PRDATA_s[7]),.PREADY(PREADY_s[7]),.PSLVERR(PSLVERR_s[7]),.PADDR(a_r),.PSEL(PSEL[7]),.PENABLE(PENABLE),.PWRITE(wr_en),.PWDATA(d_r));
  
  assign PRDATA=PSEL[0]?PRDATA_s[0]:(PSEL[1]?PRDATA_s[1]:(PSEL[2]?PRDATA_s[2]:(PSEL[3]?PRDATA_s[3]:(PSEL[4]?PRDATA_s[4]:(PSEL[5]?PRDATA_s[5]:(PSEL[6]?PRDATA_s[6]:(PSEL[7]?PRDATA_s[7]:({N{1'bx}}))))))));
  
  assign PREADY =PSEL[0]?PREADY_s[0]:(PSEL[1]?PREADY_s[1]:(PSEL[2]?PREADY_s[2]:(PSEL[3]?PREADY_s[3]:(PSEL[4]?PREADY_s[4]:(PSEL[5]?PREADY_s[5]:(PSEL[6]?PREADY_s[6]:(PSEL[7]?PREADY_s[7]:0)))))));

  assign PSLVERR=PSEL[0]?PSLVERR_s[0]:(PSEL[1]?PSLVERR_s[1]:(PSEL[2]?PSLVERR_s[2]:(PSEL[3]?PSLVERR_s[3]:(PSEL[4]?PSLVERR_s[4]:(PSEL[5]?PSLVERR_s[5]:(PSEL[6]?PSLVERR_s[6]:(PSEL[7]?PSLVERR_s[7]:0)))))));
  
endmodule
