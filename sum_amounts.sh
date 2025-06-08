#!/bin/bash

# Check if CSV file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

CSV_FILE="$1"

# Check if file exists
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: File '$CSV_FILE' not found"
    exit 1
fi

# Sum up the amounts
total=$(awk -F',' '
    NF==2 && $2 ~ /^[0-9]+(\.[0-9]+)?$/ {
        sum += $2
    }
    END {
        printf "%.2f", sum
    }
' "$CSV_FILE")

echo "Total amount spent: \$${total}"