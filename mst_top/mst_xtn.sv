class mst_xtn extends uvm_sequence_item;
	`uvm_object_utils(mst_xtn)

	function new(string name = "mst_xtn");
		super.new(name);
	endfunction
	
	logic HRESETn;
	logic[31:0]HRDATA;
	logic HREADYin;
	logic HREADYout;
	logic HRESP;

	rand logic[31:0]HADDR;
	rand logic[1:0]HTRANS;
	rand logic HWRITE;
	rand logic[2:0]HSIZE;
	randc logic[2:0]HBURST;
	rand logic[31:0]HWDATA;
	

	constraint address{HADDR inside {[32'h 8000_0000 : 32'h 8000_03FF],[32'h 8400_0000 : 32'h 8400_03FF],[32'h 8800_0000 : 32'h 8800_03FF],[32'h 8C00_0000 : 32'h 8C00_03FF]};}
	constraint size {HSIZE inside {0,1,2};}
	constraint align_add {HADDR%(2**HSIZE) == 0;}
	
	//local rand bit len
	rand bit [9:0] len; // As our boundry is 1kb = 1024 bytes 
		
	constraint bound { (HADDR % 1024) + (len * (2**HSIZE)) <= 1023;}
	constraint length {    {if(HBURST == 0 ) len == 1;
				else if (HBURST == 2 || HBURST == 3) len == 4;
				else if (HBURST == 4 || HBURST == 5) len == 8;
				else if (HBURST == 6 || HBURST == 7) len == 16;}}



       function void do_print(uvm_printer printer);
		//printer.print_field("HRESETn",HRESETn,1,UVM_BIN);
		
		//printer.print_field("HREADYin",HREADYin,1,UVM_BIN);
		printer.print_field("HREADYout",HREADYout,1,UVM_BIN);
		//printer.print_field("HRESP",HRESP,1,UVM_BIN);
		printer.print_field("HADDR",HADDR,32,UVM_HEX);
		printer.print_field("HTRANS",HTRANS,2,UVM_BIN);
		printer.print_field("HWRITE",HWRITE,1,UVM_BIN);
		printer.print_field("HSIZE",HSIZE,3,UVM_DEC);
		printer.print_field("HBURST",HBURST,3,UVM_DEC);
		printer.print_field("HWDATA",HWDATA,32,UVM_HEX);
		printer.print_field("HRDATA",HRDATA,32,UVM_HEX);
		//printer.print_field("len",len,10,UVM_DEC);
		
	endfunction
endclass
	
