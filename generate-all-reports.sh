#!/bin/bash

LANGUAGES=("en" "de" "fr" "it")
INPUT_XML="data/sample-camt053.xml"
XSLT_TEMPLATE="templates/camt053-to-fo.xsl"

for lang in "${LANGUAGES[@]}"; do
    OUTPUT_PDF="pdf/statement_${lang}.pdf"
    ./generate-pdf.sh "$INPUT_XML" "$XSLT_TEMPLATE" "$OUTPUT_PDF" "$lang"
done
