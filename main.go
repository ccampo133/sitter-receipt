package main

import (
	"flag"
	"fmt"
	"os"
	"text/template"
	"time"
)

// ReceiptData holds the data for the receipt template.
type ReceiptData struct {
	ProviderName    string
	ProviderAddress string
	ProviderTaxId   string
	ChildName       string
	Date            string
	Amount          string
}

// receiptTemplate is the embedded template content.
const receiptTemplate = `**Provider Name:**
{{ .ProviderName }}

**Provider Address:**
{{ .ProviderAddress }}

**Tax ID Number:**
{{ .ProviderTaxId }}

**Care For:**
{{ .ChildName }}

**Date(s):**
{{ .Date }}

**Amount:**
{{ .Amount }}
`

func main() {
	// Get today's date in a readable format
	today := time.Now().Format("2006-01-02")

	// Default output filename using today's date
	defaultOutputFile := fmt.Sprintf("%s_receipt.md", today)

	// Define command line flags
	providerName := flag.String("provider", "", "Provider name")
	providerAddr := flag.String("address", "", "Provider address")
	providerTaxId := flag.String("taxid", "", "Provider tax ID")
	childName := flag.String("child", "", "Child name")
	date := flag.String("date", today, "Service date(s) (defaults to today)")
	amount := flag.String("amount", "", "Amount paid")
	outputFile := flag.String("output", defaultOutputFile, "Output filename (defaults to <today's date>_receipt.md)")

	flag.Parse()

	// Validate required flags
	if *providerName == "" || *providerAddr == "" || *childName == "" || *amount == "" {
		fmt.Println("Error: Provider name, address, child name, and amount are required")
		flag.Usage()
		os.Exit(1)
	}

	// If amount doesn't start with $, add it
	formattedAmount := *amount
	if len(formattedAmount) > 0 && formattedAmount[0] != '$' {
		formattedAmount = "$" + formattedAmount
	}

	// Create receipt data
	data := ReceiptData{
		ProviderName:    *providerName,
		ProviderAddress: *providerAddr,
		ProviderTaxId:   *providerTaxId,
		ChildName:       *childName,
		Date:            *date,
		Amount:          formattedAmount,
	}

	// If output file wasn't set by user (still has default value)
	if *outputFile == defaultOutputFile {
		// Try to extract a date from the service date field for the filename
		filenameDate := today

		// Try to parse date if it starts with a date pattern (YYYY-MM-DD)
		dateStr := *date
		if len(dateStr) >= 10 {
			// Look for date format at the beginning (YYYY-MM-DD)
			if _, err := time.Parse("2006-01-02", dateStr[:10]); err == nil {
				filenameDate = dateStr[:10]
			}
		}

		// Use the extracted date for the filename
		*outputFile = fmt.Sprintf("%s_receipt.md", filenameDate)
	}

	// Parse the template
	tmpl, err := template.New("receipt").Parse(receiptTemplate)
	if err != nil {
		fmt.Printf("Error parsing template: %v\n", err)
		os.Exit(1)
	}

	// Create output file
	file, err := os.Create(*outputFile)
	if err != nil {
		fmt.Printf("Error creating output file: %v\n", err)
		os.Exit(1)
	}
	defer file.Close()

	// Execute the template and write to file
	if err = tmpl.Execute(file, data); err != nil {
		fmt.Printf("Error executing template: %v\n", err)
		os.Exit(1)
	}
}
