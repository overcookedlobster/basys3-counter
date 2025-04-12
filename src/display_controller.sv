module display_controller(
    input clk,              // System clock
    input [3:0] digit0,     // Rightmost digit (ones of seconds)
    input [3:0] digit1,     // Tens of seconds
    input [3:0] digit2,     // Ones of minutes
    input [3:0] digit3,     // Tens of minutes
    output reg [3:0] an,    // Anode control (active low)
    output [6:0] seg,       // Segments (active low)
    output dp               // Decimal point (active low)
);
    // Internal signals
    reg [1:0] digit_select = 0;  // To select which digit to display
    reg [16:0] refresh_counter = 0; // Counter for display refresh
    wire [3:0] current_digit;    // Current BCD digit to display

    // Refresh counter for digit multiplexing (approximately 1kHz per digit)
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end

    // Use the most significant bits of the counter for digit selection
    always @(posedge clk) begin
        digit_select <= refresh_counter[16:15]; // Change digit every ~32ms
    end

    // Digit multiplexing
    always @(*) begin
        case(digit_select)
            2'b00: an = 4'b1110; // Enable rightmost digit
            2'b01: an = 4'b1101; // Enable second digit
            2'b10: an = 4'b1011; // Enable third digit
            2'b11: an = 4'b0111; // Enable leftmost digit
        endcase
    end

    // Select the digit to display
    assign current_digit = (digit_select == 2'b00) ? digit0 :
                           (digit_select == 2'b01) ? digit1 :
                           (digit_select == 2'b10) ? digit2 :
                           digit3;

    // Decimal point control (set to show dot between minutes and seconds)
    assign dp = ~(digit_select == 2'b01); // Active low, turn on for digit1 (after seconds tens)

    // Instantiate BCD to 7-segment decoder
    bcd_to_7seg bcd_decoder (
        .bcd(current_digit),
        .segments(seg)
    );
endmodule
