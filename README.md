# Alder & Finch Retail: The Phantom Revenue

Business analysis and SQL portfolio case based on real transaction records from the UCI Online Retail II dataset.

## Executive summary

Alder & Finch Retail's Product dashboard reported **GBP 737,014.26** for August 2011, while Finance reported **GBP 682,680.51**. I investigated whether the difference came from missing records, reporting dates, duplicate data, or inconsistent metric logic.

Both teams used the same invoice feed, but they treated cancellation documents differently. Product excluded invoice IDs beginning with `C`, while Finance included those documents as reductions to revenue. The 278 cancellation invoices contained 668 lines with a combined value of **GBP -54,333.75**, explaining the reported difference exactly.

I recommend using **Net Invoice Revenue** for monthly management reporting and presenting Product's current figure separately as **Gross Invoice Value Before Cancellations**.

## Business problem

Senior management needed one defensible August revenue figure before the monthly business review. The investigation had to answer:

1. What logic produced each reported amount?
2. Was either report incomplete or technically incorrect?
3. What explained the GBP 54,333.75 difference?
4. Which definition should management adopt?
5. What control would prevent the disagreement from recurring?

## My role

**Role:** Junior Business Analyst  
**Company:** Alder & Finch Retail, a fictional UK gift retailer  
**Tools:** SQLite, SQLTools, VS Code, Markdown  
**Methods:** data discovery, KPI validation, hypothesis testing, reconciliation, root-cause analysis, and business recommendation

## Dataset

The company and reporting dispute are fictional, but the transaction records are real. The case uses an August 2011 slice of the **Online Retail II** dataset published by the UCI Machine Learning Repository.

| Item | Value |
|---|---|
| Period | 1–31 August 2011 |
| Invoice lines | 35,284 |
| Invoice documents | 1,737 |
| Products/stock codes | 2,614 |
| Identified customers | 980 |
| Source | UCI Machine Learning Repository |
| License | CC BY 4.0 |

The original flat transaction data was restructured into a relational SQLite database without changing the retained source rows.

## Data model

| Object | Grain | Purpose |
|---|---|---|
| `invoice_headers` | One row per invoice document | Invoice date, customer, and country |
| `invoice_lines` | One row per recorded invoice line | Quantity, unit price, and line value |
| `product_catalog` | One row per observed stock code | Canonical product description |
| `customer_accounts` | One row per identified customer | Customer's most frequently observed country |
| `schema_notes` | Database view | Documents table grain |

`invoice_headers` connects to `invoice_lines` through `invoice_id`. `product_catalog` connects through `stock_code`, while `customer_accounts` connects to identified invoices through the nullable `customer_id` field.

The revenue analysis uses `invoice_lines` because it contains both fields required by the documented formula:

```text
line amount = quantity × unit_price_gbp
```

## Stakeholder positions

| Stakeholder | Reported amount | Position |
|---|---:|---|
| Product | GBP 737,014.26 | Removes records that do not represent completed sales activity |
| Finance | GBP 682,680.51 | Includes every August invoice document, including reductions |
| KPI Dictionary | Not applicable | Defines the formula but does not specify cancellation treatment |

The operational source note states that an invoice ID beginning with `C` represents a cancellation document.

## Investigation approach

I kept four initial hypotheses open:

| ID | Hypothesis | Final status |
|---|---|---|
| H1 | Finance is missing valid August sales | Rejected as the cause of this discrepancy |
| H2 | Product excludes records that Finance includes | Supported |
| H3 | The teams use different reporting dates | Rejected as the cause of this discrepancy |
| H4 | Duplication or an incorrect join explains the gap | Rejected as the cause of this discrepancy |

The analysis followed five stages:

1. Identify table grain, keys, row counts, and date coverage.
2. Reproduce Finance's reported amount from the source data.
3. Inspect cancellation documents and reproduce Product's amount.
4. Reconcile both figures and calculate the unexplained remainder.
5. Translate the technical finding into a KPI decision and preventive control.

## Data discovery and validation

The source contains 35,284 invoice lines across 1,737 invoices, covering only August 2011. Validation also found:

| Check | Result |
|---|---:|
| Earliest record | 2011-08-01 08:30:00 |
| Latest record | 2011-08-31 17:45:00 |
| Invoice lines without a matching header | 0 |
| Duplicate `line_id` values | 0 |
| Null descriptions | 82 |
| Invoices without an identified customer | 193 |

The null descriptions and unidentified customers are genuine characteristics of the operational source. They do not prevent revenue calculation because `quantity` and `unit_price_gbp` are present on every invoice line.

The validated join between invoice headers and lines preserves all 35,284 lines and the GBP 682,680.51 total. This rules out a join-related row loss as the explanation for the reported gap.

## Reproducing the stakeholder figures

### Finance

Finance's figure is reproduced by summing every August invoice line:

```sql
SELECT
    ROUND(SUM(quantity * unit_price_gbp), 2) AS finance_amount_gbp
FROM invoice_lines;
```

Result: **GBP 682,680.51**.

### Product

Product's figure is reproduced by excluding cancellation invoice IDs:

```sql
SELECT
    ROUND(SUM(quantity * unit_price_gbp), 2) AS product_amount_gbp
FROM invoice_lines
WHERE invoice_id NOT LIKE 'C%';
```

Result: **GBP 737,014.26**.

### Cancellation component

```sql
SELECT
    COUNT(*) AS cancellation_lines,
    COUNT(DISTINCT invoice_id) AS cancellation_invoices,
    ROUND(SUM(quantity * unit_price_gbp), 2) AS cancellation_amount_gbp
FROM invoice_lines
WHERE invoice_id LIKE 'C%';
```

Result: **668 lines**, **278 invoices**, and **GBP -54,333.75**.

## Reconciliation

| Component | Amount (GBP) |
|---|---:|
| Product: gross invoice value before cancellations | 737,014.26 |
| Cancellation documents | -54,333.75 |
| Finance: net invoice revenue | 682,680.51 |
| Reported difference | 54,333.75 |
| Unexplained remainder | 0.00 |

The reconciliation equation is:

```text
GBP 737,014.26 + GBP -54,333.75 = GBP 682,680.51
```

The complete reproducible query is available in [`sql/02_reconciliation.sql`](sql/02_reconciliation.sql).

## Root cause

The discrepancy was not caused by missing source records. It was caused by an incomplete KPI definition and inconsistent cancellation treatment:

- Product excluded cancellation documents and reported a value before cancellations.
- Finance retained cancellation documents as negative revenue adjustments.
- The KPI Dictionary defined revenue as `quantity × unit price` but did not specify how cancellations should be presented.
- The Product dashboard labelled its pre-cancellation value simply as `Revenue`, making two different metrics appear directly comparable.

Both calculations were technically reproducible. The business process failed because metric ownership, naming, and cancellation rules were not sufficiently defined.

## Final decision

Management should adopt **Net Invoice Revenue** as the standard monthly management KPI:

```text
Net Invoice Revenue
= sum of quantity × unit price for all invoice documents in the reporting period,
  with cancellation documents retained as negative adjustments
```

For August 2011, the management figure should therefore be:

> **GBP 682,680.51**

Product may retain **GBP 737,014.26** as a separate operational metric, but it should be renamed **Gross Invoice Value Before Cancellations**. The dashboard should show gross value, cancellation value, and net invoice revenue separately.

## Recommended preventive control

| Control element | Recommendation |
|---|---|
| KPI owner | Finance and Business Operations jointly approve the definition |
| Implementation owner | Data/Product implements the approved rule in dashboards |
| Reconciliation rule | Gross invoice value + cancellation value = net invoice revenue |
| Automated threshold | Unexplained remainder must equal GBP 0.00, or remain within an approved rounding tolerance |
| Frequency | Run on every dashboard refresh and review during monthly close |
| Documentation | Store the formula, filters, date field, owner, version, and effective date in the KPI Dictionary |
| Presentation | Label gross, cancellation, and net metrics explicitly |

## Limitations

This analysis explains the full difference between the two supplied August reports. It does not establish statutory accounting revenue because the dataset does not contain payment settlement, tax treatment, delivery confirmation, cost of goods sold, or all possible later-period returns.

Confidence is therefore:

- **High** that cancellation treatment explains the GBP 54,333.75 discrepancy.
- **High** that Finance's amount represents net invoice revenue within the supplied feed.
- **Limited** regarding formal accounting recognition beyond the available evidence.


## Skills demonstrated

- Translating a stakeholder dispute into testable hypotheses
- Understanding table grain and relational structure
- SQL aggregation, filtering, conditional logic, CTEs, and joins
- Reproducing stakeholder metrics from source data
- Reconciling financial figures to a zero unexplained remainder
- Distinguishing data-quality observations from material root causes
- KPI definition and metric governance
- Writing an executive recommendation with assumptions and limitations

## Data source and attribution

- Daqing Chen, *Online Retail II*, UCI Machine Learning Repository, 2012
- Source: https://archive.ics.uci.edu/dataset/502/online%2Bretail%2Bii
- DOI: https://doi.org/10.24432/C5CG6D
- License: CC BY 4.0

The company, stakeholders, emails, and reporting dispute were created for this learning and portfolio project.