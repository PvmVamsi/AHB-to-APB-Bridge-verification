//Scoreboard
class sb extends uvm_scoreboard;
	`uvm_component_utils(sb)
	 //tlm analysis fifo ports	
	uvm_tlm_analysis_fifo#(mst_xtn) mst_fifoh[];
	uvm_tlm_analysis_fifo#(slv_xtn) slv_fifoh[];
	
	//config
	env_cfg m_cfg;
	
	mst_xtn m;
	slv_xtn s;

	mst_xtn m_c;
	slv_xtn s_c;

	int data_verified_count ;
//uvm methods
function new(string name ="sb",uvm_component parent = null);
	super.new(name,parent);
	ahb  = new();
        apb = new();
	
endfunction

//coverage for AHB
	covergroup ahb;
		option.per_instance = 1;

		HSIZE: coverpoint m_c.HSIZE {bins b1[] = {[0:2]} ;}
		
		HTRANS: coverpoint m_c.HTRANS {bins trans[] = {[2:3]} ;}
		
		HADDR: coverpoint m_c.HADDR {bins slave1 = {[32'h8000_0000:32'h8000_03ff]} ;
					     bins slave2 = {[32'h8400_0000:32'h8400_03ff]};
                                             bins slave3 = {[32'h8800_0000:32'h8800_03ff]};
                                             bins slave4 = {[32'h8C00_0000:32'h8C00_03ff]};}

		HWRITE : coverpoint m_c.HWRITE{bins w[] = {0,1};}

		SIZEXWRITE: cross HSIZE, HWRITE,HADDR,HTRANS;
	endgroup

	covergroup apb;
		option.per_instance = 1;
		
		PADDR : coverpoint s_c.PADDR {bins slave1 = {[32'h8000_0000:32'h8000_03ff]} ;
					     bins slave2 = {[32'h8400_0000:32'h8400_03ff]};
                                             bins slave3 = {[32'h8800_0000:32'h8800_03ff]};
                                             bins slave4 = {[32'h8C00_0000:32'h8C00_03ff]};}
		

                PWRITE : coverpoint s_c.PWRITE{bins w[] = {0,1};}
                PSEL : coverpoint s_c.PSELX {bins sel[] = {1,2,4,8};}

		WRITEXSEL: cross PWRITE,PSEL;
		
	endgroup

function void build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_cfg) :: get(this,"","env_cfg",m_cfg))
			`uvm_fatal(get_type_name(),"Cant get the env config from sb");
	mst_fifoh = new[m_cfg.no_of_mst];
	foreach(mst_fifoh[i])
		mst_fifoh[i] = new($sformatf("mst_fifoh[%0d]",i),this);

	slv_fifoh = new[m_cfg.no_of_slv];
	foreach(slv_fifoh[i])
		slv_fifoh[i] = new($sformatf("slv_fifoh[%0d]",i),this);

endfunction



task run_phase (uvm_phase phase);
forever begin
	fork
	
		
		begin
			mst_fifoh[0].get(m);
			`uvm_info(get_type_name(),$sformatf("MST %s",m.sprint()),UVM_LOW)
			m_c = new m;
			ahb.sample();
			
		end

		begin
			slv_fifoh[0].get(s);
			`uvm_info(get_type_name(),$sformatf("SLV %s",s.sprint()),UVM_LOW)
			s_c = new s;
			apb.sample();
			
		end
	join
	check_data(m,s);
end
endtask

function void check_data(mst_xtn m,slv_xtn s);
             	
        if(m.HWRITE)
		begin
			if(m.HSIZE==0) begin
				if(m.HADDR[1:0]==2'b00)
					compare(m.HWDATA[7:0],s.PWDATA,m.HADDR,s.PADDR);
				if(m.HADDR[1:0]==2'b01)
					compare(m.HWDATA[15:8],s.PWDATA,m.HADDR,s.PADDR);
				if(m.HADDR[1:0]==2'b10)
					compare(m.HWDATA[23:16],s.PWDATA,m.HADDR,s.PADDR);
				if(m.HADDR[1:0]==2'b11)
					compare(m.HWDATA[31:24],s.PWDATA,m.HADDR,s.PADDR);
			end
			if(m.HSIZE==1) begin
				if(m.HADDR[1:0]==2'b00)
					compare(m.HWDATA[15:0],s.PWDATA,m.HADDR,s.PADDR);
				if(m.HADDR[1:0]==2'b10)
					compare(m.HWDATA[31:16],s.PWDATA,m.HADDR,s.PADDR);
			end
			if(m.HSIZE==2) begin
				compare(m.HWDATA,s.PWDATA,m.HADDR,s.PADDR);
				end
		end
	if(!m.HWRITE)
		begin
			if(m.HSIZE==0) begin
				if(m.HADDR[1:0]==2'b00)
					compare(m.HWDATA[31:0],s.PWDATA[7:0],m.HADDR,s.PADDR);
				if(m.HADDR[1:0]==2'b01)
					compare(m.HWDATA[31:0],s.PWDATA[15:8],m.HADDR,s.PADDR);
				if(m.HADDR[1:0]==2'b10)
					compare(m.HWDATA[31:0],s.PWDATA[23:16],m.HADDR,s.PADDR);
				if(m.HADDR[1:0]==2'b11)
					compare(m.HWDATA[31:0],s.PWDATA[31:24],m.HADDR,s.PADDR);
			end
			if(m.HSIZE==1) begin
				if(m.HADDR[1:0]==2'b00)
					compare(m.HWDATA[31:0],s.PWDATA[15:0],m.HADDR,s.PADDR);
				if(m.HADDR[1:0]==2'b10)
					compare(m.HWDATA[31:0],s.PWDATA[31:16],m.HADDR,s.PADDR);
			end
			if(m.HSIZE==2) begin
				compare(m.HWDATA,s.PWDATA,m.HADDR,s.PADDR);
				end
		end
        
endfunction


function void compare(int Hdata, Pdata, Haddr, Paddr);

        if(Haddr == Paddr)
	begin
                $display("Address compared Successfully");
		//$display("HADDR=%h, PADDR=%h", Haddr, Paddr);
	end
        else
        begin
                $display("Address not compared Successfully");
		//$display("HADDR=%d, PADDR=%d", Haddr, Paddr);
        end

        if(Hdata == Pdata) 
	begin
                $display("Data compared Successfully");
		//$display("HDATA=%h, PDATA=%h", Hdata, Pdata);
	end
        else
        begin
                $display("Data not compared Successfully");
		//$display("HDATA=%d, PDATA=%d", Hdata, Pdata);
        end

        data_verified_count ++;
	$display ("Data verified = %d", data_verified_count);
endfunction


endclass



   
