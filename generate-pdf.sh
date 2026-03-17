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

# Classpath for FOP with Barcode4J
CP="/usr/share/java/fop-core.jar:/usr/share/java/fop-events.jar:/usr/share/java/fop-util.jar:/usr/share/java/xmlgraphics-commons.jar:/usr/share/java/commons-io.jar:/usr/share/java/commons-logging.jar:/usr/share/java/batik-all.jar:/usr/share/java/xml-commons-external.jar:/usr/share/java/avalon-framework.jar:lib/barcode4j.jar:lib/barcode4j-fop-ext.jar"

# Run FOP
java -cp "$CP" org.apache.fop.cli.Main -xml "$INPUT_XML" -xsl "$XSLT_TEMPLATE" -param lang "$LANG" -pdf "$OUTPUT_PDF"

if [ $? -eq 0 ]; then
    echo "PDF generated successfully at $OUTPUT_PDF (Language: $LANG)"
else
    echo "Failed to generate PDF"
    exit 1
fi
