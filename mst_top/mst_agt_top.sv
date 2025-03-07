class mst_agt_top extends uvm_env;
	`uvm_component_utils(mst_agt_top)
	function new(string name = "mst_agt_top",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	env_cfg m_cfg;
	
	mst_agt mst_agth[];
		
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Can t get config from mst_agt_top")
		mst_agth = new[m_cfg.no_of_mst];
		
		foreach(mst_agth[i])
			begin
			mst_agth[i] = mst_agt::type_id::create($sformatf("mst_agth[%0d]",i),this);
			uvm_config_db#(mst_cfg)::set(this,$sformatf("mst_agth[%0d]*",i),"mst_cfg",m_cfg.mst_cfgh[i]);
			end
	endfunction
endclass
