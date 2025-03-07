class slv_mon extends uvm_monitor;
	`uvm_component_utils(slv_mon)

	function new(string name = "slv_mon",uvm_component parent = null);
		super.new(name,parent);
		slv_port = new("slv_port",this);
	endfunction

	virtual  slv_if.slv_mon_mp vif;
	uvm_analysis_port #(slv_xtn) slv_port;

	slv_cfg m_cfg;
	
	function void build_phase (uvm_phase phase);
		if(!uvm_config_db#(slv_cfg)::get(this,"","slv_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"cant get m-cfg from slv_mon")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
			forever 
			monitor();
		
	endtask

	task monitor();
		slv_xtn xtn;
		xtn = slv_xtn::type_id::create("xtn");
		
		while(vif.mon_cb.PENABLE !==1)
			@(vif.mon_cb);
		xtn.PSELX = vif.mon_cb.PSELX;
		xtn.PWRITE = vif.mon_cb.PWRITE;
		xtn.PENABLE = vif.mon_cb.PENABLE;
		xtn.PADDR = vif.mon_cb.PADDR;
		if(xtn.PWRITE)
			xtn.PWDATA = vif.mon_cb.PWDATA;
		else
			xtn.PRDATA = vif.mon_cb.PRDATA;
		@(vif.mon_cb)
		slv_port.write(xtn);
	//	`uvm_info(get_type_name(),$sformatf("SLV MONITORED DATA %s",xtn.sprint()),UVM_LOW)   
	endtask
endclass
