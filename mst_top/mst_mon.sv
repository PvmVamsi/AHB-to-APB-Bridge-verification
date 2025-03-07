class mst_mon extends uvm_monitor;
	`uvm_component_utils(mst_mon)

	function new(string name = "mst_mon",uvm_component parent = null);
		super.new(name,parent);
		mst_port = new("mst_port",this);
	endfunction

	virtual mst_if.mst_mon_mp vif;
	mst_cfg m_cfg;
	uvm_analysis_port#(mst_xtn) mst_port;
	
	function void build_phase (uvm_phase phase);
		if(!uvm_config_db#(mst_cfg)::get(this,"","mst_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"cant get m-cfg from mst_mon")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
	endfunction


	task run_phase(uvm_phase phase);
	
		forever begin
	      	
			monitor();
		end
	endtask

	task monitor();
        	mst_xtn xtn;
        	xtn = mst_xtn::type_id::create("xtn");
			
		while(vif.mon_cb.HREADYout !== 1)
			@(vif.mon_cb);

		while(vif.mon_cb.HTRANS !== 2'b10 && vif.mon_cb.HTRANS !== 2'b11)
			@(vif.mon_cb);
         		
		xtn.HTRANS = vif.mon_cb.HTRANS;
         	xtn.HWRITE = vif.mon_cb.HWRITE;
         	xtn.HSIZE  = vif.mon_cb.HSIZE;
        	xtn.HADDR  = vif.mon_cb.HADDR;
         	xtn.HREADYout = vif.mon_cb.HREADYout;
	        @(vif.mon_cb);

	        
		while(vif.mon_cb.HREADYout !== 1)
			@(vif.mon_cb);

		if (vif.mon_cb.HWRITE === 1'b1) 
        		xtn.HWDATA = vif.mon_cb.HWDATA;
		
		else
			xtn.HRDATA = vif.mon_cb.HRDATA;
		
		//`uvm_info(get_type_name(),$sformatf("MST MONITORED DATA %s",xtn.sprint()),UVM_LOW)    
		mst_port.write(xtn);
       	endtask
endclass
