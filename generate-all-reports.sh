#!/bin/bash

LANGUAGES=("en" "de" "fr" "it")
DATA_DIR="data"
OUTPUT_DIR="pdf"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Loop through all XML files in the data directory
for input_xml in "$DATA_DIR"/*.xml; do
    # Get the base name of the file without extension
    base_name=$(basename "$input_xml" .xml)

    # Determine XSLT template based on XML content
    if grep -q "urn:iso:std:iso:20022:tech:xsd:camt.053" "$input_xml"; then
        XSLT_TEMPLATE="templates/camt053-to-fo.xsl"
    elif grep -q "http://www.ech.ch/xmlns/eCH-0196" "$input_xml"; then
        XSLT_TEMPLATE="templates/ech0196-to-fo.xsl"
    else
        echo "Unknown XML format for $input_xml, skipping..."
        continue
    fi

    for lang in "${LANGUAGES[@]}"; do
        OUTPUT_PDF="$OUTPUT_DIR/${base_name}_${lang}.pdf"
        echo "Generating $OUTPUT_PDF from $input_xml using $XSLT_TEMPLATE..."
        ./generate-pdf.sh "$input_xml" "$XSLT_TEMPLATE" "$OUTPUT_PDF" "$lang"
    done
done
