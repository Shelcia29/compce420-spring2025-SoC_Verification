class coverage_collector extends uvm_subscriber #(transaction);
    `uvm_component_utils(coverage_collector)

    transaction sample_tx;

    covergroup cg;
        c_data_to_DUT : coverpoint sample_tx.data_to_DUT;
        c_write_enable: coverpoint sample_tx.write_enable;
        c_read_enable: coverpoint sample_tx.read_enable;
        c_rst_n: coverpoint sample_tx.rst_n;
        c_data_from_DUT: coverpoint sample_tx.data_from_DUT;
        c_full: coverpoint sample_tx.full;
        c_empty: coverpoint sample_tx.empty;
        c_one_p: coverpoint sample_tx.one_p;
        c_one_d: coverpoint sample_tx.one_d;

        c_write_enable_transitions: coverpoint sample_tx.write_enable {
            bins low_to_high = (0 => 1);
            bins high_to_low = (1 => 0);
        }

        c_one_p_transition_sequence: coverpoint sample_tx.one_p {
            bins edge_of_full = (0 => 1), (1 => 0), (0 => 1);
        }

        c_full_cross_write_enable: cross c_full, c_write_enable;

    endgroup: cg

    function new(string name, uvm_component parent);
        super.new(name,parent);
        cg = new();
    endfunction: new

    function void build_phase(uvm_phase phase);
        `uvm_info("coverage_collector", "Created coverage collector", UVM_HIGH)
    endfunction: build_phase

    function void write(transaction t);
        sample_tx = transaction::type_id::create("sample_tx");
        sample_tx.copy(t);
        cg.sample();
    endfunction: write

endclass: coverage_collector