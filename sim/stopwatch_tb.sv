module stopwatch_tb;
    reg clk;
    reg reset;
    reg speed_up;
    wire [3:0] digit0;
    wire [3:0] digit1;
    wire [3:0] digit2;
    wire [3:0] digit3;

    // Instantiate the stopwatch module
    stopwatch uut (
        .clk(clk),
        .reset(reset),
        .speed_up(speed_up),
        .digit0(digit0),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3)
    );

    // Clock generation: use a more reasonable simulation clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period (100MHz)
    end

    // Test stimulus with BCD validation
    initial begin
        // Initialize signals
        reset = 1;
        speed_up = 1; // Use 4x speed for faster testing

        #100 reset = 0; // Release reset after 100ns

        // For simulation purposes, override the clock divider to have much smaller values
        force uut.clk_div = 0;

        // Test case 1: Check transition from 9 to 10 (manually force 10 ticks)
        repeat(10) begin
            force uut.tick = 1;
            #10;
            force uut.tick = 0;
            #90;
        end

        if (digit0 == 0 && digit1 == 1 && digit2 == 0 && digit3 == 0)
            $display("Test 1 Passed: BCD transition 9 to 10 successful at %0t", $time);
        else
            $display("Test 1 Failed: Expected 00:10, Got %h%h:%h%h at %0t", digit3, digit2, digit1, digit0, $time);

        // Test case 2: Check transition from 59 to 1:00 (manually force 50 more ticks)
        repeat(50) begin
            force uut.tick = 1;
            #10;
            force uut.tick = 0;
            #90;
        end

        if (digit0 == 0 && digit1 == 0 && digit2 == 1 && digit3 == 0)
            $display("Test 2 Passed: BCD transition 59 to 1:00 successful at %0t", $time);
        else
            $display("Test 2 Failed: Expected 1:00, Got %h%h:%h%h at %0t", digit3, digit2, digit1, digit0, $time);

        // Test case 3: Check reset functionality
        reset = 1;
        #100 reset = 0;
        release uut.tick;
        release uut.clk_div;

        if (digit0 == 0 && digit1 == 0 && digit2 == 0 && digit3 == 0)
            $display("Test 3 Passed: Reset to 00:00 successful at %0t", $time);
        else
            $display("Test 3 Failed: Expected 00:00 after reset, Got %h%h:%h%h at %0t", digit3, digit2, digit1, digit0, $time);

        // Run a bit more to ensure stability
        #1000;
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t clk=%b reset=%b speed_up=%b digit3=%h digit2=%h digit1=%h digit0=%h",
                 $time, clk, reset, speed_up, digit3, digit2, digit1, digit0);
    end
endmodule
