#!/bin/bash

# Default values
INPUT_XML=${1:-data/sample-camt053.xml}
XSLT_TEMPLATE=${2:-templates/camt053-to-fo.xsl}
OUTPUT_PDF=${3:-pdf/statement.pdf}
LANG=${4:-en}

# Check if fop is installed
if ! command -v fop &> /dev/null
then
    echo "Apache FOP could not be found. Please install it."
    exit 1
fi

# Ensure output directory exists
mkdir -p $(dirname "$OUTPUT_PDF")

# Run FOP
CP=""
if [ -d "lib" ]; then
    for jar in lib/*.jar; do
        CP="\$CP:\$jar"
    done
fi

if [ -n "\$CP" ]; then
    export CLASSPATH="\$CLASSPATH:\$CP"
fi

fop -xml "$INPUT_XML" -xsl "$XSLT_TEMPLATE" -param lang "$LANG" -pdf "$OUTPUT_PDF"

if [ $? -eq 0 ]; then
    echo "PDF generated successfully at $OUTPUT_PDF (Language: $LANG)"
else
    echo "Failed to generate PDF"
    exit 1
fi
