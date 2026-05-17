class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp #(transaction, scoreboard) analysis_export;

    transaction t;

    bit [31:0] fifo_queue [$:5];
    logic read_enable_last_cycle = 0;
    logic write_enable_last_cycle = 0;
    bit [31:0] tmp_read;
    bit [31:0] tmp_write;

    string temp_str;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        analysis_export = new("analysis_export", this);
    endfunction: new

    function void build_phase(uvm_phase phase);
        `uvm_info("scoreboard", "Created scoreboard", UVM_HIGH)
    endfunction: build_phase

    function void write(transaction tx_in);
        t = transaction::type_id::create("t");
        t.copy(tx_in);
        $swriteh(temp_str, "%p", fifo_queue);
        `uvm_info("scoreboard", $sformatf("Real size before %d", fifo_queue.size()), UVM_HIGH);
        `uvm_info("scoreboard", $sformatf("Queue before: %s", temp_str), UVM_HIGH);
        `uvm_info("scoreboard", $sformatf("Read enable last cycle: %b", read_enable_last_cycle), UVM_HIGH);
        `uvm_info("scoreboard", $sformatf("Write enable last cycle: %b", write_enable_last_cycle), UVM_HIGH);
        if (t.empty) begin
            assert (fifo_queue.size() == 0) else
                `uvm_error("scoreboard", $sformatf("Expected empty, real size %d", fifo_queue.size()));
        end
        if (fifo_queue.size() == 0 && !write_enable_last_cycle) begin
            assert(t.empty) else
                `uvm_error("scoreboard", $sformatf("Expected empty signal, scoreboard fifo queue size %d", fifo_queue.size()));
        end
        if (t.full) begin
            assert (fifo_queue.size() == 5) else
                `uvm_error("scoreboard", $sformatf("Expected scoreboard fifo full, but queue size %d", fifo_queue.size()));
        end
        if (fifo_queue.size() == 5 && !read_enable_last_cycle) begin
            assert(t.full) else
                `uvm_error("scoreboard", $sformatf("Expected full signal, scoreboard fifo queue size %d", fifo_queue.size()));
        end
        if (t.one_d) begin
                assert (fifo_queue.size() == 1) else
                    `uvm_error("scoreboard", $sformatf("Expected scoreboard fifo one data, but queue size %d", fifo_queue.size()));
        end
        if (fifo_queue.size() == 1 && !read_enable_last_cycle && !write_enable_last_cycle) begin
            assert(t.one_d) else
                `uvm_error("scoreboard", $sformatf("Expected one data left signal, scoreboard fifo queue size %d", fifo_queue.size()));
        end
        if (t.one_p) begin
                assert (fifo_queue.size() == 4) else
                    `uvm_error("scoreboard", $sformatf("Expected scoreboard fifo one place left, but queue size %d", fifo_queue.size()));
        end
        if (fifo_queue.size() == 4 && !write_enable_last_cycle && !read_enable_last_cycle) begin
            assert(t.one_p) else
                `uvm_error("scoreboard", $sformatf("Expected one place left signal, scoreboard fifo queue size %d", fifo_queue.size()));
        end
        if (read_enable_last_cycle) begin
            read_enable_last_cycle <= 0;
            if (fifo_queue.size() > 0 && !t.empty) begin // reads can't happen on empty queue
                tmp_read = fifo_queue.pop_front();
                assert (tmp_read == t.data_from_DUT )
                else begin
                    `uvm_error("scoreboard", $sformatf("Read enable check, expected %h, got %h.", tmp_read, t.data_from_DUT));
                end
            end
        end
        // Writes must happen after reads according to spec
        if (write_enable_last_cycle) begin
            write_enable_last_cycle <= 0;
            if (fifo_queue.size() < 5 && !t.full) begin
                if (!t.full) begin // but read & write to a full queue can't happen at the same clock cycle, write is skipped
                    fifo_queue.push_back(tmp_write);
                end;
            end
        end
        if (t.write_enable) begin
                write_enable_last_cycle <= 1;
                tmp_write <= t.data_to_DUT;
        end
        if (t.read_enable) begin
            read_enable_last_cycle <= 1;
        end

        `uvm_info("scoreboard", $sformatf("Real size after %d", fifo_queue.size()), UVM_HIGH);
        $swriteh(temp_str, "%p", fifo_queue);
        `uvm_info("scoreboard", $sformatf("Queue after: %s", temp_str), UVM_HIGH);
        
    endfunction: write

endclass: scoreboard