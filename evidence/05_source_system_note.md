# Invoice Feed Reference

The invoice feed stores one row per recorded invoice line.

- `invoice_id`: source document identifier
- `invoice_datetime`: date and time the document was generated
- `customer_id`: customer account when known; blank values are permitted
- `stock_code`: source item or adjustment code
- `quantity`: number of units recorded on the line
- `unit_price_gbp`: price per unit in pounds sterling

Operational convention: an invoice identifier beginning with `C` denotes a cancellation document.

The source system can also contain non-product adjustment codes and unidentified customer transactions. These are retained because the feed is an operational record, not a curated management-reporting table.
