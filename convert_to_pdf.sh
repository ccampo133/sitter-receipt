#!/bin/bash

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed. Please install it first."
    echo "On macOS: brew install pandoc"
    echo "On Ubuntu/Debian: sudo apt-get install pandoc"
    exit 1
fi

# Create pdfs directory if it doesn't exist
mkdir -p pdfs

# Convert each receipt markdown file to PDF
for md_file in *_receipt.md; do
    if [ -f "$md_file" ]; then
        # Extract filename without extension
        filename="${md_file%.md}"
        
        echo "Converting $md_file to PDF..."
        
        # Convert to PDF using pandoc
        pandoc "$md_file" \
            -o "pdfs/${filename}.pdf" \
            --pdf-engine=pdflatex \
            -V geometry:margin=1in \
            -V fontsize=12pt \
            -V documentclass=article \
            --highlight-style=tango
        
        if [ $? -eq 0 ]; then
            echo "✓ Created pdfs/${filename}.pdf"
        else
            echo "✗ Failed to convert $md_file"
        fi
    fi
done

echo "Done! PDF files are in the 'pdfs' directory."