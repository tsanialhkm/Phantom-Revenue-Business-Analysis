# Case Closure Memo — The Phantom Revenue

**To:** Senior management, Alder & Finch Retail (fictional)
**Subject:** August 2011 revenue discrepancy between Product and Finance
**Data:** UCI Online Retail II, August 2011 slice (35,284 invoice lines, 1,737 invoices)

## Business question

Which August 2011 revenue figure should management use in the monthly business review, and why do Product (GBP 737,014.26) and Finance (GBP 682,680.51) disagree when both use the same invoice feed?

## Executive finding

Both figures are reproducible from the source data. Product excludes cancellation documents (invoice IDs beginning with `C`); Finance keeps them as negative adjustments. The 278 cancellation invoices (668 lines, GBP -54,333.75) explain the full difference with no unexplained remainder.

## Reconciliation

| Component | Amount (GBP) | Evidence |
|---|---:|---|
| Product reported amount | 737,014.26 | Sum of all lines where `invoice_id NOT LIKE 'C%'` |
| Finance reported amount | 682,680.51 | Sum of all August invoice lines |
| Explained difference | 54,333.75 | Cancellation documents: 278 invoices, 668 lines, GBP -54,333.75 |
| Unexplained remainder | 0.00 | 737,014.26 + (-54,333.75) = 682,680.51 |

Queries: [`sql/02_reconciliation.sql`](../sql/02_reconciliation.sql)

## Root cause

An incomplete KPI definition. The KPI Dictionary defines revenue as `quantity × unit price` but does not say how cancellations are treated. Product labelled a pre-cancellation value simply as "Revenue", so two different metrics appeared directly comparable.

## Rejected hypotheses

| Hypothesis | Why it was rejected |
|---|---|
| Finance is missing valid August sales | Finance's total is reproduced by summing every August invoice line; 0 lines lack a matching header. |
| The teams use different reporting dates | The feed covers only 1–31 August 2011, and both totals are reproduced from that same feed. |
| Duplication or an incorrect join explains the gap | 0 duplicate `line_id` values; the validated header–line join preserves all 35,284 lines and the GBP 682,680.51 total. |

## Recommendation

Adopt **Net Invoice Revenue** as the monthly management KPI: the sum of quantity × unit price for all invoice documents in the period, with cancellation documents retained as negative adjustments. For August 2011 this is **GBP 682,680.51**.

Product may keep GBP 737,014.26 as a separate operational metric, renamed **Gross Invoice Value Before Cancellations**. Dashboards should show gross value, cancellation value and net invoice revenue side by side.

## Preventive control

| Element | Recommendation |
|---|---|
| KPI owner | Finance and Business Operations jointly approve the definition |
| Implementation owner | Data/Product implements the approved rule in dashboards |
| Rule | Gross invoice value + cancellation value = net invoice revenue |
| Threshold | Unexplained remainder must be GBP 0.00 (or within an approved rounding tolerance) |
| Frequency | Every dashboard refresh, reviewed during monthly close |
| Documentation | Formula, filters, date field, owner, version and effective date stored in the KPI Dictionary |

## Assumptions and limitations

The analysis explains the gap between the two supplied reports. It does not establish statutory accounting revenue: the data contains no payment settlement, tax treatment, delivery confirmation, cost of goods sold, or later-period returns. 82 null product descriptions and 193 invoices without an identified customer are genuine source characteristics and do not affect the revenue calculation.

## Confidence

- **High** that cancellation treatment explains the GBP 54,333.75 discrepancy.
- **High** that Finance's amount represents net invoice revenue within the supplied feed.
- **Limited** regarding formal accounting recognition beyond the available evidence.
