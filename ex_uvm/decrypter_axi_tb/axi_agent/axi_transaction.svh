// ----------------------------------------------------------------------------
// axi_transaction.svh
// ----------------------------------------------------------------------------
// Transaction class
// Responsible for containing a single packetful of transaction data
// and the constraints for it
// ----------------------------------------------------------------------------

class axi_transaction extends uvm_sequence_item;
    `uvm_object_utils(axi_transaction)

    // transaction data here (i.e. DUT's data, write_enable etc..)
    rand bit [31:0] address;
    rand bit [31:0] data;
    bit      [31:0] response;
    
	// TODO: Add address constraints with distributions
	// We have set up addresses to fall into four memory ranges.
    
    	constraint c_address { address dist {
    	[32'h0000_0000 : 32'h0000_0FFF] :/ 50, // Low-range
    	[32'h0000_1000 : 32'h0000_1FFF] :/ 30, // Mid-range
    	[32'h0000_2000 : 32'h0000_2FFF] :/ 15, // Less frequent
    	[32'h0000_3000 : 32'h0000_3FFF] :/ 5   // High-range
    	}; }
  
    function new(string name = "");
        super.new(name);
    endfunction: new
    
    // Convert2string function: can be used in prints
    function string convert2string;
      return $psprintf("addr=%h, data=%h, resp=%0d", address, data, response);
    endfunction: convert2string
       
endclass: axi_transaction
