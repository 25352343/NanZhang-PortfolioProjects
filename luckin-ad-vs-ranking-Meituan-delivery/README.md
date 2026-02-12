# Ad Spend vs Marketplace Ranking (Meituan) — Jan–Feb (Store-Week)

A short growth analytics case study on a simple ops question:  
**If we spend more on promotion, do we actually get a better marketplace ranking score?**

This repo uses a **store-week** dataset (8 weeks, Jan–Feb 2023) and focuses on the relationship between:
- `weekly_spend` (ad spend)
- `ranking_score_weekly` (0–1, higher is better)

---

## What’s in the data
**Columns**
- `store_id`
- `week_of_year` (8 weeks)
- `weekly_spend`
- `ranking_score_weekly` (0–1)

**How it’s built (schema-generalised)**
- `ads_fact_daily`: store-level daily ad spend
- `ranking_fact_daily`: store-level daily ranking score  
  > Note: in many real data pipelines the date formats are inconsistent (e.g., `day` can be `YYYY-MM-DD` in one table and `YYYYMMDD` in another). This repo handles that during weekly aggregation.

> Public repo uses anonymised/synthetic data due to confidentiality. The same workflow runs on the original dataset.

---

## SQL (dataset build)
SQL scripts used to create the store-week table are in `/sql`.

**Data quality (minimal but important)**
- Some store-weeks appear in ranking data even when there is **no spend record** (i.e., no ads that week).
- To avoid dropping these weeks, the final join keeps both sides (e.g., FULL OUTER JOIN / spine union).
- Missing spend is treated as **0** for analysis; missing ranking remains **NULL** (unknown).

---

## What I did
1) Built a clean **store-week** dataset from daily spend + daily ranking.  
2) Visualised the relationship in three ways:
   - **Scatter** (log(1+spend) vs ranking score)
   - **Spend buckets** (deciles) → average ranking
   - **Baseline segmentation** (low/mid/high based on *previous-week* ranking) → spend buckets within each cohort

---

## Results (from charts)
### 1) Spend and ranking move together, but there’s a lot of noise
The scatter shows an upward trend: higher spend generally aligns with higher ranking score.  
At the same time, the variance is large — stores with similar spend can end up at very different ranking levels, so spend is not the only driver.

![Scatter](01_scatter_log_spend_vs_ranking.png)

### 2) Ranking improves across spend deciles
When bucketing stores by weekly spend deciles (D1 → D10), average ranking increases steadily.

![Spend buckets](02_spend_buckets_mean_ranking.png)

### 3) Baseline matters: mid-baseline looks most “responsive”
I split store-weeks into **low / mid / high baseline** cohorts using **previous-week ranking**.  
All cohorts trend upward with spend, but differently:
- **High baseline** stores start high and remain high; spend still helps, but marginal gains look smaller.
- **Mid baseline** stores show the strongest lift as spend increases (most “responsive” cohort).
- **Low baseline** stores improve with spend, but remain well below other cohorts — suggesting fundamentals may be limiting.

![Baseline segmentation](03_baseline_cohort_spend_vs_ranking.png)

---

## What I’d do with this (budget actions)
This project is not trying to prove strict causality — it’s a practical allocation lens.

### 1) Increase spend (prioritise)
**Mid-baseline stores** should be the first priority for incremental spend, especially those currently in lower/mid spend buckets but not yet strong in ranking.  
**Why:** they appear most responsive to spend increases in the cohort analysis.

### 2) Maintain / defend (keep spend stable, optimise efficiency)
**High-baseline stores** should be managed as “defense + efficiency”.  
**Why:** they already rank well; incremental spend may have diminishing marginal returns. Focus on ROI and protecting position.

### 3) Decrease / cap spend (reallocate first)
**Low-baseline stores** should be capped first when budgets are tight.  
**Why:** even with higher spend, their ranking remains significantly lower — often a sign that ops/product fundamentals (menu, reviews, fulfillment, pricing, etc.) need improvement before paid spend can translate into ranking.

---

## Extension (if funnel metrics are available)
If we can join store-week funnel metrics (e.g., CVR/orders), we can make the “increase spend” list more precise within the mid-baseline cohort.

**Example rule (A-tier target):**  
If a **mid-baseline** store has **CVR above average** but **ranking_score_weekly < 0.65**, it should be prioritised for increased spend.  
**Rationale:** strong conversion fundamentals but low exposure — paid traffic is more likely to generate incremental orders.

---

## Limitations
This analysis is observational over a short window (8 weeks). Results are correlational and could be affected by seasonality, promotions, store quality, local competition, and other unobserved factors.

