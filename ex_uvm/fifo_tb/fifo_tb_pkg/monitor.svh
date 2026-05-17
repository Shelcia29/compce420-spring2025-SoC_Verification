//....................................................................................
//....................................................................................
//monitor.svh
//UVM monitor class
//....................................................................................
//....................................................................................

class monitor extends uvm_monitor;

	`uvm_component_utils(monitor)

	uvm_analysis_port #(transaction) ap;


//adding variable handles for DUT configuration and DUT interface

dut_config dut_cfg;
virtual dut_if dut_vi;

//component handles
	
	//monitor mntr_h;

   	function new(string name, uvm_component parent);
        	super.new(name,parent);
   	endfunction: new

//build phase

	function void build_phase(uvm_phase phase);
	
	// create agent
        //mntr_h = monitor::type_id::create("mntr_h",this);
	ap = new("ap", this);

	//The config wrapper can be fetched in the build phase by calling uvm_config_db:

	if( !uvm_config_db #(dut_config)::get(this, "","dut_configuration", dut_cfg) )
	`uvm_error("NOVIF", "No virtual interface set");

	//debug print
	`uvm_info("monitor", "Created monitor", UVM_HIGH)

        // Connect the virtual interface to the DUT
		dut_vi = dut_cfg.dut_vi;

	endfunction: build_phase


//run phase

	task run_phase(uvm_phase phase);
		forever begin
		transaction tx;
		@(posedge dut_vi.clk);
		tx = transaction::type_id::create("tx");
		
		tx.data_to_DUT = dut_vi.data_to_DUT;
		tx.data_from_DUT = dut_vi.data_from_DUT;
		tx.read_enable = dut_vi.read_enable;
		tx.write_enable = dut_vi.write_enable;

		`uvm_info("monitor", "Got data", UVM_HIGH)
		
		ap.write(tx);

		end
	endtask: run_phase


endclass: monitor


	
