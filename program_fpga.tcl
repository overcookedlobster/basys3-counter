# Program FPGA with the generated bitstream for Basys3 Stopwatch project

# Open the hardware manager
open_hw_manager

# Connect to the hardware server
connect_hw_server -allow_non_jtag

# List available targets and attempt to open one
set targets [get_hw_targets]
if {[llength $targets] > 0} {
    set target [lindex $targets 0]
    open_hw_target $target
    puts "Connected to target: $target"
} else {
    puts "No hardware targets found. Please check connection."
    close_hw_manager
    exit
}

# Set the hardware device
set devices [get_hw_devices]
if {[llength $devices] > 0} {
    set device [lindex $devices 0]
    current_hw_device $device
    refresh_hw_device -update_hw_probes false $device
    puts "Current device set to: $device"
} else {
    puts "No hardware devices found. Please check connection."
    close_hw_target
    close_hw_manager
    exit
}

# Program the FPGA with the bitstream
set_property PROGRAM.FILE {/home/workinglobster/basys3-counter/vivado_project/basys3_stopwatch.runs/impl_1/stopwatch_top.bit} $device
program_hw_devices $device
refresh_hw_device $device

# Close the hardware target and server
close_hw_target
close_hw_manager

# Create logs directory if it doesn't exist
file mkdir "$project_dir/logs"

# Move log files to logs directory if they exist
if {[file exists "vivado.log"]} {
    file rename -force "vivado.log" "$project_dir/logs/vivado.log"
}
if {[file exists "vivado.jou"]} {
    file rename -force "vivado.jou" "$project_dir/logs/vivado.jou"
}

puts "FPGA programming completed."
