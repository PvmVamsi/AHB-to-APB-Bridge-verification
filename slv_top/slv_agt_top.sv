class slv_agt_top extends uvm_env;
	`uvm_component_utils(slv_agt_top)
	function new(string name = "slv_agt_top",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	env_cfg m_cfg;
	
	slv_agt slv_agth[];
		
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Can t get config from slv_agt_top")
		slv_agth = new[m_cfg.no_of_slv];
		
		foreach(slv_agth[i])
			begin
			slv_agth[i] = slv_agt::type_id::create($sformatf("slv_agth[%0d]",i),this);
			uvm_config_db#(slv_cfg)::set(this,$sformatf("slv_agth[%0d]*",i),"slv_cfg",m_cfg.slv_cfgh[i]);
			end
	endfunction
endclass
