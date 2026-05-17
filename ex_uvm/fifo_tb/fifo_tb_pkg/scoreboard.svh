class scoreboard extends uvm_scoreboard;

    `uvm_component_utils(scoreboard)

uvm_analysis_imp #(transaction, scoreboard) analysis_export;

    // Adding variable handles for DUT configuration and DUT interface
    dut_config dut_cfg;
    virtual dut_if dut_vi;

    // Transaction variable
    transaction sample_tx;

// FIFO model (simple queue to model the DUT's FIFO behavior)
    int fifo_size = 5;
    bit [7:0] fifo_model[$];

// Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction: new

// Write function for handling transactions
function void write(transaction t);
    sample_tx = t;
    
    // Fetch the DUT configuration from uvm_config_db
    if (!uvm_config_db #(dut_config)::get(this, "", "dut_configuration", dut_cfg))
        `uvm_error("NOVIF", "No virtual interface set");

    // Debug print
    `uvm_info("scoreboard", "Created scoreboard", UVM_HIGH)

    // Connect the virtual interface to the DUT
    dut_vi = dut_cfg.dut_vi;

       // Check FIFO state and handle read/write
        if (dut_vi.empty_in) begin
            // Handle empty condition (e.g., verify no data should be read)
            if (dut_vi.re_out) begin
                // If attempting to read from an empty FIFO, this is an error
                `uvm_error("EMPTY_FIFO", "Attempted read from empty FIFO");
            end
            `uvm_info("scoreboard", "FIFO is empty, no data to read", UVM_HIGH)
        end else if (dut_vi.full_in) begin
            // Handle full condition (e.g., verify no data should be written)
            if (dut_vi.we_out) begin
                // If attempting to write to a full FIFO, this is an error
                `uvm_error("FULL_FIFO", "Attempted write to full FIFO");
            end
            `uvm_info("scoreboard", "FIFO is full, no space to write", UVM_HIGH)
        end else begin
            // Normal operation: FIFO is neither full nor empty

            // Write operation
            if (dut_vi.we_out) begin
                // Model the write to FIFO by adding data to fifo_model
                fifo_model.push_front(dut_vi.data_to_DUT);
                // Check FIFO overflow (should not happen here)
                if (fifo_model.size() > fifo_size) begin
                    `uvm_error("FIFO_OVERFLOW", "FIFO overflow detected!");
                end
                `uvm_info("scoreboard", $sformatf("Wrote data: %0h to FIFO", dut_vi.data_to_DUT), UVM_HIGH)
            end

            // Read operation
            if (dut_vi.re_out) begin
                // Model the read from FIFO by removing data from fifo_model
                if (fifo_model.size() > 0) begin
                    bit [7:0] expected_data = fifo_model.pop_back();
                    if (dut_vi.data_from_DUT != expected_data) begin
                        `uvm_error("MISMATCH", $sformatf("Data mismatch: expected %0h, got %0h", expected_data, dut_vi.data_from_DUT));
                    end
                    `uvm_info("scoreboard", $sformatf("Read data: %0h from FIFO", expected_data), UVM_HIGH)
                end else begin
                    // Error: FIFO is empty but a read was requested
                    `uvm_error("READ_EMPTY_FIFO", "Attempted to read from an empty FIFO");
                end
            end
        end
    endfunction: write

endclass: scoreboard
