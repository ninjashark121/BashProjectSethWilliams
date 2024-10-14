#!/bin/bash

# Function to display help message
usage() {
    echo "This is an interactive log analyzer script."
    echo "You will be prompted to enter values to filter log data from a specified log file."
    echo "To skip any filter, just press ENTER without typing a value."
    echo "Usage: $0 [-h]"
    echo "  -h: Display this help message"
    exit 1
}

# Function to validate the log file
validate_file() {
    if [[ ! -f "$1" ]]; then
        echo "Error: File '$1' not found!"
        exit 1
    fi
}


if [[ "$1" == "-h" ]]; then
    usage
fi

# Prompt user
echo "Enter the path to the log file you want to analyze (e.g., /var/log/syslog):"
read log_file

# Validate the log file
validate_file "$log_file"

# Prompt 
echo "Enter a date to filter logs by (format: YYYY-MM-DD) or press ENTER to skip:"
read date_filter

echo "Enter a log level to filter by (e.g., ERROR, WARN, INFO) or press ENTER to skip:"
read log_level

echo "Enter a keyword to search in log entries or press ENTER to skip:"
read keyword_filter


grep_cmd="grep "

if [[ -n "$date_filter" ]]; then
    grep_cmd+="\"$date_filter\" "
fi

if [[ -n "$log_level" ]]; then
    grep_cmd+="\"$log_level\" "
fi

if [[ -n "$keyword_filter" ]]; then
    grep_cmd+="\"$keyword_filter\" "
fi

grep_cmd+="$log_file"

# Confirm 
echo "Applying the following filters to the log file:"
if [[ -n "$date_filter" ]]; then
    echo "- Date: $date_filter"
fi
if [[ -n "$log_level" ]]; then
    echo "- Log level: $log_level"
fi
if [[ -n "$keyword_filter" ]]; then
    echo "- Keyword: $keyword_filter"
fi


result=$(eval "$grep_cmd")

# Output the results
if [[ -z "$result" ]]; then
    echo "No log entries found matching the criteria."
else
    echo "$result"
    echo ""
    echo "Total matching log entries: $(echo "$result" | wc -l)"
fi
