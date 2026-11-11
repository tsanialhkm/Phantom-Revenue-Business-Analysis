# Hypothesis Log

| ID | Hypothesis | Evidence for | Evidence against | Status |
|---|---|---|---|---|
| H1 | Finance is missing valid August sales. | — | Finance's GBP 682,680.51 is reproduced from every August invoice line; 0 lines without a matching header. | Rejected |
| H2 | Product excludes transaction records that Finance includes. | Excluding `invoice_id LIKE 'C%'` reproduces Product's GBP 737,014.26 exactly; the excluded 278 cancellation invoices total GBP -54,333.75. | — | Supported |
| H3 | The teams use different reporting dates. | — | The feed covers only 2011-08-01 08:30 to 2011-08-31 17:45, and both totals are reproduced from it. | Rejected |
| H4 | Data duplication explains a material part of the gap. | — | 0 duplicate `line_id` values; the header–line join preserves all 35,284 lines and the Finance total. | Rejected |

## Questions resolved

| ID | Question | Answer | Status |
|---|---|---|---|
| Q1 | What exact logic produces each reported total? | Finance: sum of all lines. Product: sum of lines excluding cancellation invoice IDs. | Resolved |
| Q2 | What does each row represent? | `invoice_lines`: one recorded invoice line; `invoice_headers`: one invoice document. | Resolved |
| Q3 | Which definition best supports monthly management decisions? | Net Invoice Revenue, with gross value and cancellations shown separately. | Resolved |
