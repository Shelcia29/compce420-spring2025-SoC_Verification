// ----------------------------------------------------------------------------
// agent.svh
// ----------------------------------------------------------------------------
// UVM agent class
// ----------------------------------------------------------------------------

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    // component handles
    sequencer seqr_h;
    driver    drv_h;
    monitor monitor_h;

    uvm_analysis_port #(transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);

        // create components
        seqr_h = sequencer::type_id::create("seqr_h",this);
        drv_h  =    driver::type_id::create("drv_h", this);
        monitor_h = monitor::type_id::create("monitor_h", this);

        // Create analysis port
        ap = new("ap", this);

        // debug prints
        `uvm_info("agent","Created agent",UVM_HIGH)

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);

        // connect driver's port (input) to the sequencer's export (output)
        drv_h.seq_item_port.connect(seqr_h.seq_item_export);

        // Connect analysis port to monitor
        monitor_h.ap.connect(ap);

    endfunction: connect_phase

endclass: agent
