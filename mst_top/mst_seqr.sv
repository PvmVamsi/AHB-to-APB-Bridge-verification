class mst_seqr extends uvm_sequencer#(mst_xtn);	
	`uvm_component_utils(mst_seqr)

	function new(string name = "mst_seqr",uvm_component parent = null);
		super.new(name,parent);
	endfunction
endclass
