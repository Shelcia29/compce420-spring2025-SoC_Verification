// ----------------------------------------------------------------------------
// env.svh
// ----------------------------------------------------------------------------
// UVM environment class
// ----------------------------------------------------------------------------

class env extends uvm_env;
    `uvm_component_utils(env)

    // Component handles
    agent agent_h;
    coverage_collector coverage_collector_h;
    scoreboard scoreboard_h;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);

        // create agent
        agent_h = agent::type_id::create("agent_h",this);

        // create coverage collector
        coverage_collector_h = coverage_collector::type_id::create("coverage_collector_h", this);

        // create scoreboard
        scoreboard_h = scoreboard::type_id::create("scoreboard_h", this);

        // debug prints
        `uvm_info("env","Created environment",UVM_HIGH)

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        // Connect analysis port to coverage collector
        agent_h.ap.connect(coverage_collector_h.analysis_export);
        // Connect analysis port to scoreboard
        agent_h.ap.connect(scoreboard_h.analysis_export);
    endfunction: connect_phase
    
endclass: env
