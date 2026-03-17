# Description
This project generates Swiss Account details as PDF from camt.053 XML files using Apache XSL-FO.

# Software Stack
- **Apache FOP (Formatting Objects Processor)**: A print formatter driven by XSL formatting objects (XSL-FO) and an output independent formatter. It is used to render the XSL-FO tree into a PDF.
- **XSL-FO (Extensible Stylesheet Language Formatting Objects)**: A language for formatting XML data.
- **XSLT (Extensible Stylesheet Language Transformations)**: Used to transform the input camt.053 XML into XSL-FO.
- **Shell Script**: A script to automate the transformation process.
- **GitHub Actions**: Automated workflow to generate the PDF on push or manual trigger.

# Structure
- `/templates`: The XSLT templates for formatting (e.g., `camt053-to-fo.xsl`).
- `/data`: The source data, e.g., `sample-camt053.xml`.
- `/i18n`: Translations of text elements (future use).
- `/pdf`: The generated output PDF files.
- `generate-pdf.sh`: Script to run the rendering process locally.

# Usage
## Local execution
To generate a PDF locally, ensure Apache FOP is installed and run:
```bash
./generate-pdf.sh [input_xml] [xslt_template] [output_pdf]
```
Example:
```bash
./generate-pdf.sh data/sample-camt053.xml templates/camt053-to-fo.xsl pdf/statement.pdf
```

## GitHub Actions
The PDF is automatically generated on push to the `main` branch. The generated PDF can be downloaded from the "Actions" tab under "Artifacts".
