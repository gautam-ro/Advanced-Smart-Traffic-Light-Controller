`timescale 1ns / 1ps

module smart_traffic_controller(
            input clk,
            input rst,
            output reg [1:0] TL1,
            output reg [1:0] TL2,
            output reg [1:0] TL3,
            output reg [1:0] TL4
);

    reg state;
    reg [3:0] timer;
    
    parameter RED = 2'b00; //Red = 0
    parameter GREEN = 2'b01; //Green = 1
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            timer <= 0;
        end else begin
            if (timer == 10) begin
                state <= ~state;
                timer <= 0;
            end else begin
                timer <= timer + 1;
            end
        end
    end

    always @(*) begin
        case(state)
            0: begin  // TL1 & TL3 Green
                TL1 = GREEN;
                TL3 = GREEN;
                TL2 = RED;
                TL4 = RED;
            end
            1: begin  // TL2 & TL4 Green
                TL2 = GREEN;
                TL4 = GREEN;
                TL1 = RED;
                TL3 = RED;
            end
        endcase
    end
endmodule
            
