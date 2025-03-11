class uart_gen;
   
    rand uart_transaction transaction;
    mailbox gen2driv;
    int repeat_count;
    event ended;
   
    function new(mailbox gen2driv,event ended);
        this.gen2driv = gen2driv;
        this.ended = ended;
    endfunction
    
    task main;
        repeat(repeat_count) begin
        transaction= new();
        if(!transaction.randomize()) $fatal("Randomization failed");
            gen2driv.put(transaction);
        end
        -> ended;
        endtask
     
   endclass