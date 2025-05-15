#!/bin/bash   # this is a bash script

# run it like this:
# bash query_timer.sh label num_reps query db_file csv_file

# define parameters from command line
label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

# get current time and store it
start_time=$(date +"%s")

# loop num_reps times
i=0
while [ $i -lt $num_reps ]; do
    duckdb $db_file "$query" 
    i=$((i+1))
done

# get current time
end_time=$(date +"%s")

# compute elapsed time
elapsed_time=$((end_time - start_time))

# divide elapsed time by num_reps
avg_time=$(python -c "print($elapsed_time / $num_reps)")

# write output
echo $label,$avg_time >> $csv_file


# Report:
# After testing the 3 methods, the outer join method was slightly faster. 
# I used 1000 reps to make sure I would get good representation.