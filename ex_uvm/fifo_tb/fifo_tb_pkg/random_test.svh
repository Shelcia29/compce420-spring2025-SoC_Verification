// ----------------------------------------------------------------------------
// random_test.svh
// ----------------------------------------------------------------------------
// Instantiates the environment and runs a basic example of randomise sequence
// ----------------------------------------------------------------------------

class random_test extends test_base;
    `uvm_component_utils(random_test)

    randomize_seq ran_h;

    // configuration wrapper for DUT interface
    dut_config dut_cfg;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);

	super.build_phase (phase);

    endfunction: build_phase

    task run_phase(uvm_phase phase);
    	// create a sequence
        ran_h = randomize_seq::type_id::create("ran_h");

        // raise objection to notify that the testing isn't done yet
        phase.raise_objection(this);

        // start the sequencer
        ran_h.start( env_h.agent_h.seqr_h );

        // wait cycle before ending the simulation
        #2;

        // ready to stop
        phase.drop_objection(this);

    endtask: run_phase

endclass: random_test
