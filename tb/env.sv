//environment class
class env extends uvm_env;
	`uvm_component_utils(env)
	
	//handles of mst and slv
	mst_agt_top mst_agt_top_h;
	slv_agt_top slv_agt_top_h;

	//handles of v sequencer
	vseqr vseqrh;

	//handle of scoreboard
	sb sbh;

	//handle for the env config
	env_cfg m_cfg;

function new(string name = "env",uvm_component parent = null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	//get the m_cfg
	if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",m_cfg))
		`uvm_fatal(get_type_name(),"Cant get the env config");
	
	mst_agt_top_h = mst_agt_top::type_id::create("mst_agt_top_h",this);
	slv_agt_top_h = slv_agt_top::type_id::create("slv_agt_top_h",this);
	vseqrh = vseqr::type_id::create("vseqrh",this);
	sbh = sb::type_id::create("sbh",this);
endfunction

function void connect_phase(uvm_phase phase);
		for(int i = 0;i<m_cfg.no_of_mst;i++)
			vseqrh.mst_seqrh[i] = mst_agt_top_h.mst_agth[i].seqrh;
		for(int i = 0;i<m_cfg.no_of_slv;i++)
			vseqrh.slv_seqrh[i] = slv_agt_top_h.slv_agth[i].seqrh;
		
		mst_agt_top_h.mst_agth[0].monh.mst_port.connect(sbh.mst_fifoh[0].analysis_export);
		for(int i = 0;i<m_cfg.no_of_slv;i++)
			slv_agt_top_h.slv_agth[i].monh.slv_port.connect(sbh.slv_fifoh[i].analysis_export);

endfunction	

endclass




