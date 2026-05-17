class coverage_collector extends uvm_subscriber #(transaction);

    `uvm_component_utils(coverage_collector)

    // Declare the covergroup
    covergroup cg;
        //c_data_to_DUT : coverpoint sample_tx.data_to_DUT;
        //c_data_from_DUT : coverpoint sample_tx.data_from_DUT;
	coverpoint sample_tx.data_to_DUT;
	coverpoint sample_tx.data_from_DUT;
	coverpoint sample_tx.read_enable;
	coverpoint sample_tx.write_enable;
	
    endgroup: cg

    // Adding variable handles for DUT configuration and DUT interface
    dut_config dut_cfg;
    virtual dut_if dut_vi;

    // Transaction variable
    transaction sample_tx;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction: new

    // Build phase
    function void build_phase(uvm_phase phase);
        

        /*// Fetch config wrapper
        if (!uvm_config_db #(dut_config)::get(this, "", "dut_configuration", dut_cfg))
            `uvm_fatal("NOVIF", "No virtual interface set");*/

        // Debug print
        `uvm_info("coverage_collector", "Created coverage_collector", UVM_HIGH)

        // Connect the virtual interface to the DUT
        //dut_vi = dut_cfg.dut_vi;
    endfunction: build_phase

    // Connect phase
    function void connect_phase(uvm_phase phase);
        
    endfunction: connect_phase

    // Write function

    function void write(transaction t);
        sample_tx = t;
        cg.sample();
    endfunction: write

endclass: coverage_collector

