`timescale 1ns / 1ps

module tb_smart_traffic_controller;

    reg clk;
    reg rst;
    wire [1:0] TL1, TL2, TL3, TL4;

    smart_traffic_controller uut (
        .clk(clk),
        .rst(rst),
        .TL1(TL1),
        .TL2(TL2),
        .TL3(TL3),
        .TL4(TL4)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #20;       
        rst = 0;
        #200;

        $finish;
    end

    initial begin
        $monitor("Time=%0t | TL1=%b TL2=%b TL3=%b TL4=%b", 
                  $time, TL1, TL2, TL3, TL4);
    end

endmodule
