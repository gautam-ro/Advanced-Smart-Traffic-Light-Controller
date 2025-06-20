`timescale 1ns / 1ps

module adv_smart_traffic_controller#(
    parameter GREEN_MIN = 10,
    parameter GREEN_MAX = 30,
    parameter RED_BUFFER = 3
)(
    input clk,
    input rst,
    input sensor_s1, sensor_s2, sensor_s3, sensor_s4,
    input ped_s1, ped_s2, ped_s3, ped_s4,
    input emergency_s1, emergency_s2, emergency_s3, emergency_s4,
    output reg [1:0] TL1, TL2, TL3, TL4
);

    reg [2:0] state;

    parameter STATE_S13_GREEN  = 3'd0;
    parameter STATE_ALL_RED_1  = 3'd1;
    parameter STATE_S24_GREEN  = 3'd2;
    parameter STATE_ALL_RED_2  = 3'd3;

    parameter RED    = 2'b00; //red=0
    parameter GREEN  = 2'b01; //green=1

    reg [5:0] timer;

    wire emergency_13 = emergency_s1 | emergency_s3;
    wire emergency_24 = emergency_s2 | emergency_s4;

    wire traffic_13 = sensor_s1 | sensor_s3 | ped_s1 | ped_s3;
    wire traffic_24 = sensor_s2 | sensor_s4 | ped_s2 | ped_s4;

    wire [5:0] green_duration_13 = (emergency_13 || traffic_13) ? GREEN_MAX : GREEN_MIN;
    wire [5:0] green_duration_24 = (emergency_24 || traffic_24) ? GREEN_MAX : GREEN_MIN;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_S13_GREEN;
            timer <= 0;
        end else begin
          
            if (emergency_13 && state != STATE_S13_GREEN) begin   // Emergency priority logic
                state <= STATE_S13_GREEN;
                timer <= 0;
            end else if (emergency_24 && state != STATE_S24_GREEN) begin   // Emergency priority logic
                state <= STATE_S24_GREEN;
                timer <= 0;
            end else begin
                case (state)
                    STATE_S13_GREEN: begin
                        if (timer >= green_duration_13) begin
                            state <= STATE_ALL_RED_1;
                            timer <= 0;
                        end else timer <= timer + 1;
                    end
                    STATE_ALL_RED_1: begin
                        if (timer >= RED_BUFFER) begin
                            state <= STATE_S24_GREEN;
                            timer <= 0;
                        end else timer <= timer + 1;
                    end
                    STATE_S24_GREEN: begin
                        if (timer >= green_duration_24) begin
                            state <= STATE_ALL_RED_2;
                            timer <= 0;
                        end else timer <= timer + 1;
                    end
                    STATE_ALL_RED_2: begin
                        if (timer >= RED_BUFFER) begin
                            state <= STATE_S13_GREEN;
                            timer <= 0;
                        end else timer <= timer + 1;
                    end
                    default: begin
                        state <= STATE_S13_GREEN;
                        timer <= 0;
                    end
                endcase
            end
        end
    end

    always @(*) begin
        case (state)
            STATE_S13_GREEN: begin
                TL1 = GREEN; TL3 = GREEN;
                TL2 = RED;   TL4 = RED;
            end
            STATE_S24_GREEN: begin
                TL1 = RED;   TL3 = RED;
                TL2 = GREEN; TL4 = GREEN;
            end
            default: begin
                TL1 = RED; TL2 = RED; TL3 = RED; TL4 = RED;
            end
        endcase
    end

endmodule
