import xml.etree.ElementTree as ET

def validate_camt(filepath):
    try:
        tree = ET.parse(filepath)
        root = tree.getroot()

        # Namespace
        ns = {'camt': 'urn:iso:std:iso:20022:tech:xsd:camt.053.001.02'}

        stmt = root.find('.//camt:Stmt', ns)
        if stmt is None:
            print("Error: <Stmt> not found.")
            return False

        # Get Opening Balance
        opbd_amt = 0.0
        clbd_amt = 0.0

        for bal in stmt.findall('camt:Bal', ns):
            tp = bal.find('.//camt:Cd', ns)
            if tp is not None:
                amt_str = bal.find('camt:Amt', ns).text
                if tp.text == 'OPBD':
                    opbd_amt = float(amt_str)
                elif tp.text == 'CLBD':
                    clbd_amt = float(amt_str)

        print(f"Opening Balance: {opbd_amt}")
        print(f"Closing Balance: {clbd_amt}")

        # Sum transactions
        entries = stmt.findall('camt:Ntry', ns)
        print(f"Number of entries: {len(entries)}")

        calculated_balance = opbd_amt
        for entry in entries:
            amt = float(entry.find('camt:Amt', ns).text)
            ind = entry.find('camt:CdtDbtInd', ns).text
            if ind == 'CRDT':
                calculated_balance += amt
            else:
                calculated_balance -= amt

        calculated_balance = round(calculated_balance, 2)
        print(f"Calculated Closing Balance: {calculated_balance}")

        if calculated_balance == clbd_amt:
            print("Success: Sum of transactions matches closing balance.")
            return True
        else:
            print(f"Error: Balance mismatch! Difference: {round(calculated_balance - clbd_amt, 2)}")
            return False

    except Exception as e:
        print(f"Error during validation: {e}")
        return False

if __name__ == "__main__":
    if validate_camt("data/large-camt053.xml"):
        print("Validation PASSED")
    else:
        print("Validation FAILED")
        exit(1)
