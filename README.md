# TTC Subway Delay Analysis (2024)

Analysis of 26,450 TTC subway delay incidents from the City of Toronto Open Data portal, using SQL (SQLite) and Excel.

**Question:** Where, when and why do subway delay minutes concentrate?

## Data
- **Source:** [City of Toronto Open Data: TTC Subway Delay Data](https://open.toronto.ca/dataset/ttc-subway-delay-data/) (2024) and the TTC delay-code key.
- **Cleaning:** removed 17 exact duplicate rows (26,467 to 26,450); standardized inconsistent `Line` labels (for example `YU`, `YUS`, `LINE 1` into `YU (Line 1)`); added Hour, Month, Peak Period, Delay Band and Code Description fields.
- **Peak definition (assumption):** before 9:00 a.m. or 3:00 p.m. to before 7:00 p.m.
- **Unmatched codes:** 106 records use codes with no description (`PUTO`, `XXXXX`); kept and labelled "Review code".

## Files
| File | What it is |
|---|---|
| `ttc_queries.sql` | 7 SQL queries (aggregation, JOIN, subquery, data-quality check) |
| `ttc.db` | SQLite database (`delays`, `codes` tables) |
| `ttc_delays_clean.csv` | Cleaned data |
| `ttc_delay_codes.csv` | Delay code descriptions |

## Key findings
- **Delay is spread out.** Kipling Station is #1 with 2,228 minutes, only 3.0% of the 74,266 total. The top 10 stations together are about 25%.
- **Line 1 (YU) accounts for 57.1% of delay minutes**, Line 2 (BD) for 39.3%.
- **Peak and Off-peak are nearly equal:** 37,460 vs 36,806 minutes (2.86 vs 2.76 minutes per incident).
- **Disorderly Patron (SUDP) is the top cause** by both incidents (3,417) and minutes (8,568). Security-related codes (SUDP, SUO, SUUT) are the largest group.

## SQL results

Queries are in [`ttc_queries.sql`](ttc_queries.sql). Highlights:

**Top 10 stations by total delay minutes**

| Station | Incidents | Delay minutes | % of total |
|---|---|---|---|
| Kipling | 894 | 2,228 | 3.0% |
| Bloor | 1,109 | 2,209 | 3.0% |
| Eglinton | 673 | 2,141 | 2.9% |
| Kennedy BD | 960 | 2,107 | 2.8% |
| Finch | 896 | 2,072 | 2.8% |
| Davisville | 404 | 1,944 | 2.6% |
| Warden | 439 | 1,559 | 2.1% |
| Dundas | 829 | 1,551 | 2.1% |
| Wilson | 442 | 1,525 | 2.1% |
| York Mills | 316 | 1,520 | 2.0% |

**Peak vs Off-peak**

| Period | Incidents | Delay minutes | Avg min / incident |
|---|---|---|---|
| Peak | 13,099 | 37,460 | 2.86 |
| Off-peak | 13,351 | 36,806 | 2.76 |

**Top delay causes by total minutes** (`JOIN` with `codes`)

| Code | Description | Incidents | Delay minutes |
|---|---|---|---|
| SUDP | Disorderly patron | 3,417 | 8,568 |
| SUO | Security other | 2,514 | 5,863 |
| SUUT | Unauthorized at track level | 724 | 5,611 |
| PUOPO | OPTO (communications) train door monitoring | 1,461 | 5,070 |
| MUI | Injured/ill customer on train - transported | 452 | 4,448 |

**Delay by line**

| Line | Incidents | Delay minutes | % of total |
|---|---|---|---|
| YU (Line 1) | 14,144 | 42,375 | 57.1% |
| BD (Line 2) | 10,985 | 29,163 | 39.3% |
| SHP (Line 4) | 889 | 2,671 | 3.6% |

Screenshots of the queries running are in the `screenshots/` folder.

## Limitations
- Delay minutes measure incident duration, not the number of riders affected.
- Peak is a simplified definition and includes weekends and overnight hours.
- No ridership or train-hours denominator, so rates are not normalized.

## Tools
SQL (SQLite, DB Browser for SQLite), Excel (Tables, PivotTable, INDEX/MATCH).
