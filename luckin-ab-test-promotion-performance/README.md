# A/B Test Case Study — Homepage Promo Card (Low-Price Alert)

This repo is a practical A/B testing case study for a mobile coffee ordering app.  
We evaluate a redesigned homepage promo card (**Variant B**) that adds a **“low-price alert”** badge.

The purpose is to demonstrate an end-to-end A/B workflow (setup → metrics → sanity checks → segmentation → recommendations) using **simulated user-level data**.

---

## Files

- **`ab_experiment.ipynb`**  
  Main notebook: data simulation, hash-based traffic split, A/B tests, A/A sanity check, and segmentation.

- **`AB_Test_Report.pdf`**  
  Delivery-style report with results + business interpretation.

- **`README.md`**  
  Project overview and how to run.

---

## Problem statement (plain English)

Will a low-price alert badge:
1) make more users click the promo card (**CTR up**), and  
2) still lead to more completed orders (**CVR up**)?

A common risk is that the badge attracts curiosity clicks, but users later hit constraints (e.g., minimum delivery threshold / needing to bundle items), which can reduce **post-click conversion**.

---

## Metrics

We keep the funnel simple:

- **CTR** = clicks / exposed users  
  *Did the card attract attention?*

- **PCVR** = conversions / clicks  
  *Did users who clicked actually convert?*

- **CVR** = conversions / exposed users  
  *Overall business outcome.*

Tip: **CVR = CTR × PCVR**. This helps explain whether changes come from attraction (CTR) or post-click quality (PCVR).

---

## Experiment setup (simulation)

- Users are assigned to **Control (A)** vs **Treatment (B)** with a **stable hash-based split** (50/50).  
  This mimics real experimentation platforms where the same user always stays in the same group.
- The dataset includes:
  - **City tier** (merged into two bins for power): `tier_1_2` vs `tier_3_4`
  - **User type**: `new` vs `returning`

Simulation is designed to reflect a realistic mechanism:
- Variant B increases CTR (badge attracts attention)
- Some segments may experience lower PCVR due to post-click friction (e.g., delivery threshold)

---

## Analysis flow (what the notebook does)

1. **Sanity checks**
   - SRM check (traffic split)
   - **A/A test** to validate randomization and metric computation
2. **Overall A/B test**
   - z-tests for CTR, CVR, PCVR
3. **Segmentation (HTE)**
   - By **city bin**: `tier_1_2` vs `tier_3_4`
   - By **user type**: `new` vs `returning`
   - Segments are analyzed **independently** (no cross-slicing) to keep results stable.

---

## Key takeaway (how to read results)

- If **CTR ↑ but PCVR ↓**, the UI is great at attracting clicks but may introduce friction after click.  
- Segment results help decide:
  - where to **keep/ship** the change,
  - and where to **iterate** the post-click experience first.

---

## How to run

1. Open `ab_experiment.ipynb` in Jupyter / VS Code.
2. Run cells top to bottom (no external data required).

Dependencies (typical):
- `numpy`, `pandas`, `scipy`, `matplotlib`

---

## Limitations

- Data is **simulated**, so the “ground truth” effects are created by design.
- This project focuses on practical A/B testing workflow and decision logic (not production pipelines or long-term effects).

---

## Contact / Notes

If you want to extend this case study, good next steps are:
- add guardrail metrics (latency, order failures, cost per conversion),
- run ramp-up rollout logic (10% → 25% → 50% → 100%),
- explore variance reduction (e.g., CUPED) for sensitivity improvements.

