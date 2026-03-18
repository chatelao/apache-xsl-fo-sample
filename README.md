# Swiss Account Statement Generator

This project generates Swiss Account details as PDF from ISO 20022 `camt.053` XML files using Apache XSL-FO.

## Architecture

The diagram below illustrates the generation process, including the transformation of XML input and internationalization files into XSL-FO, and the subsequent rendering to PDF by Apache FOP.

![Architecture Diagram](https://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/chatelao/apache-xsl-fo-sample/main/architecture.puml)

## Software Stack
- **Apache FOP (Formatting Objects Processor)**: A print formatter driven by XSL formatting objects (XSL-FO) and an output independent formatter. It is used to render the XSL-FO tree into a PDF.
- **XSL-FO (Extensible Stylesheet Language Formatting Objects)**: A language for formatting XML data.
- **XSLT (Extensible Stylesheet Language Transformations)**: Used to transform the input camt.053 XML into XSL-FO.
- **Shell Script**: A script to automate the transformation process.
- **GitHub Actions**: Automated workflow to generate the PDF on push or manual trigger.

## Project Structure
- `/templates`: The XSLT templates for formatting (e.g., `camt053-to-fo.xsl`).
- `/data`: The source data, e.g., `sample-camt053.xml`.
- `/i18n`: Translations of text elements for internationalization (en, de, fr, it).
- `/assets`: Static assets like logos used in the PDF.
- `/pdf`: The generated output PDF files.
- `generate-pdf.sh`: Script to run the rendering process locally.
- `generate-all-reports.sh`: Script to generate reports in all supported languages.

## Usage
### Local execution
To generate a PDF locally, ensure Apache FOP is installed and run:
```bash
./generate-pdf.sh [input_xml] [xslt_template] [output_pdf] [lang]
```
Example (English):
```bash
./generate-pdf.sh data/sample-camt053.xml templates/camt053-to-fo.xsl pdf/statement_en.pdf en
```

To generate reports in all four supported languages (en, de, fr, it) at once:
```bash
./generate-all-reports.sh
```
This will create `pdf/statement_en.pdf`, `pdf/statement_de.pdf`, `pdf/statement_fr.pdf`, and `pdf/statement_it.pdf`.

### Internationalization (i18n)
Translations are managed in XML files within the `/i18n` directory. Currently supported languages are:
- English (`en.xml`)
- German (`de.xml`)
- French (`fr.xml`)
- Italian (`it.xml`)


## GitHub Actions
The PDF is automatically generated on push to the `main` branch. The generated PDF can be downloaded from the "Actions" tab under "Artifacts".
