`timescale 1ns / 1ps

module adv_smart_traffic_controller_tb;

    parameter GREEN_MIN    = 10;
    parameter GREEN_MAX    = 20;
    parameter YELLOW_TIME  = 5;
    parameter RED_BUFFER   = 3;

    reg clk = 0;
    reg rst;

    reg sensor_s1, sensor_s2, sensor_s3, sensor_s4;
    reg ped_s1, ped_s2, ped_s3, ped_s4;
    reg emergency_s1, emergency_s2, emergency_s3, emergency_s4;
    wire [1:0] TL1, TL2, TL3, TL4;

    adv_smart_traffic_controller #(
        .GREEN_MIN(GREEN_MIN),
        .GREEN_MAX(GREEN_MAX),
        .YELLOW_TIME(YELLOW_TIME),
        .RED_BUFFER(RED_BUFFER)
    ) dut (
        .clk(clk),
        .rst(rst),
        .sensor_s1(sensor_s1), .sensor_s2(sensor_s2),
        .sensor_s3(sensor_s3), .sensor_s4(sensor_s4),
        .ped_s1(ped_s1), .ped_s2(ped_s2),
        .ped_s3(ped_s3), .ped_s4(ped_s4),
        .emergency_s1(emergency_s1), .emergency_s2(emergency_s2),
        .emergency_s3(emergency_s3), .emergency_s4(emergency_s4),
        .TL1(TL1), .TL2(TL2), .TL3(TL3), .TL4(TL4)
    );

    always #5 clk = ~clk; 

    initial begin
        rst = 1;
        sensor_s1 = 0; sensor_s2 = 0;
        sensor_s3 = 0; sensor_s4 = 0;
        ped_s1 = 0; ped_s2 = 0;
        ped_s3 = 0; ped_s4 = 0;
        emergency_s1 = 0; emergency_s2 = 0;
        emergency_s3 = 0; emergency_s4 = 0;

        #20;
        rst = 0;

        #10;
        sensor_s1 = 1; ped_s3 = 1; // Traffic on S1, pedestrian on S3
        #100;

        sensor_s1 = 1; ped_s3 = 0;
        sensor_s2 = 1; emergency_s2 = 1; // Emergency vehicle on S2 with rest of the vehicles
        #100;

        sensor_s2 = 0; emergency_s2 = 0;
        sensor_s3 = 1; sensor_s4 = 1; // Normal traffic
        #100;

        sensor_s3 = 0; sensor_s4 = 0;  // Idle (no traffic)
        #100;

        $finish;
    end

endmodule
