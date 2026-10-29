#!/usr/bin/env python3
"""Extract Phase 3 prototype data from the authoritative Vet CMU workbook.

Uses only Python's standard library and reads OOXML cached values. The workbook
is never modified. Financial values are selected by documented sheet/cell refs.
"""

from __future__ import annotations

import hashlib
import json
import re
import zipfile
from datetime import datetime, timezone
from pathlib import Path
from xml.etree import ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
BOOK = ROOT / "Vet_CMU_Interactive_Financial_Dashboard.xlsx"
OUTPUT = ROOT / "data" / "prototype-financial-data.json"
NS = {
    "m": "http://schemas.openxmlformats.org/spreadsheetml/2006/main",
    "r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
    "p": "http://schemas.openxmlformats.org/package/2006/relationships",
}


def package_relationships(archive: zipfile.ZipFile, path: str) -> dict[str, str]:
    root = ET.fromstring(archive.read(path))
    return {node.attrib["Id"]: node.attrib["Target"] for node in root.findall("p:Relationship", NS)}


def normalized_path(base: str, target: str) -> str:
    parts: list[str] = []
    for part in (Path(base).parent / target).parts:
        if part == "..":
            parts.pop()
        elif part != ".":
            parts.append(part)
    return "/".join(parts)


def load_workbook_cells() -> dict[str, dict[str, object]]:
    with zipfile.ZipFile(BOOK) as archive:
        shared: list[str] = []
        if "xl/sharedStrings.xml" in archive.namelist():
            root = ET.fromstring(archive.read("xl/sharedStrings.xml"))
            shared = ["".join(item.itertext()) for item in root.findall("m:si", NS)]

        workbook = ET.fromstring(archive.read("xl/workbook.xml"))
        relationships = package_relationships(archive, "xl/_rels/workbook.xml.rels")
        sheets: dict[str, dict[str, object]] = {}
        for sheet in workbook.findall("m:sheets/m:sheet", NS):
            relationship_id = sheet.attrib[f"{{{NS['r']}}}id"]
            path = normalized_path("xl/workbook.xml", relationships[relationship_id])
            xml = ET.fromstring(archive.read(path))
            cells: dict[str, object] = {}
            for cell in xml.findall("m:sheetData/m:row/m:c", NS):
                ref = cell.attrib["r"]
                value_node = cell.find("m:v", NS)
                inline_node = cell.find("m:is", NS)
                raw = value_node.text if value_node is not None else "".join(inline_node.itertext()) if inline_node is not None else ""
                cell_type = cell.attrib.get("t")
                if cell_type == "s" and raw:
                    value: object = shared[int(raw)]
                elif cell_type in (None, "n") and raw:
                    value = float(raw) if any(char in raw.lower() for char in (".", "e")) else int(raw)
                else:
                    value = raw
                cells[ref] = value
            sheets[sheet.attrib["name"]] = cells
        return sheets


def number(cells: dict[str, object], ref: str) -> float:
    value = cells[ref]
    if not isinstance(value, (int, float)):
        raise ValueError(f"Expected numeric value at {ref}, found {value!r}")
    return float(value)


def main() -> None:
    sheets = load_workbook_cells()
    operating = sheets["รายรับรายจ่ายกำไร"]
    balance = sheets["งบดุล"]
    unit_ops = sheets["รายรับรายจ่ายกำไร_ย่อย"]
    unit_revenue_budget = sheets["ประมาณการรายรับกับรายรับจริง_แย"]
    unit_expense_budget = sheets["ประมาณการรายจ่ายกับรายจ่ายจริงแ"]
    total_revenue_budget = sheets["ประมาณการรายรับกับรายรับจริง_รว"]
    total_expense_budget = sheets["ประมาณการรายจ่ายกับรายจ่ายจริงร"]
    government = sheets["งบประมาณแผ่นดิน"]
    government_detail = sheets["งบแผ่นดินแยกหมวด"]

    period_rows = [("2", "Q2/69"), ("3", "Q1/69"), ("4", "Q4/68"), ("5", "Q3/68")]
    periods = []
    for row, expected_label in period_rows:
        label = str(operating[f"A{row}"])
        if label != expected_label or str(balance[f"A{row}"]) != expected_label:
            raise ValueError(f"Unexpected source period at row {row}: {label}")
        current_assets = number(balance, f"B{row}")
        liabilities = number(balance, f"D{row}")
        periods.append({
            "label": label,
            "fiscalYearLabel": label.split("/")[1],
            "quarterLabel": label.split("/")[0],
            "faculty": {
                "revenue": number(operating, f"B{row}"),
                "expense": number(operating, f"C{row}"),
                "operatingResult": number(operating, f"D{row}"),
                "currentAssets": current_assets,
                "nonCurrentAssets": number(balance, f"C{row}"),
                "liabilities": liabilities,
                "financialLiquidity": number(balance, f"F{row}"),
            },
        })

    unit_codes = [
        "VET-OFFICE", "NOVEL", "MAE-ON-AH", "LARGE-ANIMAL-HOSP", "ELEPHANT-WILDLIFE",
        "VET-DIAG-INNOV", "FELINE-COE", "PET-CMU", "AP-VPH-FS", "PODD", "SRIBUABAN-AHO",
    ]
    name_en = [
        "Faculty of Veterinary Medicine Office", "Northern Animal Health Learning and Promotion Center (NOVEL)",
        "Mae On Animal Hospital", "Large Animal and Livestock Hospital", "Elephant and Wildlife Health Center",
        "Veterinary Diagnostic and Animal Health Innovation Center", "Center of Excellence in Feline Medicine",
        "Pet CMU (Veterinary Enterprise Incubation Group)", "Asia-Pacific Veterinary Public Health and Food Safety Center",
        "One Health Surveillance Center (PODD)", "Sribuaban Animal Hospital Office",
    ]
    units = []
    for index, row in enumerate(range(2, 13)):
        source_name = str(unit_ops[f"A{row}"])
        if source_name != str(unit_revenue_budget[f"A{row}"]) or source_name != str(unit_expense_budget[f"A{row}"]):
            raise ValueError(f"Unit names do not align at row {row}")
        units.append({
            "code": unit_codes[index],
            "nameTh": source_name,
            "nameEn": name_en[index],
            "translationStatus": "PROVISIONAL",
            "periodLabel": "Q2/69",
            "revenue": number(unit_ops, f"B{row}"),
            "expense": number(unit_ops, f"C{row}"),
            "operatingResult": number(unit_ops, f"D{row}"),
            "revenueBudget": number(unit_revenue_budget, f"B{row}"),
            "revenueActual": number(unit_revenue_budget, f"C{row}"),
            "expenseBudget": number(unit_expense_budget, f"B{row}"),
            "expenseActual": number(unit_expense_budget, f"C{row}"),
        })

    payload = {
        "source": {
            "workbook": BOOK.name,
            "sha256": hashlib.sha256(BOOK.read_bytes()).hexdigest(),
            "extractedAt": datetime.now(timezone.utc).isoformat(),
            "method": "OOXML cached values read by scripts/extract-excel-prototype-data.py",
            "lastRefreshed": "2026-07-13",
        },
        "periods": periods,
        "availablePeriodOrder": ["Q3/68", "Q4/68", "Q1/69", "Q2/69"],
        "unitDataPeriod": "Q2/69",
        "units": units,
        "facultyBudget": {
            "periodLabel": "Q2/69",
            "budgetScope": "UNKNOWN",
            "budgetScopeStatus": "FACULTY CONFIRMATION REQUIRED",
            "revenueBudget": number(total_revenue_budget, "B2"),
            "revenueActual": number(total_revenue_budget, "C2"),
            "expenseBudget": number(total_expense_budget, "B2"),
            "expenseActual": number(total_expense_budget, "C2"),
        },
        "governmentBudget": {
            "periodLabel": "Q2/69",
            "budgetScope": "UNKNOWN",
            "budgetScopeStatus": "FACULTY CONFIRMATION REQUIRED",
            "budget": number(government, "B2"),
            "actual": number(government, "C2"),
            "categories": [
                {"code": "EQUIPMENT", "nameTh": "ครุภัณฑ์", "nameEn": "Equipment", "budget": number(government_detail, "B2"), "actual": number(government_detail, "C2")},
                {"code": "CONSTRUCTION", "nameTh": "สิ่งก่อสร้าง", "nameEn": "Construction", "budget": number(government_detail, "B3"), "actual": number(government_detail, "C3")},
            ],
        },
    }

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {OUTPUT.relative_to(ROOT)} from {BOOK.name}")


if __name__ == "__main__":
    main()
