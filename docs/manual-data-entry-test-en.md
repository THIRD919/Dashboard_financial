# Manual Data Entry Test Guide

1. Open Terminal.
2. Enter the project folder:

   ```bash
   cd /Users/ninu/Desktop/Project_codex/Dashboard_financial
   ```

3. Start the local demo:

   ```bash
   npm run demo
   ```

4. Open `http://localhost:3000/en/data-entry`.
5. Select **Demo Office Data Entry**.
6. Confirm **Faculty of Veterinary Medicine Office** and **Q2/69**.
7. Enter Actual Revenue `1000000`, Actual Expense `700000`, Current Assets `500000`, and Liabilities `250000`.
8. Select **Calculated automatically**. Expect Operating Result `300,000.00`, Operating Margin `30.0%`, and Financial Liquidity `2.00x`.
9. Select **Save Draft**, refresh, and confirm the draft remains.
10. Select **Open draft** in Existing Records, then **Submit** and **Confirm submission**.
11. Confirm the Submitted records are read-only.
12. Open `http://localhost:3000/en/dashboard`, select the Office Unit, and verify Revenue 1M, Expense 700K, Operating Result 300K, Margin 30.0%, and Financial Liquidity 2.00x.

To start again, stop the server and run `npm run demo:reset`. All manual records are tagged `TEST_ONLY` and remain local.
