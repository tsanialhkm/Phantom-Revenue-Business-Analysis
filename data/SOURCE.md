# Data source

## Official dataset

**Online Retail II**, donated by Daqing Chen and hosted by the UCI Machine Learning Repository.

- Dataset page: https://archive.ics.uci.edu/dataset/502/online%2Bretail%2Bii
- Direct download: https://archive.ics.uci.edu/static/public/502/online+retail+ii.zip
- DOI: https://doi.org/10.24432/C5CG6D
- License: Creative Commons Attribution 4.0 International
- Original workbook SHA-256: `bcbe73b35f5b7babf197fb0cb983a11f5d9ff929078d4aa53d171b1f2df2e980`

UCI describes this as real transaction data from a UK-based non-store retailer covering 1 December 2009 through 9 December 2011. The company mainly sells giftware and many customers are wholesalers.

## Case transformation

This case retains all 35,284 source rows dated from 1 August 2011 through 31 August 2011. No transaction value, quantity, invoice identifier, timestamp, stock code, customer identifier, or country was synthetically changed.

The file `raw/online_retail_august_2011.csv` is the extracted source slice. The SQLite database restructures the same rows into relational tables for investigation.
