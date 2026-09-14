SELECT name, type
FROM sqlite_master
WHERE type IN ('table','view');


SELECT *
FROM schema_notes;

SELECT *
FROM invoice_lines
LIMIT 20;

SELECT *
FROM invoice_headers
limit 20;

SELECT 
    MIN("line_recorded_at") as paling_awal, 
    MAX("line_recorded_at") as paling_akhir
FROM invoice_lines;

SELECT SUM(quantity*unit_price_gbp) as jumlah_keseluruhan
FROM invoice_lines;

SELECT SUM(quantity*unit_price_gbp) as jumlah_keseluruhan
FROM invoice_lines
WHERE invoice_id not LIKE "C%";

SELECT SUM(quantity*unit_price_gbp) as jumlah_keseluruhan
FROM invoice_lines
WHERE invoice_id LIKE "C%";

