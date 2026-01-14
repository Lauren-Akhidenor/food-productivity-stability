CREATE OR ALTER VIEW Full_dataset AS
SELECT
    p.Area,
    p.Item,
    p.Year,

    ISNULL(p.Production, 0.00) AS Production,
    ISNULL(p.Yield, 0.00) AS Yield,
    ISNULL(p.Area_Harvested, 0.00) AS Area_Harvested,
    ISNULL(p.Yield_Carcass, 0.00) AS Yield_Carcass,


    ISNULL(pi.Gross_Production_Index, 0.00) AS Gross_Production_Index,
    ISNULL(pi.Per_Capita_Production_Index, 0.00) AS Per_Capita_Production_Index,

    ISNULL(v.Gross_Production_Value_USD, 0.00) AS Gross_Production_Value_USD,

    ISNULL(f.Food_Quantity, 0.00) AS Food_Quantity,
    ISNULL(f.Food_kcal_per_capita_day, 0.00) AS Food_kcal_per_capita_day,
    ISNULL(f.Protein_g_per_capita_day, 0.00) AS Protein_g_per_capita_day,
    ISNULL(f.Fat_g_per_capita_day, 0.00) AS Fat_g_per_capita_day,
	 ISNULL(f.Losses, 0.00) AS losses,

 
    ISNULL(s.Import_Quantity, 0.00) AS Import_Quantity,
    ISNULL(s.Export_Quantity, 0.00) AS Export_Quantity,
    ISNULL(s.Stock_Variation, 0.00) AS Stock_Variation,
    ISNULL(s.Loss, 0.00) AS Loss
FROM production_summary p

LEFT JOIN production_index_summary pi
    ON p.Area = pi.Area
    AND p.Item = pi.Item
    AND p.Year = pi.Year

LEFT JOIN value_agriculture_summary v
    ON p.Area = v.Area
    AND p.Item = v.Item
    AND p.Year = v.Year

LEFT JOIN food_balance_summary f
    ON p.Area = f.Area
    AND p.Year = f.Year
    AND (
        (p.Item = 'Maize (corn)' AND f.Item LIKE '%Maize%')
        OR (p.Item = 'Wheat' AND f.Item LIKE '%Wheat%')
        OR (p.Item = 'Rice' AND f.Item LIKE '%Rice%')
        OR (p.Item = 'Raw milk of cattle' AND f.Item LIKE '%Milk%')
    )

LEFT JOIN supply_utilization_summary s
    ON p.Area = s.Area
    AND p.Year = s.Year
    AND (
        (p.Item = 'Maize (corn)' AND s.Item LIKE '%Maize%')
        OR (p.Item = 'Wheat' AND s.Item LIKE '%Wheat%')
        OR (p.Item = 'Rice' AND s.Item LIKE '%Rice%')
        OR (p.Item = 'Raw milk of cattle' AND s.Item LIKE '%Milk%')
    )
GO

SELECT TOP 200 *
FROM Full_dataset
ORDER BY Area, Item, Year;



SELECT
    Area,
    Item,
    Year,
    Production,
    Food_Quantity
FROM Full_dataset

SELECT
    Area,
    Item,
    Year,
    Production,
    Gross_Production_Value_USD
FROM Full_dataset;


SELECT
    Area,
    Item,
    Year,
    Production,
    Loss,
    (Loss / NULLIF(Production, 0)) * 100 AS Loss_Rate_Percent
FROM Full_dataset;

SELECT
    Area,
    Item,
    Year,
    Production,
    losses,
    (losses / NULLIF(Production, 0)) * 100 AS Losses_Rate_Percent
FROM Full_dataset;

