# Global Agricultural Food Systems Analysis (2015-2029)
Production, Food Security & Strategic Outlook (2015–2029)  

A reproducible agricultural intelligence warehouse and policy‑grade analytics pipeline built from FAO (FAOSTAT) data. The objective is to transform raw FAO exports into economic, food‑security, and strategic insights using a full data‑engineering and econometric workflow. The output is a single AI‑ready analytical model supporting monitoring, diagnostics, forecasting and prescriptive policy analysis.

End‑to‑end pipeline
FAO → Excel → SQL Server → SPSS → Python (Google Colab) → Power BI → Quadratic AI

-----

## 📑 Table of Contents

1. [Executive Summary](#executive-summary)
2. [Data Pipeline (High Level)](#data-pipeline-high-level)
3. [Datasets Integrated](#datasets-integrated)
4. [Data Staging (Excel)](#data-staging-excel)
5. [Warehouse Architecture (SQL Server)](#warehouse-architecture-sql-server)
   - [ETL & Validation Workflow](#etl-and-validation-workflow)
   - [Core SQL Modeling Patterns](#core-sql-modeling-patterns)
   - [Fact Tables Explained](#fact-tables-explained)
   - [Example Policy-Grade Indicator](#example-policy-grade-indicator)
6. [SPSS Diagnostics](#spss-diagnostics)
7. [Python (Colab) Panel Modeling & ML](#python-colab-panel-modeling-and-ml)
8. [Key Findings (2015–2024)](#key-findings-2015-2024)
9. [Forecast Outlook (2025–2029)](#forecast-outlook-2025-2029)
10. [Power BI Dashboard Insights](#power-bi-dashboard-insights)
11. [Production Trends — Geographic View](#production-trends-geographic-view)
12. [Production and Balance Trends](#production-and-balance-trends)
13. [Production & Balance Forecast (2025–2029)](#production-and-balance-forecast-2025-2029)
14. [Summary of Key Findings Across Visualizations](#summary-of-key-findings-across-visualizations)
15. [Critical Concerns](#critical-concerns)
16. [Summary of Key Findings from Quadratic AI](#summary-of-key-findings-from-quadratic-ai)
17. [Prioritized Recommendations](#prioritized-recommendations)
18. [Conclusion](#conclusion)



---

## Executive summary 
This project converts FAO long‑format tables into canonical fact tables and a single `Full_dataset` master view. That view is the system of record for:
- food‑security monitoring,
- productivity and efficiency analysis,
- trade dependency and risk assessment,
- loss & waste diagnostics,
- policy and investment planning.

Analytical truth is governed in SQL Server; SPSS, Python and Power BI consume SQL outputs for diagnostics, forecasting and visualization. Quadratic AI is used for exploratory AI‑assisted analytics and scenario experiments, always validated against SQL outputs.

---

## Data pipeline (high level)
FAO Database  
↓ Excel: initial extraction, reconciliation, cleaning (Staging) 
↓ CSV export  
↓ SQL Server (SSMS): warehouse construction & QA  
↓ SPSS: statistical diagnostics
↓ Python (Google Colab): predictive & prescriptive modeling  
↓ Power BI: visualization & dashboards  
↓ Quadratic AI: exploratory AI‑assisted analytics

Notes
- Excel is for early inspection and small, documented fixes only. SQL Server stores canonical datasets and enforces reproducible transforms.

---

## Datasets integrated
| Dataset | What it measures |
|---|---|
| production | Crop & livestock output, yield, harvested area |
| production_indices | Gross & per‑capita production indices (GPI, PCPI) |
| value_agriculture | Economic value of production (constant USD) |
| food_balance | Food supply, calories, protein, fat, losses |
| SUA | Trade flows, stocks, population |

These cover production, economics, nutrition and trade and are merged into the master analytical model.

---

## Data Staging (Excel)

Excel was used as the initial **staging layer** for FAO data ingestion. Raw FAO extracts were standardized, validated, and structured into tabular form before being exported as CSV files and loaded into SQL Server for transformation into analytical fact tables.


🔗 **[Production spreadsheet](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Full%20production%20data.xlsx)**

---

## Warehouse architecture (SQL Server)

Raw FAO tables (long format) → summary fact tables → `Full_dataset` master view.

🔗 **[Fact SQL](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Production%20FAO%20script.sql)**

🔗 **[Master SQL](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Full%20Production%20FAO.sql)**

Raw tables:
- production, production_indices, value_agriculture, food_balance, SUA

Fact tables (T‑SQL):
- production_summary  
- production_index_summary  
- value_agriculture_summary  
- food_balance_summary  
- supply_utilization_summary

Master view:
- `Full_dataset`: harmonized country × commodity × year rows with numeric analytical fields (production, yields, indices, value, nutrition, trade, losses, stocks, population).

---

**ETL & validation workflow**
1. Extract: FAOSTAT API or file downloads.  
2. Inspect / quick fixes: Excel — log every manual change.  
3. Export canonical CSVs to `/data/raw/` and `/data/clean/`.  
4. Load: BULK INSERT / SSIS into SQL Server staging.  
5. Transform: pivot Elements → columns, build fact tables with T‑SQL.  
6. Validate: row counts, null rates, totals vs FAO aggregates, per‑capita checks.  
7. Expose: materialized/indexed tables and views for BI/ML.

Best practices
- Keep raw exports immutable.  
- Use FAOSTAT numeric codes for joins.  
- Version control T‑SQL and notebooks.  
- Maintain a changelog for any Excel/manual fixes.

---

**Core SQL modeling patterns**
Pivot FAO element rows into analytic columns (example):

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

Safe ratios:

```sql
(Losses / NULLIF(Production, 0)) * 100 AS Loss_Rate_Percent
```

Practical notes:
- Normalize currency to constant USD before aggregations.  
- Standardize units: tonnes, kg/ha, kcal/person/day.  
- Include automated ETL QA queries (row counts, min/max, null rates).

---

**What each fact table captures**
- production_summary: Production, Yield, Area_Harvested, Yield_Carcass  
- production_index_summary: Gross Production Index (GPI), Per Capita Production Index (PCPI)  
- value_agriculture_summary: Gross Production Value (constant USD)  
- food_balance_summary: Food_Quantity, kcal/protein/fat per capita, Losses, Imports/Exports  
- supply_utilization_summary: Imports, Exports, Stock_Variation, Population

These feed `Full_dataset` for modelling and dashboards.

---

**Example policy‑grade indicator**
Food Loss Rate (%) = (Losses / Production) × 100

SQL example:

```sql
SELECT
  ps.Area, ps.Item, ps.Year,
  ps.Production,
  fb.Losses,
  CASE WHEN ps.Production > 0 THEN (fb.Losses / ps.Production) * 100 ELSE NULL END AS Loss_Rate_pct
FROM production_summary ps
JOIN food_balance_summary fb
  ON ps.Area = fb.Area AND ps.Item = fb.Item AND ps.Year = fb.Year;
```

Use this to prioritize storage/cold‑chain investments where loss rates are highest.

---

## SPSS diagnostics 
Dataset: `Full production data.sav` (240 rows)

🔗 **[Full production data.spv](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Full%20production%20data.spv)** 

Key observations:
- Production and Losses: strongly right‑skewed.  
- Area_Harvested: bimodal (smallholder vs commercial).  
- Yield: relatively stable distribution.

Statistical guidance:
- Use Spearman correlations where distributions are non‑normal.
- Key correlations: Production ↔ Area_Harvested (≈ 0.75); Production ↔ Value (≈ 0.86); Production ↔ Losses (scale effect).

Regression highlights:
- Production model (R² ≈ 0.77): Area_Harvested and Losses are significant; Imports show negative association; Yield not always significant (land dominates).
- Food Quantity model (R² ≈ 0.50): Production and Losses important; Exports reduce domestic food quantity.
- Nutrition model (R² ≈ 0.93): kcal per capita driven by protein and fat availability.

---

## Python (Colab) panel modeling & ML
Panel: countries = USA, Brazil, France, India, Nigeria, Australia; commodities = Rice, Maize, Wheat, Milk; years = 2015–2024; balanced panel ≈ 200 obs.

🔗 **[Python Script and Output](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Global_Agricultural_Food_Systems_Analysis_Production,_Security_&_Strategic_Outlook_(2015_2029).ipynb)**

Diagnostic correlations:
- Area harvested: 0.84  
- Production value: 0.86  
- Food quantity: 0.80  
- Losses: 0.69

Random Forest forecasting (example):
- R² ≈ 0.99 (test)  
- MAE ≈ 1.7M tonnes

Feature importance (typical):
1. Area_Harvested  
2. Gross Production Value  
3. Losses  
4. Country (India)  
5. Commodity (Rice)

Implication: production is highly predictable from land, value and loss signals — useful for scenario analysis and policy simulation.

---

**Key findings (2015–2024)**
- System is largely land‑driven: area explains much of production variance.  
- Yield gaps are large: USA ≈ 20,000 kg/ha vs Nigeria ≈ 2,000 kg/ha (≈10×).  
- Per‑capita production is declining in 2022–2024 — population growth outpaces production.  
- Trade concentration: USA dominates exports; Nigeria relies heavily on imports.  
- Losses: Nigeria exhibits Loss Rate 200–400% in some years — losses (including imported food) may exceed domestic production (critical red flag).  
- Reducing post‑harvest losses is often a faster, cheaper way to boost effective food supply than expanding farmland.

---

**Forecast outlook (2025–2029)**
(From validated Python/SPSS models)
- USA remains productivity leader; India remains scale leader.  
- Nigeria remains import‑dependent unless loss & yield interventions occur.  
- Australia shows acute climate/drought risk (GPI decline).  
- Global per‑capita availability will weaken if current trends continue.

---

## Power BI Dashboard insights (Key Visualizations & Findings)

The dashboard includes several core visualization groups that drive the analytical conclusions and policy recommendations below.

🔗 **[Power BI Desktop Report](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Full%20Production%20FAO.pbix)**

🔗 **[View Report in Power BI Service](https://app.powerbi.com/groups/470c1a60-a135-4efe-b1aa-de52313d367d/reports/b4ad2fc8-91a7-4299-8aa7-8c8323431f66?ctid=86f8f77a-ed2c-4743-a3cf-3aa43c451ea4&pbi_source=linkShare&bookmarkGuid=bd9dc075-6239-4e6b-b06f-abb2e4d9e21a)**

---
## Production Trends — Geographic View

| Chart / Metric | Finding | Insight |
|---|---|---|
| **Map** | 6 countries across 4 continents | USA, Brazil, France, Nigeria, India, Australia |
| **Yield by Year & Country** | USA ≈ 20,000 kg/ha; Nigeria ≈ 2,000 kg/ha | **10× yield gap** between best and worst |
| **Yield Carcass** | USA ≈ 10,000; Nigeria near 0 | Livestock productivity mirrors crop gap |
| **Area Harvested** | India > 100M hectares | India has the largest agricultural land base |
| **Production Quantity** | USA > 0.5B tonnes | USA leads despite smaller land area (high efficiency) |

**Critical signal**

- India has the **most farmland**, but the **USA produces more**, highlighting a massive **yield efficiency gap**.  
  If India matched U.S. yields, global production could **nearly double**.

----


## Production and Balance Trends

| Chart | Finding | Insight |
|---|---|---|
| **Gross Production Index** | Declining after 2022 for most countries | ⚠️ Australia shows a sharp decline; India remains relatively stable |
| **Gross Production Value (USD)** | India dominates at ≈ $0.15B | India has the highest agricultural economic output |
| **Per Capita Production Index** | Sharp decline (2022–2024) | 🚨 Population growth is outpacing production |
| **Food Quantity** | USA leads at ≈ 0.4M; others below 0.2M | Unequal food distribution capacity |
| **Loss Rate (%)** | 🚨 Nigeria at 200–400% | Nigeria loses more food than it produces (net importer) |
| **Export Quantity** | USA dominates at 50–100M tonnes | USA is the global food exporter |
| **Net Food** | USA and India dominate | Global food availability is concentrated |
| **Import Quantity** | Nigeria highest (~10M tonnes) | Heavy structural import dependency |

**Critical signal**

- Nigeria’s **loss rate of 200–400%** means it is losing not only domestic production but also imported food, a severe **food-security crisis**.

---

## Production & Balance Forecast (2025–2029)

| Chart / Metric | Finding | Insight |
|---|---|---|
| **Yield Forecast** | USA remains highest; slight decline | Yield growth is slowing globally |
| **Area Harvested Forecast** | India ≈ 100M ha; USA ≈ 50M ha | No major land expansion expected |
| **Production Forecast** | USA remains > 0.5B tonnes | Continued but uneven growth |
| **Export Quantity** | USA dominates at ~50M tonnes | Trade remains highly concentrated |
| **Import Quantity** | Nigeria remains highest | Import dependency continues |
| **GPV Forecast** | USA & Brazil lead | Agricultural wealth concentrated |
| **PCPI** | Declining across all countries | ⚠️ Per-capita food availability falling |
| **GPI Forecast** | Australia falls to ~200 | 🚨 Production stress |
| **Net Food** | USA & India dominate | Food security concentrated |
| **Kcal per Capita** | India leads | Nutrition uneven |
| **Losses** | USA ≈ 10M tonnes | High producers also lose the most |

**Critical warnings**

- Australia’s **GPI collapse** signals serious climate/drought risk  
- **Per-capita production declining everywhere**  
- **Nigeria remains import-dependent through 2029**

---

## Summary of Key Findings Across Visualizations

**Global Leaders**

| Metric | Leader | Value |
|---|---:|---:|
| Production | USA | 0.5B+ tonnes |
| Area Harvested | India | 100M+ hectares |
| Yield | USA | 20–40K kg/ha |
| Exports | USA | 50–100M tonnes |
| GPV | India / USA | $0.1–0.15B |

---

## Critical Concerns
- Crisis: Loss Rate 200–400% — Nigeria (critical)  
- Import dependence: Nigeria (high)  
- Declining GPI: Australia (high risk)  
- Lowest yields: Nigeria (critical)  
- Per‑capita decline: all countries (warning)

USA and India are anchors of global food stability.


## Summary of Key Findings From Quadratic AI

🔗 **[Quadratic Production Analysis](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Quadratic%20Production%20Analysis.xlsx)**
 
| Metric | Leader | Value |
|---|---:|---:| 
| Production | USA | 0.5B+ tonnes | 
| Area Harvested | India | 100M+ hectares | 
| Yield | USA | 20–40K kg/ha |
| Exports | USA | 50–100M tonnes | 
| GPV | India / USA | $0.1–0.15B | 

### Critical Concerns 
| Issue | Country | Severity | 
|---|---|---| 
| Loss Rate 200–400% | Nigeria | 🔴 Critical | 
| Import Dependency | Nigeria | 🔴 Critical | 
| Declining GPI | Australia | 🔴 Critical | 
| Lowest Yields | Nigeria | 🔴 Critical | 
| Per Capita Decline | All Countries | 🟠 Warning | 

**Positive Trends** 
- Overall production growing across most countries
- USA maintaining export leadership
- India’s large agricultural base provides stability
  

**Prioritized recommendations**
1. Urgent (Nigeria): invest in cold‑chain, storage, logistics; prioritize loss reduction over land expansion.  
2. Australia: scale drought‑resilient varieties and water infrastructure.  
3. Global: prioritize closing yield gaps (extension, inputs, tech) and cutting post‑harvest losses for highest leverage.  
4. Trade resilience: diversify exporters, strengthen regional trade and buffer stocks.

---


**The global food system in this sample is land‑driven, loss‑heavy and geographically concentrated. Reducing post‑harvest losses and closing yield gaps offer the fastest, highest‑return routes to improved food security. This project provides a data‑engineered, statistically validated, AI‑ready framework to test these policy levers and produce policy‑grade evidence.**

---
