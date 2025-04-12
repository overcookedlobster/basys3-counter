# Run simulation for Basys3 Stopwatch project

# Open the project
open_project /home/workinglobster/basys3-counter/vivado_project/basys3_stopwatch

# Launch simulation
launch_simulation

# Run simulation for specified time
run 3s

# Close simulation
close_sim

# Close project
close_project

# Create logs directory if it doesn't exist
file mkdir "$project_dir/logs"

# Move log files to logs directory if they exist
if {[file exists "vivado.log"]} {
    file rename -force "vivado.log" "$project_dir/logs/vivado.log"
}
if {[file exists "vivado.jou"]} {
    file rename -force "vivado.jou" "$project_dir/logs/vivado.jou"
}

puts "Simulation completed."
