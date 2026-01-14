IF OBJECT_ID('production_summary', 'U') IS NOT NULL
    DROP TABLE production_summary;
GO


SELECT
    AREA,
    ITEM,
    YEAR,
    CAST(ROUND(SUM(CASE WHEN ELEMENT = 'Production' THEN VALUE ELSE 0 END), 2) AS DECIMAL(18,2)) AS PRODUCTION,
    CAST(ROUND(SUM(CASE WHEN ELEMENT = 'Yield' THEN VALUE ELSE 0 END), 2) AS DECIMAL(18,2)) AS YIELD,
    CAST(ROUND(SUM(CASE WHEN ELEMENT = 'Yield/Carcass Weight' THEN VALUE ELSE 0 END), 2) AS DECIMAL(18,2)) AS Yield_Carcass,
    CAST(ROUND(SUM(CASE WHEN ELEMENT = 'Area harvested' THEN VALUE ELSE 0 END), 2) AS DECIMAL(18,2)) AS AREA_HARVESTED
INTO production_summary
FROM production
GROUP BY AREA, ITEM, YEAR
ORDER BY AREA, ITEM, YEAR;
GO


SELECT TOP 20 * 
FROM production_summary;


SELECT ITEM, COUNT(*) AS Rows, SUM(PRODUCTION) AS TotalProduction
FROM production_summary
GROUP BY ITEM;


SELECT TOP 20 *
FROM production_summary
ORDER BY AREA, ITEM, YEAR;

IF OBJECT_ID('production_index_summary', 'U') IS NOT NULL
    DROP TABLE production_index_summary;
GO

SELECT
    Area,
    Item,
    Year,
    CAST(
        ROUND(
            SUM(
                CASE 
                    WHEN Element = 'Gross Production Index Number (2014-2016 = 100)'
                    THEN Value 
                    ELSE 0 
                END
            ),
        2
        ) AS DECIMAL(10,2)
    ) AS Gross_Production_Index,

    CAST(
        ROUND(
            SUM(
                CASE 
                    WHEN Element = 'Gross per capita Production Index Number (2014-2016 = 100)'
                    THEN Value 
                    ELSE 0 
                END
            ),
        2
        ) AS DECIMAL(10,2)
    ) AS Per_Capita_Production_Index

INTO production_index_summary
FROM production_indices
WHERE Item IN (
    'Maize (corn)',
    'Wheat',
    'Rice',
    'Raw milk of cattle'
)
GROUP BY Area, Item, Year
ORDER BY Area, Item, Year;
GO

Select top 100* from production_index_summary;

Select top 200* from value_agriculture;

IF OBJECT_ID('value_agriculture_summary', 'U') IS NOT NULL
    DROP TABLE value_agriculture_summary;
GO

SELECT
    Area,
    Item,
    Year,
    CAST(ROUND(SUM(Value), 2) AS DECIMAL(18,2)) AS Gross_Production_Value_USD
INTO value_agriculture_summary
FROM value_agriculture
WHERE Element = 'Gross Production Value (constant 2014-2016 thousand US$)'
GROUP BY Area, Item, Year
ORDER BY Area, Item, Year;
GO

SELECT TOP 20 * FROM value_agriculture_summary;

IF OBJECT_ID('food_balance_summary', 'U') IS NOT NULL
    DROP TABLE food_balance_summary;
GO

SELECT
    Area,
    Item,
    Year,

    CAST(ROUND(SUM(CASE WHEN Element = 'Production' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Production_Quantity,

    CAST(ROUND(SUM(CASE WHEN Element = 'Import quantity' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Import_Quantity,

    CAST(ROUND(SUM(CASE WHEN Element = 'Export quantity' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Export_Quantity,

    CAST(ROUND(SUM(CASE WHEN Element = 'Stock Variation' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Stock_Variation,

    CAST(ROUND(SUM(CASE WHEN Element = 'Domestic supply quantity' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Domestic_Supply_Quantity,

    CAST(ROUND(SUM(CASE WHEN Element = 'Losses' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Losses,

    CAST(ROUND(SUM(CASE WHEN Element = 'Food' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Food_Quantity,

    CAST(ROUND(SUM(CASE WHEN Element = 'Food supply quantity (kg/capita/yr)' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Food_kg_per_capita_year,

    CAST(ROUND(SUM(CASE WHEN Element = 'Food supply (kcal/capita/day)' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Food_kcal_per_capita_day,

    CAST(ROUND(SUM(CASE WHEN Element = 'Protein supply quantity (g/capita/day)' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Protein_g_per_capita_day,

    CAST(ROUND(SUM(CASE WHEN Element = 'Fat supply quantity (g/capita/day)' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Fat_g_per_capita_day

INTO food_balance_summary
FROM food_balance
WHERE Item IN (
    'Maize and products',
    'Wheat and products',
    'Rice and products',
    'Milk - Excluding Butter'
)
GROUP BY Area, Item, Year
ORDER BY Area, Item, Year;
GO

SELECT TOP 20* FROM food_balance_summary


SELECT DISTINCT Item
FROM SUA
ORDER BY Item;

IF OBJECT_ID('supply_utilization_summary', 'U') IS NOT NULL
    DROP TABLE supply_utilization_summary;
GO

SELECT
    Area,
    Item,
    Year,

    CAST(ROUND(SUM(CASE WHEN Element = 'Production' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Production_Quantity,

    CAST(ROUND(SUM(CASE WHEN Element = 'Import quantity' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Import_Quantity,

    CAST(ROUND(SUM(CASE WHEN Element = 'Export quantity' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Export_Quantity,

    CAST(ROUND(SUM(CASE WHEN Element = 'Stock Variation' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Stock_Variation,

    CAST(ROUND(SUM(CASE WHEN Element = 'Loss' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Loss,

    CAST(ROUND(SUM(CASE WHEN Element = 'Food' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Food_Quantity,

    CAST(ROUND(SUM(CASE WHEN Element = 'Food supply (kcal/capita/day)' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Food_kcal_per_capita_day,

    CAST(ROUND(SUM(CASE WHEN Element = 'Protein supply quantity (g/capita/day)' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Protein_g_per_capita_day,

    CAST(ROUND(SUM(CASE WHEN Element = 'Fat supply quantity (g/capita/day)' THEN Value ELSE 0 END), 2)
        AS DECIMAL(18,2)) AS Fat_g_per_capita_day,

    CAST(ROUND(SUM(CASE WHEN Element = 'Total Population - Both sexes' THEN Value ELSE 0 END), 0)
        AS BIGINT) AS Population

INTO supply_utilization_summary
FROM SUA
WHERE Item IN (
    'Maize (corn)',
    'Wheat',
    'Rice',
    'Raw milk of cattle'
)
GROUP BY Area, Item, Year
ORDER BY Area, Item, Year;
GO


SELECT TOP 20* FROM supply_utilization_summary


SELECT DISTINCT Element
FROM Food_Balance
ORDER BY Element;

SELECT DISTINCT Element
FROM production
ORDER BY Element;

SELECT DISTINCT Element
FROM SUA
ORDER BY Element;


