#!/bin/bash

# Check if directory parameter is provided.
if [ $# -eq 0 ]; then
    echo "Usage: $0 <receipts_directory>"
    echo "  receipts_directory - Directory containing receipt markdown files"
    exit 1
fi

RECEIPTS_DIR="$1"

# Check if pandoc is installed.
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed. Please install it first."
    echo "On macOS: brew install pandoc"
    echo "On Ubuntu/Debian: sudo apt-get install pandoc"
    exit 1
fi

# Create pdfs directory if it doesn't exist.
mkdir -p pdfs

# Check if receipts directory exists.
if [ ! -d "$RECEIPTS_DIR" ]; then
    echo "Error: receipts directory '$RECEIPTS_DIR' not found."
    exit 1
fi

# Get all receipt markdown files and sort them by date.
receipt_files=("$RECEIPTS_DIR"/*_receipt.md)

if [ ${#receipt_files[@]} -eq 0 ] || [ ! -f "${receipt_files[0]}" ]; then
    echo "Error: No receipt files found in '$RECEIPTS_DIR' directory."
    exit 1
fi

# Sort the files by filename (which contains the date).
IFS=$'\n' sorted_files=($(sort <<<"${receipt_files[*]}"))
unset IFS

echo "Found ${#sorted_files[@]} receipt files to combine from '$RECEIPTS_DIR'..."

# Create a temporary file to hold the combined content.
temp_file=$(mktemp /tmp/combined_receipts.XXXXXX.md)

# Combine all receipts with page breaks.
for i in "${!sorted_files[@]}"; do
    md_file="${sorted_files[$i]}"
    echo "Adding $(basename "$md_file")..."
    
    # Add the content of the current receipt.
    cat "$md_file" >> "$temp_file"
    
    # Add a page break after each receipt (except the last one).
    if [ $i -lt $((${#sorted_files[@]} - 1)) ]; then
        printf "\n\n\\\\newpage\n\n" >> "$temp_file"
    fi
done

# Generate output filename with current date and directory name.
dir_name=$(basename "$RECEIPTS_DIR")
output_file="pdfs/all_receipts_${dir_name}_$(date +%Y-%m-%d).pdf"

echo "Generating combined PDF: $output_file..."

# Convert the combined markdown to PDF.
pandoc "$temp_file" \
    -f markdown \
    -o "$output_file" \
    --pdf-engine=pdflatex \
    -V geometry:margin=1in \
    -V fontsize=12pt \
    -V documentclass=article \
    --highlight-style=tango

# Clean up temporary file.
rm "$temp_file"

if [ $? -eq 0 ]; then
    echo "✓ Successfully created $output_file"
    echo "  Combined ${#sorted_files[@]} receipts into a single PDF"
else
    echo "✗ Failed to create combined PDF"
    exit 1
fi 
