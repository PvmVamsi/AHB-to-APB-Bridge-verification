class slv_cfg extends uvm_object;
	`uvm_object_utils(slv_cfg)
	
	function new(string name = "slv_cfg");
		super.new(name);
	endfunction
	
	uvm_active_passive_enum is_active;
	
	virtual slv_if vif;
endclass
