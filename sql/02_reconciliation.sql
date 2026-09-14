WITH reconciliation AS (
    SELECT
        SUM(
            CASE
                WHEN invoice_id NOT LIKE 'C%'
                THEN quantity * unit_price_gbp
                ELSE 0
            END
        ) AS product_amount,

        SUM(
            CASE
                WHEN invoice_id LIKE 'C%'
                THEN quantity * unit_price_gbp
                ELSE 0
            END
        ) AS cancellation_amount,

        SUM(quantity * unit_price_gbp) AS finance_amount
    FROM invoice_lines
)

SELECT
    ROUND(product_amount, 2) AS product_amount_gbp,
    ROUND(cancellation_amount, 2) AS cancellation_amount_gbp,
    ROUND(finance_amount, 2) AS finance_amount_gbp,
    ROUND(product_amount - finance_amount, 2) AS reported_gap_gbp
FROM reconciliation;