
# Does Ad Spend Improve Marketplace Ranking? (Meituan)  
**Topic:** Growth analytics / marketplace performance / quasi-experiment readout  
**Time window:** Jan–Feb 2023 (store-week level)

## Context
For marketplace-based delivery, store ranking/visibility affects traffic and orders. Ops teams often ask:
**Does increasing ad spend improve a store’s business-district ranking score, and under what conditions?**

## Data (schema-generalised)
- `ads_fact_daily` — store-level daily ad spend (Meituan)
- `ranking_fact_daily` — store-level daily business-district ranking score (0–1; higher is better)
- Grain for analysis: **store-week**

## Key metrics
- **Weekly Spend:** sum(ad_spend) by store-week  
- **Ranking Score (0–1):** a continuous score (NOT rank position). Higher means better marketplace standing/visibility.

## Method
1) Aggregate daily spend to store-week.  
2) Aggregate ranking score to store-week (average across days).  
3) Join spend and ranking to build the analysis dataset.  
4) Analyse:
   - Scatter: spend vs ranking
   - Spend buckets (quartiles/deciles): average ranking per bucket
   - Segment cuts (optional): baseline ranking cohorts (low/mid/high)
5) Optional quasi-experiment:
   - Identify “spend increase” weeks and compare ranking change vs a stable-spend control cohort.

## Deliverables
- A clean store-week dataset (`sql/03_join_spend_ranking.sql`)
- Visuals in `/assets/`
- Recommendations on where incremental spend is likely to work vs where fundamentals should be improved first.

## Limitations
This is observational; confounding may exist (seasonality, promotions, store quality). The quasi-experiment helps but does not fully guarantee causality.
