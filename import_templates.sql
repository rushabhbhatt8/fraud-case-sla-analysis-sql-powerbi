-- Bulk import templates for SQL Server
-- Update file paths before running.

BULK INSERT dbo.fact_fraud_case
FROM 'C:\path\to\sample_cases.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT dbo.fact_daily_workload
FROM 'C:\path\to\sample_daily_workload.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
