`include "environment.sv"
class test;
    environment env;

    function new(virtual ahb_if vif);
        env = new(vif);
    endfunction

    task run();
        env.run();
    endtask
endclass
