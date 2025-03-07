class mst_drv extends uvm_driver#(mst_xtn);
	`uvm_component_utils(mst_drv)

	function new(string name = "mst_drv",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	virtual mst_if.mst_drv_mp vif;
	mst_cfg m_cfg;
	
	function void build_phase (uvm_phase phase);
		if(!uvm_config_db#(mst_cfg)::get(this,"","mst_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"cant get m-cfg from mst_drv")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
		
	endfunction

	task run_phase(uvm_phase phase);
		
       		 @(vif.drv_cb);
       		 vif.drv_cb.HRESETn <= 1'b0;
               	@(vif.drv_cb);
       		
		vif.drv_cb.HRESETn <= 1'b1;
        			
		forever
			begin
				seq_item_port.get_next_item(req);
				driver(req);
				seq_item_port.item_done();
			end
	endtask

	task driver(mst_xtn xtn);
		
		while(vif.drv_cb.HREADYout !== 1)
			@(vif.drv_cb);
			
        	vif.drv_cb.HWRITE  <= xtn.HWRITE;
       		vif.drv_cb.HTRANS <= xtn.HTRANS;
        	vif.drv_cb.HSIZE   <= xtn.HSIZE;
        	vif.drv_cb.HADDR   <= xtn.HADDR;
        	vif.drv_cb.HREADYin<= 1'b1;
		
        	@(vif.drv_cb);

        
		while(vif.drv_cb.HREADYout !== 1)
			@(vif.drv_cb);
		if(xtn.HWRITE)
                	vif.drv_cb.HWDATA<=xtn.HWDATA;
		else
			vif.drv_cb.HWDATA<=0;
		//`uvm_info(get_type_name(),$sformatf("MST DRIVING DATA %s",xtn.sprint()),UVM_LOW)    
	endtask
endclass
