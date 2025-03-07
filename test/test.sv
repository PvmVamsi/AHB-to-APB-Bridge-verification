class test extends uvm_test;
	`uvm_component_utils(test)
	
	function new(string name = "test",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	env_cfg m_cfg;
	int no_of_mst;
	int no_of_slv;
	
	mst_cfg mst_cfgh[];
	slv_cfg slv_cfgh[];
	
	env envh;	

	vseq vseqh;
	
	function void build_phase(uvm_phase phase);
		
		m_cfg = env_cfg::type_id::create("m_cfg");
		no_of_mst = 1;
		no_of_slv = 1;
		
		mst_cfgh = new[no_of_mst];
		slv_cfgh = new[no_of_slv];

		foreach(mst_cfgh[i]) begin
			mst_cfgh[i] = mst_cfg::type_id::create($sformatf("mst_cfgh[%0d]",i));
			if(!uvm_config_db#(virtual mst_if)::get(this,"","mst_if",mst_cfgh[i].vif))
				`uvm_fatal(get_type_name(),"virt")
				
			mst_cfgh[i].is_active = UVM_ACTIVE;
		end

		foreach(slv_cfgh[i]) begin
			slv_cfgh[i] = slv_cfg::type_id::create($sformatf("slv_cfgh[%0d]",i));
			if(!uvm_config_db#(virtual slv_if)::get(this,"","slv_if",slv_cfgh[i].vif))
				`uvm_fatal(get_type_name(),"virt")
				
			slv_cfgh[i].is_active = UVM_PASSIVE;
		end
		
	 	m_cfg.no_of_mst = no_of_mst;
		m_cfg.no_of_slv = no_of_slv;
		m_cfg.mst_cfgh = mst_cfgh;
		m_cfg.slv_cfgh = slv_cfgh;

		envh = env::type_id::create("envh",this);
	
		uvm_config_db#(env_cfg)::set(this,"*","env_cfg",m_cfg);
	endfunction
	
	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			vseqh = vseq::type_id::create("vseqh");
			vseqh.start(envh.vseqrh);
		phase.drop_objection(this);
	endtask
endclass


class single_test extends test;
	`uvm_component_utils(single_test)
	single_vseq svseqh;

	function new(string name = "single_test",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			svseqh =single_vseq::type_id::create("svseqh");
			svseqh.start(envh.vseqrh);
			#110;
		phase.drop_objection(this);
	endtask

endclass

class incr_test extends test;
	`uvm_component_utils(incr_test)
	incr_vseq ivseqh;

	function new(string name = "single_test",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			ivseqh =incr_vseq::type_id::create("ivseqh");
			ivseqh.start(envh.vseqrh);
			#110;
		phase.drop_objection(this);
	endtask

endclass

class wrap_test extends test;
	`uvm_component_utils(wrap_test)
	wrap_vseq wvseqh;

	function new(string name = "single_test",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			wvseqh =wrap_vseq::type_id::create("wvseqh");
			wvseqh.start(envh.vseqrh);
			#110;
		phase.drop_objection(this);
	endtask

endclass
