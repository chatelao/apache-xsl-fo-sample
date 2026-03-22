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

    # Determine XSLT template
    if grep -q "eCH-0196" "$input_xml"; then
        CURRENT_TEMPLATE="templates/ech0196-to-fo.xsl"
    else
        CURRENT_TEMPLATE="templates/camt053-to-fo.xsl"
    fi

    for lang in "${LANGUAGES[@]}"; do
        OUTPUT_PDF="$OUTPUT_DIR/${base_name}_${lang}.pdf"
        echo "Generating $OUTPUT_PDF from $input_xml using $CURRENT_TEMPLATE..."
        ./generate-pdf.sh "$input_xml" "$CURRENT_TEMPLATE" "$OUTPUT_PDF" "$lang"
    done
done
