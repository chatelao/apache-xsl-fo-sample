import random
from datetime import datetime, timedelta
import xml.etree.ElementTree as ET

def generate_camt(num_entries=200):
    start_date = datetime(2023, 11, 1)
    opening_balance = 50000.00
    current_balance = opening_balance

    entries = []

    entities = [
        {"nm": "Swiss Tech AG", "iban": "CH9300000000000000001", "ctry": "CH"},
        {"nm": "European Customer Ltd", "iban": "DE89100000001234567890", "ctry": "DE", "ccy": "EUR"},
        {"nm": "French Supplier SAS", "iban": "FR7630006000011234567890123", "ctry": "FR", "ccy": "EUR"},
        {"nm": "US Tech Corp", "nm_dbtr": "US Tech Corp", "ccy": "USD"},
        {"nm": "Global Cloud Services", "ccy": "USD"},
        {"nm": "Alice Smith", "iban": "CH9300000000000000002", "ctry": "CH"},
        {"nm": "Bob Jones", "iban": "CH9300000000000000003", "ctry": "CH"},
        {"nm": "Zurich Services", "iban": "CH9300000000000000004", "ctry": "CH"},
        {"nm": "Geneva Logistics", "iban": "CH9300000000000000005", "ctry": "CH"},
        {"nm": "Bern Retail", "iban": "CH9300000000000000006", "ctry": "CH"},
        {"nm": "Lugano Finance", "iban": "CH9300000000000000007", "ctry": "CH"},
        {"nm": "Sunrise UPC", "iban": "CH9300000000000000008", "ctry": "CH"},
        {"nm": "Swisscom", "iban": "CH9300000000000000009", "ctry": "CH"},
        {"nm": "SBB CFF FFS", "iban": "CH9300000000000000010", "ctry": "CH"},
        {"nm": "Migros", "iban": "CH9300000000000000011", "ctry": "CH"},
        {"nm": "Coop", "iban": "CH9300000000000000012", "ctry": "CH"},
    ]

    purposes = [
        "Monthly Salary", "Office Rent", "Utility Bill", "Invoice INV-",
        "Online Purchase", "Consulting Fees", "Refund for Order ",
        "Travel Expenses", "Lunch Meeting", "Software License",
        "Cloud Hosting", "Marketing Services", "Legal Fees", "Insurance Premium"
    ]

    for i in range(1, num_entries + 1):
        entry_date = start_date + timedelta(days=i // 7, hours=random.randint(8, 18), minutes=random.randint(0, 59))
        is_credit = random.random() > 0.6 # More debits than credits for "realism"

        entity = random.choice(entities)
        amount_chf = round(random.uniform(5.0, 5000.0), 2)

        if is_credit:
            current_balance += amount_chf
            indicator = "CRDT"
        else:
            current_balance -= amount_chf
            indicator = "DBIT"

        ref = f"REF-{2023}-{i:04}"
        purpose = random.choice(purposes)
        if "Invoice" in purpose or "Refund" in purpose:
            purpose += str(random.randint(10000, 99999))

        ccy_details = ""
        if "ccy" in entity and entity["ccy"] != "CHF":
            src_ccy = entity["ccy"]
            if indicator == "CRDT":
                # Inbound foreign
                rate = 1.10 if src_ccy == "EUR" else 0.90
                instd_amt = round(amount_chf / rate, 2)
                ccy_details = f"""
                        <AmtDtls>
                            <InstdAmt>
                                <Amt Ccy="{src_ccy}">{instd_amt:.2f}</Amt>
                            </InstdAmt>
                        </AmtDtls>
                        <CcyXchg>
                            <SrcCcy>{src_ccy}</SrcCcy>
                            <TrgtCcy>CHF</TrgtCcy>
                            <XchgRate>{rate:.2f}</XchgRate>
                        </CcyXchg>"""
            else:
                # Outbound foreign
                rate = 0.91 if src_ccy == "EUR" else 1.11
                instd_amt = round(amount_chf * rate, 2)
                ccy_details = f"""
                        <AmtDtls>
                            <InstdAmt>
                                <Amt Ccy="{src_ccy}">{instd_amt:.2f}</Amt>
                            </InstdAmt>
                        </AmtDtls>
                        <CcyXchg>
                            <SrcCcy>CHF</SrcCcy>
                            <TrgtCcy>{src_ccy}</TrgtCcy>
                            <XchgRate>{rate:.5f}</XchgRate>
                        </CcyXchg>"""

        party_tag = "Dbtr" if indicator == "CRDT" else "Cdtr"
        party_acct_tag = f"{party_tag}Acct"

        party_xml = f"""
                            <{party_tag}>
                                <Nm>{entity['nm']}</Nm>
                            </{party_tag}>"""

        if "iban" in entity:
            party_xml += f"""
                            <{party_acct_tag}>
                                <Id>
                                    <IBAN>{entity['iban']}</IBAN>
                                </Id>
                            </{party_acct_tag}>"""

        sub_family = "SEPA" if entity.get("ctry") in ["DE", "FR"] else "OTHR"

        entry_xml = f"""
            <Ntry>
                <Amt Ccy="CHF">{amount_chf:.2f}</Amt>
                <CdtDbtInd>{indicator}</CdtDbtInd>
                <Sts>BOOK</Sts>
                <ValDt><Dt>{entry_date.date().isoformat()}</Dt></ValDt>
                <BkTxCd>
                    <Domn>
                        <Cd>PMNT</Cd>
                        <Fmly>
                            <Cd>TRF</Cd>
                            <SubFmlyCd>{sub_family}</SubFmlyCd>
                        </Fmly>
                    </Domn>
                </BkTxCd>
                <NtryDtls>
                    <TxDtls>
                        <Refs>
                            <EndToEndId>{ref}</EndToEndId>
                        </Refs>{ccy_details}
                        <RltdPties>{party_xml}
                        </RltdPties>
                        <RmtInf>
                            <Ustrd>{purpose}</Ustrd>
                        </RmtInf>
                    </TxDtls>
                </NtryDtls>
            </Ntry>"""
        entries.append(entry_xml)

    closing_date = start_date + timedelta(days=num_entries // 7 + 1)

    xml_content = f"""<?xml version="1.0" encoding="UTF-8"?>
<Document xmlns="urn:iso:std:iso:20022:tech:xsd:camt.053.001.02">
    <BkToCstmrStmt>
        <GrpHdr>
            <MsgId>MSG-LARGE-{datetime.now().strftime('%Y%m%d%H%M%S')}</MsgId>
            <CreDtTm>{datetime.now().isoformat()}Z</CreDtTm>
        </GrpHdr>
        <Stmt>
            <Id>STMT-LARGE-001</Id>
            <Acct>
                <Id>
                    <IBAN>CH9300000000000000200</IBAN>
                </Id>
                <Ccy>CHF</Ccy>
            </Acct>
            <Bal>
                <Tp>
                    <CdOrPrtry>
                        <Cd>OPBD</Cd>
                    </CdOrPrtry>
                </Tp>
                <Amt Ccy="CHF">{opening_balance:.2f}</Amt>
                <Dt>
                    <Dt>{start_date.date().isoformat()}</Dt>
                </Dt>
            </Bal>
            {"".join(entries)}
            <Bal>
                <Tp>
                    <CdOrPrtry>
                        <Cd>CLBD</Cd>
                    </CdOrPrtry>
                </Tp>
                <Amt Ccy="CHF">{current_balance:.2f}</Amt>
                <Dt>
                    <Dt>{closing_date.date().isoformat()}</Dt>
                </Dt>
            </Bal>
        </Stmt>
    </BkToCstmrStmt>
</Document>
"""
    return xml_content

if __name__ == "__main__":
    with open("data/large-camt053.xml", "w") as f:
        f.write(generate_camt(200))
    print("Generated data/large-camt053.xml with 200 transactions.")
