module stopwatch (
    input clk,        // Clock input (100MHz on Basys3)
    input reset,      // Center button for reset
    input speed_up,   // Switch for 4x speed
    output reg [3:0] digit0, // Ones place (0-9)
    output reg [3:0] digit1, // Tens place (0-5)
    output reg [3:0] digit2, // Minutes ones place (0-9)
    output reg [3:0] digit3  // Minutes tens place (0-5)
);
    // Clock divider to generate 1Hz tick (or 4Hz when speed_up is on)
    reg [26:0] clk_div;
    reg tick;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_div <= 0;
            tick <= 0;
        end else begin
            if (speed_up) begin
                // For 4Hz with 100MHz clock: 100,000,000 / 4 = 25,000,000 cycles
                if (clk_div == 25_000_000 - 1) begin
                    clk_div <= 0;
                    tick <= 1;
                end else begin
                    clk_div <= clk_div + 1;
                    tick <= 0;
                end
            end else begin
                // For 1Hz with 100MHz clock: 100,000,000 cycles
                if (clk_div == 100_000_000 - 1) begin
                    clk_div <= 0;
                    tick <= 1;
                end else begin
                    clk_div <= clk_div + 1;
                    tick <= 0;
                end
            end
        end
    end

    // BCD Counter Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            digit0 <= 0;
            digit1 <= 0;
            digit2 <= 0;
            digit3 <= 0;
        end else if (tick) begin
            if (digit0 == 9) begin
                digit0 <= 0;
                if (digit1 == 5) begin
                    digit1 <= 0;
                    if (digit2 == 9) begin
                        digit2 <= 0;
                        if (digit3 == 5) begin
                            digit3 <= 0; // Reset at 59:59
                        end else begin
                            digit3 <= digit3 + 1;
                        end
                    end else begin
                        digit2 <= digit2 + 1;
                    end
                end else begin
                    digit1 <= digit1 + 1;
                end
            end else begin
                digit0 <= digit0 + 1;
            end
        end
    end
endmodule
