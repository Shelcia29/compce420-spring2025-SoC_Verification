// ----------------------------------------------------------------------------
// transaction.svh
// ----------------------------------------------------------------------------
// Transaction class
// Responsible for containing a single packetful of transaction data
// and the constraints for it
// ----------------------------------------------------------------------------
// Note: extending uvm_sequence_item, not its parent uvm_transaction
// ----------------------------------------------------------------------------

class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction)

    // transaction data here (i.e. DUT's data, write_enable etc..)
    rand bit  [31:0]  data_to_DUT;
    rand bit          write_enable;
    rand bit          read_enable;
    bit	              rst_n;
    bit       [31:0]  data_from_DUT;
    bit               full;
    bit	              empty;
    bit	              one_p;
    bit	              one_d;
    rand bit  [31:0]  data;

    // add constraints for transaction data if required
    // data constraint example:
    constraint c_data {data >= 0; data < 1024;}
    //constraint c_data {data_to_DUT >= 0; data_to_DUT < 1024;}
    //constraint c_data {data_from_DUT >= 0; data_from_DUT < 1024;}

    // Constraints randomizing write_enable example:
    // sets the write enable signal high once in every 10 clock cycles on average
    constraint c_we_dist { write_enable dist { 0 := 9 , 1 := 1 }; }
    constraint c_re_dist { read_enable dist { 0 := 9 , 1 := 1 }; }

    function new(string name = "");
        super.new(name);
    endfunction: new

    // Example of convert2string(): Modify to your liking
    function string convert2string();
        string s;
        $sformat(s, "%s\n", super.convert2string());
        $sformat(s, "%s DATA_TO:\t%8h\n DATA_FROM:\t%8h\n", s, data_to_DUT, data_from_DUT);
        return s;
    endfunction:convert2string

endclass: transaction
