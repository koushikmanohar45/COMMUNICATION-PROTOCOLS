module apb_tb();

  reg PCLK;
  reg PRESETn;
  reg [7:0]PWDATA;
  reg [15:0]PADDR;
  reg transfer;
  reg PWRITE;
  wire [7:0]PRDATA;
  wire PSLVERR;
  wire [7:0]PSEL;
  wire PENABLE;

  apb dut(.*);
  always #5 PCLK=~PCLK;
  initial begin
    $dumpfile("apb.vcd");
    $dumpvars(0,apb_tb);
    $monitor("time=%0t  addr=%h  wdata=%0d  rdata=%0d  PSEL=%b  PENABLE=%b  write=%b",
              $time,PADDR,PWDATA,PRDATA,PSEL,PENABLE,PWRITE);
    PCLK=0;
    PRESETn=0;
    transfer=0;
    PWRITE=0;
    PADDR=0;
    PWDATA=0;
    #20;
    PRESETn=1;
    apb_write(16'h0002,8'd12);
    apb_write(16'h1002,8'd32);
    apb_write(16'h1102,8'd15);
    apb_write(16'h1202,8'd24);
    apb_write(16'h2002,8'd56);
    apb_write(16'h2102,8'd100);
    apb_write(16'h2202,8'd120);
    apb_write(16'h2302,8'd123);
    apb_write(16'h3302,8'd125);
    apb_write(16'h4302,8'd126);
    apb_write(16'h5302,8'd155);
    apb_write(16'h6302,8'd146);
    apb_read(16'h1002);
    apb_read(16'h1102);
    apb_read(16'h1202);
    apb_read(16'h2002);
    apb_read(16'h2102);
    apb_read(16'h2202);
    apb_read(16'h2302);
    apb_read(16'h3302);
    apb_read(16'h4302);
    apb_read(16'h5302);
    apb_read(16'h6302);
    #50;
    $finish;
  end

  task apb_write(input [15:0]addr,input [7:0]data);
  begin
    @(posedge PCLK);
    PADDR=addr;
    PWDATA=data;
    PWRITE=1;
    transfer=1;
    @(posedge PCLK); 
    @(posedge PCLK);
  end
  endtask
  task apb_read(input [15:0]addr);
  begin
    @(posedge PCLK);
    PADDR=addr;
    PWRITE=0;transfer=1;

    @(posedge PCLK); 
    @(posedge PCLK); 
  end
  endtask
endmodule
