class mst_seq extends uvm_sequence#(mst_xtn);
	`uvm_object_utils(mst_seq)
	bit [2:0]hsize,hburst;
	bit [31:0]haddr;
	bit [9:0]length;
	bit hwrite;
	function new(string name = "mst_seq");
		super.new(name);
	endfunction

endclass

class single_trans extends mst_seq;
	`uvm_object_utils(single_trans)

	function new(string name = "single_trans");
		super.new(name);
	endfunction

	task body();
		req = mst_xtn::type_id::create("req");
		start_item(req);
		req.randomize() with{HTRANS == 2'b10;HBURST == 3'b000;};
		$display("======HBURST = %b========",req.HBURST);
		finish_item(req);
	endtask
endclass

class incr_trans extends mst_seq;
	`uvm_object_utils(incr_trans)

	function new(string name = "incr_trans");
		super.new(name);
	endfunction

	task body();
		repeat(10) begin
		req = mst_xtn::type_id::create("req");
		start_item(req);
		req.randomize() with{HTRANS == 2'b10;HBURST inside {1,3,5,7};};
		//req.randomize() with{HTRANS == 2'b10;HBURST == 5;};
		$display("======HBURST = %b========",req.HBURST);
		finish_item(req);
		
		haddr = req.HADDR;
		hwrite = req.HWRITE;
		length = req.len;
		hsize = req.HSIZE;
		hburst = req.HBURST;

		for(int i =1;i<length;i++) begin
			req = mst_xtn::type_id::create("req");
			start_item(req);
			req.randomize() with{HADDR == haddr +(2**hsize); HWRITE==hwrite;HBURST == hburst;HSIZE == hsize;HTRANS == 2'b11;};
			finish_item(req);
			haddr = req.HADDR;
		end
		end
	endtask
endclass

class wrap_trans extends mst_seq;
	`uvm_object_utils(wrap_trans)

	function new(string name = "wrap_trans");
		super.new(name);
	endfunction

	task body();
		bit[31:0]SA,BA;
		repeat(10) begin

		req = mst_xtn::type_id::create("req");
		start_item(req);
		req.randomize() with{HTRANS == 2'b10;HBURST inside {2,4,6};};
		$display("======HBURST = %b========",req.HBURST);
		finish_item(req);
	
		haddr = req.HADDR;
		hwrite = req.HWRITE;
		length = req.len;
		hsize = req.HSIZE;
		hburst = req.HBURST;
		
		SA = int'(haddr /((2**hsize)*(length))) *((2**hsize)*(length));
		BA = SA + ((2**hsize)*(length));
		haddr = req.HADDR+2**hsize;

		for(int i =1;i<length;i++) begin
			if(haddr >= BA)
				haddr = SA;

			req = mst_xtn::type_id::create("req");
			start_item(req);
			req.randomize() with{HADDR == haddr; HWRITE==hwrite;HBURST == hburst;HSIZE == hsize;HTRANS == 2'b11;};
			finish_item(req);
			haddr = req.HADDR+2**hsize;
		end
		end
	endtask
endclass



