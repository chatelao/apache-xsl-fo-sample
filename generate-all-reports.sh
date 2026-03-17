#!/bin/bash

LANGUAGES=("en" "de" "fr" "it")
XSLT_TEMPLATE="templates/camt053-to-fo.xsl"
DATA_DIR="data"
OUTPUT_DIR="pdf"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Loop through all XML files in the data directory
for input_xml in "$DATA_DIR"/*.xml; do
    # Get the base name of the file without extension
    base_name=$(basename "$input_xml" .xml)

    for lang in "${LANGUAGES[@]}"; do
        OUTPUT_PDF="$OUTPUT_DIR/${base_name}_${lang}.pdf"
        echo "Generating $OUTPUT_PDF from $input_xml..."
        ./generate-pdf.sh "$input_xml" "$XSLT_TEMPLATE" "$OUTPUT_PDF" "$lang"
    done
done
