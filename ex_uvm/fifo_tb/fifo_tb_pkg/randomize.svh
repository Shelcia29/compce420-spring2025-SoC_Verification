// ----------------------------------------------------------------------------
// randomize.svh
// ----------------------------------------------------------------------------

class randomize_seq extends basic_sequence;
    `uvm_object_utils(randomize_seq)

    function new(string name = "");
        super.new(name);
    endfunction: new

    task body;
    	repeat (100) begin
    	       	// handle for a transaction object
    	       	transaction tx;
    	       	tx = transaction::type_id::create("tx");
    	       	
    	       	start_item(tx);
    	       	assert( tx.randomize() ); // transaction is randomised
    	       	finish_item(tx);
    	end
    endtask: body
endclass: randomize_seq
