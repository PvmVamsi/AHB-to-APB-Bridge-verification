class slv_seqr extends uvm_sequencer#(slv_xtn);	
	`uvm_component_utils(slv_seqr)

	function new(string name = "slv_seqr",uvm_component parent = null);
		super.new(name,parent);
	endfunction
endclass
