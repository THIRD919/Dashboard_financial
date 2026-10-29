# Excel Import Operator Guide

1. Run `npm run demo` and open `http://localhost:3000/en/import`.
2. Use `templates/TEST_ONLY_Vet_CMU_Office_Q2_69.xlsx` for the first acceptance test.
3. Choose the file and select **Upload and Validate**.
4. Review counts, mappings, source cells, warnings, errors, duplicates and conflicts.
5. Review the financial summary and reconciliation.
6. **Confirm Import** is enabled only when no blocking errors remain.
7. After success, open the Dashboard, select the Office Unit, and verify the imported values.

Blank means No Data; numeric zero is authoritative zero. Never resolve existing data by overwriting it. Phase 4C files remain local and must not be uploaded to external services.
