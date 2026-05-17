// ----------------------------------------------------------------------------
// coverage_collector.svh
// ----------------------------------------------------------------------------
// UVM Subscriber class
// Coverage collector
//
// Checks coverage for key and encrypted data, address and AXI response
//
// ----------------------------------------------------------------------------
class coverage_collector extends uvm_subscriber #(axi_transaction);
    `uvm_component_utils(coverage_collector)
    axi_transaction sample_tx;
        
    covergroup cg;
        
        // TODO: Improve the coverpoint for address
        c_address   : coverpoint sample_tx.address{
			// TODO
		bins low_range     	= { [32'h0000_0000 : 32'h0000_0FFF] };
		bins mid_range     	= { [32'h0000_1000 : 32'h0000_1FFF] };
		bins key_range     	= { `KEY_ADDR };
		bins data_range    	= { `DATA_ADDR };
		bins less_freq_range    = { [32'h0000_3000 : 32'h0000_3FFF] };
		bins high_range    	= { [32'h0000_3000 : 32'h0000_3FFF] };
        }
        
        c_data      : coverpoint sample_tx.data;
        // Name the bins in the response coverpoint for clarity
        c_response  : coverpoint sample_tx.response{
            bins OK            = {'b00};
			// should not exist
            //bins EXOK        = {'b01};
            bins SLVERR        = {'b10};
            bins DECERR        = {'b11};
            // EXOK goes into the illegal bin
            illegal_bins ERROR = default;
        }
        
        // Check all values of KEY and ENCRYPTED data
        // ignore all other bins in the cross
		// == Cross address and data using only address values `KEY_ADDR,`DATA_ADDR
        c_encrypted_key : cross c_address, c_data{
            ignore_bins addr_out_of_range = !binsof(c_address)
                intersect {`KEY_ADDR,`DATA_ADDR};
        }
        
        endgroup: cg
  
    function new(string name, uvm_component parent);
        super.new(name,parent);
        cg = new();
    endfunction: new

    function void build_phase(uvm_phase phase);

        // Debug prints
        `uvm_info("coverage_collector", "Created coverage collector", UVM_HIGH)
    
    endfunction: build_phase
    
    // Can be called from the outside
    function real get_cg_coverage();
        return cg.get_coverage();
    endfunction: get_cg_coverage
    
    // Sample the transaction and update coverpoint bins
    function void write(axi_transaction t);
        sample_tx = t;
        cg.sample();
    endfunction: write
    
endclass: coverage_collector
