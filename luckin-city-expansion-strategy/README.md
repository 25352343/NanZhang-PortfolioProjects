# Luckin City Expansion Strategy (East China)

## Project Overview

This project presents a data-driven framework to support
**city-level expansion decisions** for Luckin Coffee in East China.

From a strategy consulting perspective, the goal is not only to
identify high-growth cities, but also to evaluate whether such growth
is **scalable, repeatable, and operationally sustainable**.

The analysis focuses on four core questions:
1. Which cities show the fastest YoY GMV growth after removing seasonality?
2. Is city-level growth driven by scalable store clusters or single flagship stores?
3. To what extent is growth driven by delivery (vs. offline consumption)?
4. Can marketing investment reliably accelerate early-stage store performance?

---

## Business Context

Luckin Coffee operates under a high-density, city-centric expansion model.
In such a model, **choosing the right cities matters more than choosing
individual stores**.

Key strategic challenges include:
- Avoiding expansion into cities with short-term or volatile growth
- Distinguishing scalable growth from flagship-driven performance
- Designing the right expansion model (delivery-first vs. location-driven)
- Controlling marketing ROI during rapid rollout

This project simulates a real-world strategy analysis conducted
under enterprise data constraints.

---

## Scope & Assumptions

- **Region**: East China
- **Brand**: Luckin Coffee
- **Time Period**:
  - City growth comparison: 21Q1 vs 22Q1
  - Store & delivery analysis: 22Q1
  - Marketing effectiveness: Feb 2023
- **Granularity**:
  - City level
  - Store level
  - SKU level (for marketing validation)

---

## Analytical Framework

The analysis follows a top-down strategic logic:

1. **City Growth Diagnosis**  
   Identify cities with strong YoY GMV growth after controlling for seasonality.

2. **Store Contribution Structure**  
   Evaluate whether growth is driven by multiple stores or concentrated in a few.

3. **Delivery-Driven Growth Assessment**  
   Measure the role of delivery in supporting scalable expansion.

4. **Marketing & SKU Validation**  
   Validate whether marketing spend translates into real sales growth.

Each step builds on the conclusions of the previous one.

## Data Availability & Technical Scope

Due to data governance and security constraints,
all transaction and marketing data used in this project
are queried directly within Alibaba Cloud environments.

- SQL queries are executed in MaxCompute
- Results are reviewed online
- Raw data and CSV exports are not permitted

This setup reflects real-world conditions in
enterprise analytics, consulting projects,
and internal strategy teams.


