class slv_agt extends uvm_agent;
	`uvm_component_utils(slv_agt)
	
	function new(string name = "slv_agt",uvm_component parent = null);
		super.new(name,parent);
	endfunction
		
	slv_mon monh;
	slv_seqr seqrh;
	slv_drv drvh;
	
	slv_cfg m_cfg;

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(slv_cfg)::get(this,"","slv_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Cant get slv_cfg from slv_agt")

		monh = slv_mon::type_id::create("monh",this);
	
		if(m_cfg.is_active == UVM_ACTIVE);
			begin
			seqrh = slv_seqr::type_id::create("seqrh",this);
			drvh = slv_drv::type_id::create("drvh",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
			drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction
endclass
