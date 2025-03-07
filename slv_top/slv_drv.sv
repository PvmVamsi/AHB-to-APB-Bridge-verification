class slv_drv extends uvm_driver#(slv_xtn);
	`uvm_component_utils(slv_drv)

	function new(string name = "slv_drv",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	virtual slv_if.slv_drv_mp vif;
	slv_cfg m_cfg;
	
	function void build_phase (uvm_phase phase);
		if(!uvm_config_db#(slv_cfg)::get(this,"","slv_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"cant get m-cfg from slv_drv")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		req = slv_xtn::type_id::create("req");
		forever
			begin
				drive(req);
			end
	endtask
	
	task drive(slv_xtn xtn);
			
			while(vif.drv_cb.PSELX === 0 )
				@(vif.drv_cb);

	
			if(vif.drv_cb.PWRITE == 0) begin
				//while(vif.drv_cb.PENABLE !==1)
				//	@(vif.drv_cb);
				vif.drv_cb.PRDATA <= {$urandom};
				//`uvm_info(get_type_name(),$sformatf("SLV DRV"),UVM_LOW)  
			end
				@(vif.drv_cb);
				
		  

				
	endtask
endclass
