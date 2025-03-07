class mst_cfg extends uvm_object;
	`uvm_object_utils(mst_cfg)
	
	function new(string name = "mst_cfg");
		super.new(name);
	endfunction
	
	uvm_active_passive_enum is_active;
	
	virtual mst_if vif;
endclass
