// ----------------------------------------------------------------------------
// test_base.svh
// ----------------------------------------------------------------------------
// Instantiates the environment and runs a basic example sequence
// ----------------------------------------------------------------------------

class random_test extends test_base;
    `uvm_component_utils(random_test)

    // sequence handle
    random_sequence seq_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info("random_test", $sformatf("Random seed %d", $get_initial_random_seed()), UVM_HIGH)
    endfunction: start_of_simulation_phase

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    task run_phase(uvm_phase phase);

        // raise objection to notify that the testing isn't done yet
        phase.raise_objection(this);

        // create a sequence
        seq_h = random_sequence::type_id::create("seq_h");

        // start the sequencer
        seq_h.start( env_h.agent_h.seqr_h );

        // wait 1 cycle before ending the simulation
        #2;

        // ready to stop
        phase.drop_objection(this);

    endtask: run_phase

endclass: random_test
