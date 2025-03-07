class slv_seq extends uvm_sequence#(slv_xtn);
		`uvm_object_utils(slv_seq)

	function new(string name = "slv_seq");
		super.new(name);
	endfunction

/*	task body();
		req = wr_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {reset==1;})
		finish_item(req);
	
		repeat(5) begin
		req = wr_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {reset == 0;});
		finish_item(req);
		end
	endtask*/
endclass
