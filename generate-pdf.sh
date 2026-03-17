#!/bin/bash

# Default values
INPUT_XML=${1:-data/sample-camt053.xml}
XSLT_TEMPLATE=${2:-templates/camt053-to-fo.xsl}
OUTPUT_PDF=${3:-pdf/statement.pdf}

# Check if fop is installed
if ! command -v fop &> /dev/null
then
    echo "Apache FOP could not be found. Please install it."
    exit 1
fi

# Ensure output directory exists
mkdir -p $(dirname "$OUTPUT_PDF")

# Run FOP
fop -xml "$INPUT_XML" -xsl "$XSLT_TEMPLATE" -pdf "$OUTPUT_PDF"

if [ $? -eq 0 ]; then
    echo "PDF generated successfully at $OUTPUT_PDF"
else
    echo "Failed to generate PDF"
    exit 1
fi
