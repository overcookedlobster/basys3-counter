module stopwatch_top(
    input clk,        // System clock (100MHz on Basys3)
    input reset,      // Reset button
    input speed_up,   // Speed control switch
    output [6:0] seg, // 7-segment display segments
    output [3:0] an,  // 7-segment display anodes
    output dp         // Decimal point
);
    // Internal signals for BCD digits
    wire [3:0] digit0, digit1, digit2, digit3;

    // Instantiate the stopwatch counter
    stopwatch counter (
        .clk(clk),
        .reset(reset),
        .speed_up(speed_up),
        .digit0(digit0),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3)
    );

    // Instantiate the display controller
    display_controller display (
        .clk(clk),
        .digit0(digit0),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3),
        .an(an),
        .seg(seg),
        .dp(dp)
    );
endmodule
