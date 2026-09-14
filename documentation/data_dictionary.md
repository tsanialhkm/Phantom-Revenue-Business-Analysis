# Case Data Dictionary

## `invoice_headers`

Grain: one row per invoice document.

| Column | Type | Meaning |
|---|---|---|
| `invoice_id` | TEXT | Source invoice document identifier |
| `first_recorded_at` | TIMESTAMP | Earliest source timestamp recorded for the document |
| `last_recorded_at` | TIMESTAMP | Latest source timestamp recorded for the document |
| `customer_id` | INTEGER, nullable | Customer account identifier when known |
| `country` | TEXT | Country recorded on the document |

## `invoice_lines`

Grain: one row per recorded invoice line.

| Column | Type | Meaning |
|---|---|---|
| `line_id` | TEXT | Case-specific unique row identifier |
| `invoice_id` | TEXT | Invoice document identifier |
| `line_recorded_at` | TIMESTAMP | Source timestamp retained for the invoice line |
| `stock_code` | TEXT | Product or adjustment code |
| `description` | TEXT, nullable | Source line description |
| `quantity` | INTEGER | Units recorded on the line |
| `unit_price_gbp` | REAL | Unit price in pounds sterling |

## `product_catalog`

Grain: one row per stock code observed in August 2011. The canonical description is the most frequently observed non-null description for the code in the case period.

## `customer_accounts`

Grain: one row per identified customer. The home country is the most frequently observed country for that account in the case period.

## `schema_notes`

A small database view listing the grain of each table.
