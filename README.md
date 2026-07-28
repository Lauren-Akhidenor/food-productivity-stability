# Feeding the Future: A Predictive Analytics Framework for Global Agricultural Productivity, Risk & Food Security (2015–2029)

---

## Project Overview

Global food insecurity is often viewed as a challenge of producing enough food. However, increasing agricultural output does not always translate into improved food availability, accessibility, or resilience.

This project explores whether food insecurity is mainly a production challenge or whether deeper structural issues within global food systems contribute to vulnerability.

The analysis investigates:

- Agricultural productivity inequalities
- Post-harvest food losses
- Trade dependency and supply chain risks
- Changes in food availability per person

Using FAOSTAT agricultural data, this project analyses six countries and four major commodities to understand where food systems experience the greatest risks and inefficiencies.

## Key Question

> Is global food insecurity driven by insufficient production, or by inefficiencies in how food is produced, protected, and distributed?

---

## Scope

**Countries**

| Country | Why it's included |
|---|---|
| 🇺🇸 USA | High-productivity benchmark |
| 🇮🇳 India | Large-scale producer |
| 🇧🇷 Brazil | Major exporter |
| 🇫🇷 France | High-efficiency system |
| 🇳🇬 Nigeria | Food security vulnerability case |
| 🇦🇺 Australia | Climate & production risk case |

**Commodities:** Rice · Maize · Wheat · Milk

**Timeframe:** Historical analysis (2015–2024) → Forecast scenario (2025–2029)

---

## The Pipeline

```
FAOSTAT → Excel → SQL Server → SPSS → Python → Power BI
```

| Stage | Tool | Purpose |
|---|---|---|
| Data engineering | SQL Server, Excel | Clean and structure raw FAO data |
| Statistical validation | SPSS | Test relationships and distributions |
| Predictive modelling | Python (Pandas, Scikit-learn) | Forecast production trends |
| Visualisation | Power BI | Bring it all together in an interactive dashboard |

The raw FAO dataset (long-format) was pivoted into an analysis-ready structure in SQL:

```sql
SELECT
  Area,
  Item,
  Year,
  SUM(CASE WHEN Element = 'Production' THEN Value ELSE 0 END) AS Production,
  SUM(CASE WHEN Element = 'Area harvested' THEN Value ELSE 0 END) AS Area_Harvested,
  SUM(CASE WHEN Element = 'Yield' THEN Value ELSE 0 END) AS Yield,
  SUM(CASE WHEN Element = 'Losses' THEN Value ELSE 0 END) AS Losses,
  SUM(CASE WHEN Element = 'Imports' THEN Value ELSE 0 END) AS Imports,
  SUM(CASE WHEN Element = 'Exports' THEN Value ELSE 0 END) AS Exports
FROM raw_fao_table
GROUP BY Area, Item, Year;
```

🔗 [Fact SQL](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Production%20FAO%20script.sql) · [Master SQL](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Full%20Production%20FAO.sql)

**Key metric:**
```
Food Loss Rate = Losses ÷ Production
```

---

## What the Data Shows

**Productivity is wildly unequal**
The USA's yields run roughly **10× higher** than Nigeria's — a gap driven by land access, infrastructure, and efficiency, not effort.

**Post-harvest losses quietly erase gains**
In several regions, losses cancel out production growth almost entirely. Growing more food doesn't help if it never reaches anyone.

**Trade is concentrated and fragile**
A small handful of countries account for most global exports, leaving the wider system exposed to shocks in just a few places.

**Per-capita availability is slipping**
Despite rising total production, food available per person has been declining since 2022.

---

## Statistical Validation (SPSS)

- Production and loss distributions are strongly skewed; yield is comparatively stable
- Regression models achieved **R² between 0.50–0.93**
- Production is explained more by structural factors (land, losses) than by efficiency gains alone

🔗 [Full SPSS Output](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Full%20production%20data.spv)

---

## Predictive Modelling (Python)

A **Random Forest Regression** model was trained on a balanced panel of ~200 observations.

| Metric | Result |
|---|---|
| R² | ≈ 0.99 (strong signal, some overfitting risk) |
| MAE | ≈ 1.7M tonnes |

**Top predictors:** area harvested, production value, losses, country effects, commodity type

🔗 [Notebook & Output](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Global_Agricultural_Food_Systems_Analysis_Production,_Security_%26_Strategic_Outlook_(2015_2029).ipynb)

**Forecast highlights (2025–2029):**
- USA holds its lead in productivity
- India stays dominant in sheer land availability
- Nigeria remains structurally import-dependent
- Australia faces continued climate-driven production risk
- Global per-capita availability keeps weakening

---

## Dashboard (Power BI)

An interactive dashboard ties everything together: production efficiency, yield gaps, trade flows, food balances, and forecast trajectories.

🔗 [Power BI File (.pbix)](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Full%20Production%20FAO.pbix) · [View Report Online](https://app.powerbi.com/groups/470c1a60-a135-4efe-b1aa-de52313d367d/reports/b4ad2fc8-91a7-4299-8aa7-8c8323431f66?ctid=86f8f77a-ed2c-4743-a3cf-3aa43c451ea4&pbi_source=linkShare&bookmarkGuid=bd9dc075-6239-4e6b-b06f-abb2e4d9e21a)

---

## Risk Snapshot

| Risk | Where | Severity |
|---|---|---|
| Post-harvest inefficiency | Nigeria | 🔴 Critical |
| Import dependency | Nigeria | 🔴 Critical |
| Yield stagnation | Global | 🟠 High |
| Climate stress | Australia | 🟠 High |

---

## The Takeaway

Global food insecurity isn't primarily a production problem. It's a **systems** problem — shaped by:

- Unequal productivity
- Post-harvest losses
- Concentrated trade dependency

**Bottom line:** improving food security means investing in *how the system works*, not just growing more food.

---

## Limitations

- Covers 6 countries and 4 commodities — a slice of the global system, not the whole picture
- The ML model's near-perfect R² (≈0.99) likely reflects some overfitting
- FAOSTAT reporting standards vary slightly across countries
- Forecasts assume no major structural shocks (climate, policy, conflict)

---

## Why This Matters

- **Analytically:** a reusable, reproducible pipeline (SQL → SPSS → Python → BI) for agricultural data
- **For policy:** flags yield gaps and post-harvest losses as higher-leverage fixes than raw output growth
- **Strategically:** a foundation for early-warning monitoring and scenario planning in food security

---

## Repository Structure

```
food-productivity-stability
│
├── README.md
│
├── Data
│   └── FAOSTAT_agriculture_dataset.xlsx
│
├── SQL
│   ├── Fact_SQL.sql
│   └── Master_SQL.sql
│
├── Python
│   └── Global_Food_System_Analysis.ipynb
│
├── SPSS
│   └── Statistical_Validation.spv
│
├── Dashboard
│   └── PowerBI_Food_System_Report.pbix
│
├── Results
│   └── Model_Output.xlsx
│
└── requirements.txt
```

---

**Tools:** SQL Server · SPSS · Python (Pandas, Scikit-learn) · Power BI · FAOSTAT
