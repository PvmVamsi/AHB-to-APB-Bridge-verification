class slv_xtn extends uvm_sequence_item;
	`uvm_object_utils(slv_xtn)

	function new(string name = "slv_xtn");
		super.new(name);
	endfunction
	
	logic[31:0]PADDR;
	logic[31:0]PWDATA;
	logic[31:0]PRDATA;
	logic[3:0] PSELX;
	logic PENABLE;
	logic PWRITE;
	
	function void do_print(uvm_printer printer);

  	      super.do_print(printer);
	        printer.print_field("PADDR", PADDR, 32, UVM_HEX);
        	printer.print_field("PENABLE", PENABLE, 1, UVM_DEC);
        	printer.print_field("PWRITE", PWRITE, 1, UVM_DEC);
        	printer.print_field("PSELX", PSELX, 4, UVM_DEC);
        	printer.print_field("PRDATA", PRDATA, 32, UVM_HEX);
		printer.print_field("PWDATA", PWDATA, 32, UVM_HEX);

	endfunction
endclass
