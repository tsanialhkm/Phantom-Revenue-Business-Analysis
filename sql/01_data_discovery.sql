--list all available tables and view

SELECT name, type
FROM sqlite_master
WHERE type IN ('table', 'view')
ORDER BY type, name;

-- run schema to view schema notes

SELECT *
FROM schema_notes;


-- CASE 001: Revenue reconciliation

SELECT 'invoice_headers' AS table_name, COUNT(*) AS row_count
FROM invoice_headers

UNION ALL

SELECT 'invoice_lines', COUNT(*)
FROM invoice_lines

UNION ALL

SELECT 'product_catalog', COUNT(*)
FROM product_catalog

UNION ALL

SELECT 'customer_accounts', COUNT(*)
FROM customer_accounts;

SELECT *
FROM invoice_lines
LIMIT 10;

SELECT
    MIN(line_recorded_at) AS earliest_record,
    MAX(line_recorded_at) AS latest_record
FROM invoice_lines;


SELECT
    invoice_id,
    stock_code,
    quantity,
    unit_price_gbp,
    ROUND(quantity * unit_price_gbp, 2) AS line_amount_gbp
FROM invoice_lines
LIMIT 20;

SELECT
    ROUND(SUM(quantity * unit_price_gbp), 2) AS total_amount_gbp
FROM invoice_lines;

SELECT
    invoice_id,
    line_recorded_at,
    stock_code,
    quantity,
    unit_price_gbp,
    ROUND(quantity * unit_price_gbp, 2) AS line_amount_gbp
FROM invoice_lines
WHERE invoice_id LIKE 'C%'
LIMIT 20;

SELECT
    COUNT(*) AS cancellation_lines,
    COUNT(DISTINCT invoice_id) AS cancellation_invoices,
    ROUND(SUM(quantity * unit_price_gbp), 2) AS cancellation_amount_gbp
FROM invoice_lines
WHERE invoice_id LIKE 'C%';

SELECT
    ROUND(SUM(quantity * unit_price_gbp), 2) AS product_amount_gbp
FROM invoice_lines
WHERE invoice_id NOT LIKE 'C%';