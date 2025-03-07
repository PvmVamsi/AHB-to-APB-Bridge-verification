class mst_agt extends uvm_agent;
	`uvm_component_utils(mst_agt)
	
	function new(string name = "mst_agt",uvm_component parent = null);
		super.new(name,parent);
	endfunction
		
	mst_mon monh;
	mst_seqr seqrh;
	mst_drv drvh;
	
	mst_cfg m_cfg;

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db#(mst_cfg)::get(this,"","mst_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Cant get mst_cfg from mst_agt")

		monh = mst_mon::type_id::create("monh",this);
	
		if(m_cfg.is_active == UVM_ACTIVE);
			begin
			seqrh = mst_seqr::type_id::create("seqrh",this);
			drvh = mst_drv::type_id::create("drvh",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
			drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction
endclass
