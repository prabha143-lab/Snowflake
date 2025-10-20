
-- DDL: Create the physical table referenced by the Semantic View
CREATE OR REPLACE TABLE MYSNOW.PUBLIC.SALES_DATA (
    SALE_DATE DATE,
    PRODUCT_ID VARCHAR(50) PRIMARY KEY,
    REVENUE NUMBER(10, 2),
    REGION VARCHAR(50)
);

-- DML: Insert sample data
INSERT INTO MYSNOW.PUBLIC.SALES_DATA (SALE_DATE, PRODUCT_ID, REVENUE, REGION) VALUES
('2025-09-01', 'P1001', 500.00, 'East'),
('2025-09-01', 'P1002', 750.50, 'West'),
('2025-09-02', 'P1003', 1200.25, 'East'),
('2025-09-02', 'P1004', 300.00, 'North');


-- DDL: Create the Semantic View
CREATE OR REPLACE SEMANTIC VIEW MYSNOW.PUBLIC.SALES_ANALYSIS
TABLES (
    -- 1. Logical Table 'S' maps to the physical table SALES_DATA
    S AS MYSNOW.PUBLIC.SALES_DATA PRIMARY KEY (PRODUCT_ID)
    COMMENT = 'Physical table containing all sales records'
)
-- Since the Semantic View is built on a single logical table, 
-- the RELATIONSHIPS clause is not necessary.

DIMENSIONS (
    -- 2. Defines the dimension 'sale_region' using the physical column REGION
    S.sale_region AS REGION
    COMMENT = 'Geographic area of the sale'
)
METRICS (
    -- 3. Defines the metric 'total_revenue' as the sum of the physical column REVENUE
    S.total_revenue AS SUM(REVENUE)
    COMMENT = 'Total generated revenue'
);

--Semantic view SALES_ANALYSIS successfully created.


-- VERIFY: Describe the created semantic view
DESCRIBE SEMANTIC VIEW MYSNOW.PUBLIC.SALES_ANALYSIS;

-- QUERY: Use the Semantic View to aggregate revenue by region
SELECT *
FROM SEMANTIC_VIEW(
    MYSNOW.PUBLIC.SALES_ANALYSIS 
    DIMENSIONS (sale_region)
    METRICS (total_revenue)
);