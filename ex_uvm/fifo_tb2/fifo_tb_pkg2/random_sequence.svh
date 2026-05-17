class random_sequence extends basic_sequence;
    `uvm_object_utils(random_sequence)

    function new(string name = "");
        super.new(name);
    endfunction: new

    task body;
        // handle for a transaction object
        transaction tx;
        tx = transaction::type_id::create("tx");
        repeat(10000) begin
            start_item(tx);
            assert( tx.randomize() );
            finish_item(tx);
        end

    endtask: body

endclass: random_sequence
