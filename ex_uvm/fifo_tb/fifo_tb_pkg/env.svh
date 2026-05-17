// ----------------------------------------------------------------------------
// env.svh
// ----------------------------------------------------------------------------
// UVM environment class
// ----------------------------------------------------------------------------

class env extends uvm_env;
    `uvm_component_utils(env)

    // Component handles
    agent agent_h;
    coverage_collector cvg_h;
    scoreboard sbd_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);

        // create agent
        agent_h = agent::type_id::create("agent_h",this);
	cvg_h = coverage_collector::type_id::create("cvg_h",this);
	sbd_h = scoreboard::type_id::create("sbd_h",this);

        // debug prints
        `uvm_info("env","Created environment",UVM_HIGH)

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);

        agent_h.ap.connect(cvg_h.analysis_export);
        `uvm_info("env", "Connected agent's analysis port to coverage collector", UVM_HIGH)
        
        agent_h.ap.connect(sbd_h.analysis_export);
        `uvm_info("env", "Connected agent's analysis port to scoreboard", UVM_HIGH)
        
    endfunction: connect_phase
    
endclass: env
