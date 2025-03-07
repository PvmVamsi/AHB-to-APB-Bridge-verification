module top;
	import pkg::*;
	import uvm_pkg::*;
	
	// Generate clock signal
	bit clk;  
	always 
		#10 clk=!clk;
	mst_if mst(clk);
	slv_if slv(clk);
	
	rtl_top DUV ( .Hclk(mst.clk),
                     .Hresetn(mst.HRESETn),
                      .Htrans(mst.HTRANS),
		       .Hsize(mst.HSIZE), 
		      .Hreadyin(mst.HREADYin),
		       .Hwdata(mst.HWDATA), 
		       .Haddr(mst.HADDR),
		        .Hwrite(mst.HWRITE),
                       .Prdata(slv.PRDATA),
		        .Hrdata(mst.HRDATA),
		        .Hresp(mst.HRESP),
		       .Hreadyout(mst.HREADYout),
		        .Pselx(slv.PSELX),
		         .Pwrite(slv.PWRITE),
		       .Penable(slv.PENABLE), 
		       .Paddr(slv.PADDR),
		       .Pwdata(slv.PWDATA)
);
	initial begin
		`ifdef VCS
         $fsdbDumpvars(0, top);
        `endif
		uvm_config_db #(virtual mst_if)::set(null, "*", "mst_if", mst);
                uvm_config_db #(virtual slv_if)::set(null, "*", "slv_if", slv);
		run_test();
	end 
	
	
endmodule

