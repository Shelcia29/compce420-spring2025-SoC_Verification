// ----------------------------------------------------------------------------
// sequence.svh
// ----------------------------------------------------------------------------
// UVM sequence class
// Defines the transactions to be driven to the DUT
// ----------------------------------------------------------------------------
// Parameters (REQ,RSP) (request, response).
// RSP = REQ if not specified otherwise
// ----------------------------------------------------------------------------
// Note that sequences and transactions are objects, not components.
// - Different registration macro
// - Must have a default name in the constructor, no parent
// ----------------------------------------------------------------------------

class basic_sequence extends uvm_sequence #(transaction);
    `uvm_object_utils(basic_sequence)

    function new(string name = "");
        super.new(name);
    endfunction: new

    task body;
        // handle for a transaction object
        transaction tx;
	
        // write to the DUT
        tx = transaction::type_id::create("tx_write");
        start_item(tx);
        tx.data_to_DUT = 3;
        tx.write_enable = 1;
        tx.read_enable = 0;
        finish_item(tx);

	// read to the DUT
        tx = transaction::type_id::create("tx_read");
        start_item(tx);
        tx.data_to_DUT = 0; 
        tx.write_enable = 0;
        tx.read_enable = 1;
        finish_item(tx);

    endtask: body

endclass: basic_sequence
