# Roadmap: Full Implementation of eCH-0196 V2.2.0 (Electronic Tax Statement)

This roadmap outlines the steps required to achieve 100% compliance with the **eCH-0196 V2.2.0** specification, including the technical guidelines for barcode generation and digital signatures.

## 1. Core Document Structure (`taxStatementType`)
Implement all attributes and sub-elements of the root element.
- [ ] **Root Attributes**:
    - [ ] `id`: Unique ID (Technical Guideline 2.1 compliance).
    - [ ] `creationDate`: Timestamp of generation.
    - [ ] `taxPeriod`: Year of the statement.
    - [ ] `periodFrom` / `periodTo`: Start and end dates.
    - [ ] `country`: Defaults to 'CH'.
    - [ ] `canton`: Official abbreviation (eCH-0007).
    - [ ] `minorVersion`: Set to '22' for V2.2.0.
- [ ] **Global Totals**:
    - [ ] `totalTaxValue`: Total wealth (excluding liabilities).
    - [ ] `totalGrossRevenueA` / `totalGrossRevenueACanton`: Rubric A (with withholding tax claim).
    - [ ] `totalGrossRevenueB` / `totalGrossRevenueBCanton`: Rubric B (without claim).
    - [ ] `totalWithHoldingTaxClaim`: Total Swiss withholding tax claim.
- [ ] **Rounding Logic**:
    - [ ] Implement DIN 1333 rounding (3 decimals if < 100, 2 decimals if >= 100).
- [ ] **Extensions**:
    - [ ] Support `##other` for arbitrary bank-specific elements/attributes.

## 2. Institutional & Client Data
- [ ] **Institution (`institutionType`)**:
    - [ ] `uid`: Business Identification Number (eCH-0097).
    - [ ] `lei`: Legal Entity Identifier.
    - [ ] `name`: Official organization name.
    - [ ] Full address support (Street, PostCode, Town).
- [ ] **Client (`clientType`)**:
    - [ ] `clientNumber`: Bank-specific internal ID.
    - [ ] `tin`: Taxpayer Identification Number.
    - [ ] `salutation`, `firstName`, `lastName`.
    - [ ] Full address support.

## 3. Accompanying Documents (`accompanyingLetterType`)
- [ ] Support for multiple attachments.
- [ ] `fileName`, `fileSize`.
- [ ] `fileData`: Base64 encoded binary data (PDF/XML).

## 4. List of Bank Accounts (`listOfBankAccountsType`)
- [ ] **Totals**: Intermediate sums for the accounts section.
- [ ] **Individual Accounts (`bankAccountType`)**:
    - [ ] Identification: `iban`, `bankAccountNumber`, `bankAccountName`.
    - [ ] Dates: `openingDate`, `closingDate` (conditional display).
    - [ ] **Tax Value (`bankAccountTaxValueType`)**:
        - [ ] `referenceDate`, `balanceCurrency`, `balance`, `exchangeRate`, `value` (CHF).
    - [ ] **Payments (`bankAccountPaymentType`)**:
        - [ ] `paymentDate`, `amountCurrency`, `amount`, `exchangeRate`.
        - [ ] Detailed splits: `grossRevenueA`, `grossRevenueB`, `withHoldingTaxClaim`.

## 5. List of Liabilities (`listOfLiabilitiesType`)
- [ ] **Individual Liabilities (`liabilityAccountType`)**:
    - [ ] Support for negative balances (Schulden).
    - [ ] Support for interest payments (Schuldzinsen).
    - [ ] Absolute value representation in XML as per spec.

## 6. List of Expenses (`listOfExpensesType`)
- [ ] Implementation of all 44+ defined expense categories (Stempelabgaben, Depotgebühren, etc.).
- [ ] **Expense Item (`expenseType`)**:
    - [ ] Linking to accounts/depots via `iban`, `bankAccountNumber`, or `depotNumber`.
    - [ ] Deductibility flags for Federal vs. Cantonal tax.

## 7. List of Securities (`listOfSecuritiesType`)
- [ ] **Depot Management (`securityDepotType`)**:
    - [ ] `depotNumber`.
- [ ] **Security Metadata (`securitySecurityType`)**:
    - [ ] Identifiers: `positionId` (32-bit unique), `valorNumber`, `isin`.
    - [ ] Categories: `securityCategory`, `securityType`.
    - [ ] IUP/BFP Flags: Support for `iup`, `bfp`, `variableInterest`.
    - [ ] Issuance info: `issueDate`, `redemptionDate`, `issuePrice`, `redemptionPrice`.
- [ ] **Security Tax Values (`securityTaxValueType`)**:
    - [ ] Flags: `blocked` (with `blockingTo`), `undefined`, `kursliste`.
- [ ] **Security Payments (`securityPaymentType`)**:
    - [ ] Special events: `conversion`, `gratis`, `securitiesLending`, `lendingFee`, `retrocession`.
    - [ ] International Tax: `lumpSumTaxCredit`, `nonRecoverableTax`, `additionalWithHoldingTaxUSA`.
    - [ ] Calculation Details: Link to `purchase` / `disposition` records for IUP calculation.
- [ ] **Security Stock/Mutations (`securityStockType`)**:
    - [ ] Detailed tracking of purchases/sales (First-In / First-Out principle).

## 8. Technical Guidelines & Output Generation
- [ ] **Identification Logic**:
    - [ ] Automatic generation of the 16-digit CODE128C barcode message.
    - [ ] Automatic generation of the document-wide unique ID.
- [ ] **Barcode Rendering**:
    - [ ] **1D Barcode**: CODE128C on every page (standardized position and size).
    - [ ] **2D Barcode**: PDF417 Structured Append on separate sheets (XML payload delivery).
- [ ] **Digital Signatures**:
    - [ ] Integration of Apache Santuario for **XMLDSIG (Enveloped Signature)**.
    - [ ] Inclusion of `X509Certificate` and `X509SubjectName` in `KeyInfo`.
- [ ] **Internationalization**:
    - [ ] Ensure all 4 languages (en, de, fr, it) have complete coverage for all labels in the spec.
- [ ] **Visual Layout (XSL-FO)**:
    - [ ] Support Kern OMR marks (Benchmark, Safety, End of Set, Parity).
    - [ ] Master page alternatives for alternating headers/footers.
    - [ ] Correct table formatting for complex transaction details.

## 9. Validation & Testing
- [ ] XML Schema Validation (lax processContents for extensions).
- [ ] Cross-calculation check: `totalTaxValue` vs Sum of sub-sections.
- [ ] Cross-calculation check: `totalGrossRevenue` vs Sum of entries.
- [ ] Visual verification of barcode readability.
