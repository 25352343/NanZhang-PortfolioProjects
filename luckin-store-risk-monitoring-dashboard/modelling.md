
# Data Modeling & Processing Workflow

## 1. Project Background

This project builds a **weekly store risk monitoring analytical model** to:

- Identify underperforming stores using **relative MEITUAN delivery platform rankings**
- Avoid absolute metrics such as GMV or revenue, which are not directly comparable
- Support **multi-role responsibility attribution** (operations, regional, delivery roles)
- Enable drill-down analysis for operational decision-making

The model serves both **central strategy teams** and **regional execution teams**.

---

## 2. Data Sources Overview

### Table 1: MEITUAN Delivery Platform Business Circle Weekly Report (Fact Table)

**Purpose**  
Represents weekly relative performance of each store on the delivery platform.

**Core Fields**

- Store ID (internal, primary key)
- Platform Store ID
- Province
- City
- Business Circle Ranking (numeric, 0–1)
- Date (yyyymmdd)

This table acts as the **only fact table**, containing all weekly performance metrics.

---

### Table 2: Store Mapping & Responsibility Table (Dimension)

**Purpose**  
Provides organizational ownership, operational roles, and store attributes.

**Core Fields**

- Store ID (primary key)
- Province
- City
- Store Type (direct-operated / franchised)
- Operations Manager
- Regional Manager
- Delivery Operator
- Store Manager
- Business Division

**Note**

- Operations Manager and Delivery Operator are **parallel roles**
- No direct reporting relationship exists between them
- The model supports **multi-role responsibility attribution**

---

### Table 3: Store Lifecycle Information (Dimension)

**Purpose**  
Defines store lifecycle stage to adjust risk tolerance.

**Core Fields**

- Store ID (primary key)
- Province
- City
- Opening Date
- Closing Date
- Store Lifecycle Status (new / mature / closed)

**Lifecycle Definitions**

- New Store: Operating ≤ 1 year (higher tolerance for C-grade performance)
- Mature Store: Operating > 1 year (persistent C-grade indicates structural risk)
- Closed Store: Excluded from final analysis

---

## 3. Table Join Logic

All three tables are joined using **Store ID** as the primary key, forming a unified
**weekly analytical wide table**.

---

## 4. Derived Metrics Design

### 4.1 Weekly Time Standardization

- Convert yyyymmdd into:
  - Year
  - Week of Year
- Unified display format: `YYYY-WW`

Purpose: support trend analysis and week-over-week comparison.

---

### 4.2 Store Performance Rating (ABC Classification)

Based on business circle ranking:

- Grade A: ≥ 0.90
- Grade B: 0.65 – 0.90
- Grade C: < 0.65

**Rationale**

- Avoids GMV and order count biases
- Uses platform-calculated relative ranking
- Eliminates location and scale differences
- Enables fair cross-store comparison

Thresholds are based on historical performance distribution and operational experience.

---

### 4.3 Week-over-Week Change (WoW)

- Calculates WoW change of business circle ranking
- Distinguishes short-term fluctuations from structural deterioration

---

## 5. Data Filtering Rules

Before final output:

- Exclude closed stores
- Exclude stores without assigned delivery operator

Ensures all records are **actionable and accountable**.

---

## 6. Final Output Schema

### Time Dimension
- Year
- Week

### Store Dimension
- Store ID
- Platform Store ID
- Province
- City

### Performance Metrics
- Business Circle Ranking
- ABC Store Grade
- WoW Change

### Responsibility Dimensions
- Operations Manager
- Regional Manager
- Delivery Operator
- Store Manager
- Business Division

### Store Attributes
- Store Type (direct / franchise)
- Lifecycle Status (new / mature)
- Opening Date
- Closing Date

---

## 7. Modeling Principles

- Prefer **relative platform metrics** over absolute financial values
- Support **matrix organizational structures**
- Incorporate lifecycle context into performance evaluation
- Ensure full data lineage and delivery readiness
