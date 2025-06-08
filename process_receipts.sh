#!/bin/bash

# Check if CSV file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <csv_file> [output_directory]"
    echo "  csv_file         - CSV file with date,amount pairs"
    echo "  output_directory - Optional directory to save receipts (default: current directory)"
    exit 1
fi

CSV_FILE="$1"
OUTPUT_DIR="${2:-.}"  # Default to current directory if not specified

# Check if file exists
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: File '$CSV_FILE' not found"
    exit 1
fi

# Create output directory if it doesn't exist
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating output directory: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create output directory '$OUTPUT_DIR'"
        exit 1
    fi
fi

echo "Processing receipts from '$CSV_FILE' to '$OUTPUT_DIR'..."

# Read CSV file line by line
while IFS=',' read -r date amount; do
    # Skip empty lines
    if [ -z "$date" ] || [ -z "$amount" ]; then
        continue
    fi
    
    # Generate output filename in the specified directory
    output_file="$OUTPUT_DIR/${date}_receipt.md"
    
    echo "Generating receipt for $date ($amount) -> $output_file"
    
    # Execute the go command
    go run main.go \
        -provider "Alyssa Turpin" \
        -address "1722 Wekiva Crossing Blvd, Apopka, FL 32703" \
        -taxid "664-10-2856" \
        -child "Elaine Campo" \
        -amount "$amount" \
        -date "$date" \
        -output "$output_file"
    
done < "$CSV_FILE"
