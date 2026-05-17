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

    // add constraints for transaction data if required
    // data constraint example:
    // constraint c_data {data_to_DUT >= 0;}

    function new(string name = "");
        super.new(name);
    endfunction: new

    // Example of convert2string(): Modify to your liking
    function string convert2string();
        string s;
        $sformat(s, "%s\n", super.convert2string());
        $sformat(s, "%s DATA_TO:\t%h\n DATA_FROM:\t%h\n R_ENABLE:\t%b\n W_ENABLE:\t%b\n EMPTY:\t%b\n FULL:\t%b\n ONE_P:\t%b\n ONE_D:\t%b\n", s, data_to_DUT, data_from_DUT, read_enable, write_enable, empty, full, one_p, one_d);
        return s;
    endfunction:convert2string

    virtual function void do_copy(uvm_object rhs);
        transaction _tx;
        if (!$cast(_tx, rhs))
            `uvm_fatal("transaction", "Cast error when copying")
        super.do_copy(rhs);
        data_to_DUT = _tx.data_to_DUT;
        write_enable = _tx.write_enable;
        read_enable = _tx.read_enable;
        rst_n = _tx.rst_n;
        data_from_DUT = _tx.data_from_DUT;
        full = _tx.full;
        empty = _tx.empty;
        one_p = _tx.one_p;
        one_d = _tx.one_d;
    endfunction

endclass: transaction
