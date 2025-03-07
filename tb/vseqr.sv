class vseqr extends uvm_sequencer #(uvm_sequence_item); 

	`uvm_component_utils(vseqr)
	//env config
	env_cfg m_cfg;
	
	//sequencers 
	mst_seqr mst_seqrh[]; 
	slv_seqr slv_seqrh[];

function new(string name = "vseqr", uvm_component parent = null);
		super.new(name, parent); 
endfunction 
function void build_phase(uvm_phase phase); 
		super.build_phase(phase); 
		
		if(!uvm_config_db #(env_cfg) :: get(this,"","env_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Cant get the env config from vseqr");
		mst_seqrh = new[m_cfg.no_of_mst]; 
		slv_seqrh = new[m_cfg.no_of_slv]; 
		
endfunction 

endclass







