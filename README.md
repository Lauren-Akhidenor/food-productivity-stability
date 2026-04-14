# Global Agricultural Food Systems Analysis (2015 - 2029)
## A Data-Driven Case Study on Yield Inequality, Food Security & Systemic Risk

---

## The Problem

Global food systems are under increasing pressure from a combination of **unequal productivity, post-harvest inefficiencies, and concentrated trade dependencies**.

This project analyzes FAO (FAOSTAT) agricultural data across six countries and four core commodities to answer a central question:

> **Is global food insecurity primarily a production problem, or a systems efficiency problem?**

### Key Answer:
The evidence shows that food insecurity is driven less by total production capacity and more by:
- Structural yield inequality (up to 10× between countries)
- Post-harvest losses
- Concentrated global trade flows
- Declining per-capita food availability

---

## The Situation 

Despite global increases in agricultural output, food insecurity persists due to inefficiencies in how food is:

- Produced
- Stored
- Distributed
- Traded

This study focuses on a comparative system analysis of:

### Countries
USA, India, Brazil, France, Nigeria, Australia  

### Commodities
Rice, Maize, Wheat, Milk  

### Timeframe
2015–2024 (historical analysis)  
2025–2029 (forecast simulation)

---

## The Approach

A full data engineering and analytics pipeline was built to ensure reproducibility and policy-grade reliability:

**FAO → Excel → SQL Server → SPSS → Python → Power BI**

### System Design Philosophy
- SQL Server acts as the **single source of analytical truth**
- SPSS provides **statistical validation**
- Python enables **predictive modelling**
- Power BI enables **decision-layer visualization**

---

## Data Engineering Pipeline

FAO (FAOSTAT)  
↓  
Excel (Data Staging & QA)  
↓  
SQL Server (Warehouse Construction)  
↓  
SPSS (Statistical Diagnostics)  
↓  
Python (Panel Regression + ML Forecasting)  
↓  
Power BI (Business Intelligence Layer)

---

## Analytical Model
The raw FAO long-format dataset was transformed into a structured analytical model using SQL pivoting logic:

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


🔗 **[Fact SQL](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Production%20FAO%20script.sql)**

🔗 **[Master SQL](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Full%20Production%20FAO.sql)**


----
## Derived KPI
Food Loss Rate = Losses / Production  

---

## Key Insights

### 6.1 Structural Inequality in Productivity
- USA exhibits ~10× higher yield than Nigeria  
- Agricultural output is strongly land- and efficiency-dependent  

### 6.2 Systemic Losses
- Post-harvest losses significantly reduce effective food supply  
- In some regions, losses outweigh production gains  

### 6.3 Trade Concentration Risk
- A small number of countries dominate global exports  
- This creates systemic vulnerability in global supply chains  

### 6.4 Declining Per-Capita Availability
- Despite production growth, per-capita availability is declining post-2022  

---

## Statistical Validation (SPSS Layer)

### Descriptive Findings
- Strong skew in production and loss distributions  
- Yield distributions remain relatively stable  

### Model Performance
- R² range: 0.50 – 0.93 across regression models  

### Interpretation
Production is more strongly driven by structural factors (land, losses) than efficiency gains alone  

🔗 **[Full production data.spv](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Full%20production%20data.spv)** 


---

## Predictive Modelling (Python Layer)

A balanced panel dataset (~200 observations) was used for machine learning forecasting.

### Model: Random Forest Regression

### Performance
- R² ≈ 0.99 (upper bound; indicates strong signal but potential overfitting risk)  
- MAE ≈ 1.7M tonnes  

### Key Predictors
- Area harvested  
- Production value  
- Losses  
- Country effects  
- Commodity type  

### Insight
Production systems are highly predictable from structural variables, reinforcing the dominance of land and efficiency constraints.


🔗 **[Python Script and Output](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Global_Agricultural_Food_Systems_Analysis_Production,_Security_&_Strategic_Outlook_(2015_2029).ipynb)**



---

## Forecasting Results (2025–2029)

### Key Trends Identified
- USA remains global productivity leader  
- India remains dominant in land availability  
- Nigeria remains structurally import-dependent  
- Australia faces climate-driven production decline  
- Global per-capita availability continues to weaken  

---

## Business Intelligence Layer (Power BI)

The Power BI dashboard provides multi-layer visibility into:
- Production efficiency  
- Yield disparities  
- Trade flows  
- Food balance dynamics  
- Forecast trajectories  


🔗 **[Power BI Desktop Report](https://github.com/Lauren-Akhidenor/food-productivity-stability/blob/main/Full%20Production%20FAO.pbix)**

🔗 **[View Report in Power BI Service](https://app.powerbi.com/groups/470c1a60-a135-4efe-b1aa-de52313d367d/reports/b4ad2fc8-91a7-4299-8aa7-8c8323431f66?ctid=86f8f77a-ed2c-4743-a3cf-3aa43c451ea4&pbi_source=linkShare&bookmarkGuid=bd9dc075-6239-4e6b-b06f-abb2e4d9e21a)**


---

## What It All Means

Across all analytical layers, a consistent structure emerges:

### Global Food System Structure
- Land-driven → production depends heavily on acreage  
- Inefficient → significant post-harvest losses  
- Unequal → extreme yield disparity across countries  
- Concentrated → export power held by few economies  

---

## Risk Analysis 

| Risk | Location | Severity |
|------|----------|----------|
| Post-harvest inefficiency | Nigeria | Critical |
| Import dependency | Nigeria | Critical |
| Yield stagnation | Global | High |
| Climate stress | Australia | High |

### Interpretation
These risks directly translate into food insecurity exposure, supply instability, and climate vulnerability.

---

## 13. Limitations 

- Limited scope: 6 countries, 4 commodities (not fully global)  
- Potential overfitting in ML model (R² ≈ 0.99)  
- Possible inconsistencies in FAO unit standardization  
- Loss rate metric sensitive to denominator structure  
- Forecast assumes structural continuity (no major shocks)  

---

## Impact 

### Analytical Impact
- Built a reproducible FAO data warehouse architecture  
- Integrated SQL, statistical, and ML pipelines into one system  
- Created reusable framework for agricultural analytics  

### Policy Impact
- Identified yield gaps (up to 10×) as the most important constraint  
- Quantified post-harvest loss as a major inefficiency driver  
- Highlighted structural import dependency risks  

### Strategic Impact
- Enables early-warning food security monitoring  
- Supports investment targeting in agriculture systems  
- Provides scenario planning capability for policy design  

---

## Conclusion

This project demonstrates that global food insecurity is not primarily a production constraint problem.

Instead, it is structurally driven by:

- Yield inequality  
- Post-harvest losses  
- Trade concentration  

### Final Insight:
Improving global food security requires optimizing systems, not just increasing production.

Addressing these structural inefficiencies provides the highest-leverage pathway to building resilient global food systems.






