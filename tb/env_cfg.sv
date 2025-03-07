class env_cfg extends uvm_object;
	`uvm_object_utils(env_cfg)
	
	mst_cfg mst_cfgh[];
	slv_cfg slv_cfgh[];
	
	int no_of_mst;
	int no_of_slv;

	function new(string name ="env_cfg");
		super.new(name);
	endfunction

	

endclass
