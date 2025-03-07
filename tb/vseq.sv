//virtual seqs
class vseq extends uvm_sequence#(uvm_sequence_item);
	`uvm_object_utils(vseq)
	
	//handle of virtual sequencer
	vseqr vseqrh;
	
	//handle of env_cfg
	env_cfg m_cfg;
	
	//array of src and dst sequenccers
	mst_seqr mst_seqrh[];
	slv_seqr slv_seqrh[];

	//base sequences
	single_trans single_transh;
	incr_trans incr_transh;
	wrap_trans wrap_transh;


function new(string name = "vseq");
	super.new(name);
endfunction

task body();
	if(!uvm_config_db#(env_cfg) :: get(null,get_full_name(),"env_cfg",m_cfg))
		`uvm_fatal(get_type_name(),"Cant get env_cfg from vseqs");
	

	$cast(vseqrh,m_sequencer);
	mst_seqrh = new[m_cfg.no_of_mst];
	slv_seqrh = new[m_cfg.no_of_slv];

	foreach(mst_seqrh[i])
		mst_seqrh[i] = vseqrh.mst_seqrh[i];
	foreach(slv_seqrh[i])
		slv_seqrh[i] = vseqrh.slv_seqrh[i];
endtask


endclass


class single_vseq extends vseq;

	`uvm_object_utils(single_vseq)

function new(string name = "single_vseq");
	super.new(name);
endfunction

task body();
	super.body();
	single_transh = single_trans :: type_id :: create("single_transh");
	single_transh.start(mst_seqrh[0]);
endtask


endclass

class incr_vseq extends vseq;

	`uvm_object_utils(incr_vseq)

function new(string name = "incr_vseq");
	super.new(name);
endfunction

task body();
	super.body();
	incr_transh = incr_trans :: type_id :: create("incr_transh");
	incr_transh.start(mst_seqrh[0]);
endtask


endclass
class wrap_vseq extends vseq;

	`uvm_object_utils(wrap_vseq)

function new(string name = "wrap_vseq");
	super.new(name);
endfunction

task body();
	super.body();
	wrap_transh = wrap_trans :: type_id :: create("wrap_transh");
	wrap_transh.start(mst_seqrh[0]);
endtask

endclass

