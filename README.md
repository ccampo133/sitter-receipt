# Sitter Receipt Generator

A simple command-line tool for generating childcare receipts in Markdown format.

## Overview

This tool creates a receipt for childcare services with the provider's information, child's name, service date(s), and payment amount. The receipt is generated as a Markdown file that can be easily converted to PDF or printed.

## Installation

### From Source

```bash
# Clone the repository
git clone https://github.com/ccampo133/sitter-receipt.git
cd sitter-receipt

# Build the binary
go build -o sitter-receipt
```

Or just use `go install`:

```bash
go install github.com/ccampo133/sitter-receipt@latest
```

## Usage

```bash
./sitter-receipt -provider "Jane Doe" -address "123 Main St, Anytown, USA" -taxid "123-45-6789" -child "John Smith" -amount "150"
```

### Required Flags

- `-provider`: Name of the childcare provider
- `-address`: Address of the childcare provider
- `-child`: Name of the child receiving care
- `-amount`: Amount paid (with or without $ symbol)

### Optional Flags

- `-taxid`: Provider's tax ID number (e.g. social security number)
- `-date`: Service date(s) (defaults to today's date)
- `-output`: Output filename (defaults to `<date>_receipt.md`)

## Example Output

```markdown
**Provider Name:**
Jane Doe

**Provider Address:**
123 Main St, Anytown, USA

**Tax ID Number:**
123-45-6789

**Care For:**
John Smith

**Date(s):**
2025-04-07

**Amount:**
$150
```

## Converting to Other Formats

You can convert the Markdown receipt to other formats using tools like [Pandoc](https://pandoc.org/):

```bash
# Convert to PDF
pandoc 2025-04-07_receipt.md -o 2025-04-07_receipt.pdf

# Convert to HTML
pandoc 2025-04-07_receipt.md -o 2025-04-07_receipt.html
```

## License

[MIT License](LICENSE)
