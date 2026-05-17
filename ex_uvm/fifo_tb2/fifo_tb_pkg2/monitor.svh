class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    dut_config dut_cfg;
    virtual dut_if dut_vi;

    uvm_analysis_port #(transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        `uvm_info("monitor", "Created monitor", UVM_HIGH)
        if( !uvm_config_db #(dut_config)::get(this, "","dut_configuration", dut_cfg) )
	        `uvm_fatal("NOVIF", "No virtual interface set");
        dut_vi = dut_cfg.dut_vi;

        // Create analysis port
        ap = new("ap", this);
    endfunction: build_phase


    task run_phase(uvm_phase phase);
        `uvm_info("monitor", "Monitor run phase", UVM_HIGH)
        forever begin
            transaction tx;
            @(posedge dut_vi.clk);
            tx = transaction::type_id::create("tx");
            tx.data_to_DUT = dut_vi.data_to_DUT;
            tx.write_enable = dut_vi.we_out;
            tx.read_enable = dut_vi.re_out;
            tx.rst_n = dut_vi.rst_n;
            tx.data_from_DUT = dut_vi.data_from_DUT;
            tx.full = dut_vi.full_in;
            tx.empty = dut_vi.empty_in;
            tx.one_p = dut_vi.one_p_in;
            tx.one_d = dut_vi.one_d_in;
            `uvm_info("monitor", "Got data", UVM_HIGH)
            `uvm_info("monitor", $sformatf("This is what I saw: %s", tx.convert2string()), UVM_HIGH)

            // Write transaction to analysis port
            ap.write(tx);
        end
    endtask: run_phase

endclass: monitor