# Case 001: The Phantom Revenue

A spoiler-free business-analysis investigation built from real transaction records.

## Portfolio context

You are the junior business analyst supporting **Alder & Finch Retail**, a fictional UK gift retailer. Product and Finance reported different August 2011 revenue figures. Your job is to reconcile the numbers, determine why the definitions diverge, and recommend a reporting standard.

The company, stakeholders, emails, and reporting dispute are fictional. The transaction rows come from the real **Online Retail II** dataset published by the UCI Machine Learning Repository.

## Start

1. Read `START_HERE.md`.
2. Review the files in `evidence/`.
3. Open `data/alder_finch_case_001.db` with SQLite in VS Code, DB Browser for SQLite, Python, or another SQL client.
4. Record your hypotheses in `documentation/hypothesis_log.md`.
5. Save your queries under `sql/`.
6. Complete `deliverables/case_closure_memo.md` when your evidence is strong enough.

No solution is included in this repository.

## Source and license

- Daqing Chen, *Online Retail II*, UCI Machine Learning Repository, 2012.
- Source page: https://archive.ics.uci.edu/dataset/502/online%2Bretail%2Bii
- DOI: https://doi.org/10.24432/C5CG6D
- License: CC BY 4.0
- Case slice: 1 August 2011 through 31 August 2011
- Source rows retained: 35,284

The relational SQLite tables are a faithful restructuring of the selected source rows. The case narrative and evidence documents were created for this learning project.