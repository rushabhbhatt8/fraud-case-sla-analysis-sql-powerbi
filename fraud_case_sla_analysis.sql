-- Fraud Case Volume & SLA Analysis
-- Portfolio project for Technical Analyst / Business Analyst roles

-- 1) Create staging table (adjust data types for your SQL platform)
CREATE TABLE fraud_cases (
    case_id VARCHAR(20),
    open_date DATE,
    close_date DATE NULL,
    case_type VARCHAR(100),
    channel VARCHAR(50),
    severity VARCHAR(20),
    status VARCHAR(20),
    sla_hours INT,
    resolution_hours INT,
    sla_breached VARCHAR(5),
    escalated VARCHAR(5),
    region VARCHAR(50),
    team VARCHAR(50),
    assigned_agent VARCHAR(100),
    risk_score INT,
    customer_satisfaction DECIMAL(3,1)
);

-- 2) Core KPI summary
WITH base AS (
    SELECT
        case_id,
        open_date,
        close_date,
        case_type,
        channel,
        severity,
        status,
        sla_hours,
        resolution_hours,
        sla_breached,
        escalated,
        region,
        team,
        assigned_agent,
        risk_score,
        customer_satisfaction,
        CASE
            WHEN risk_score >= 75 THEN 'High Risk'
            WHEN risk_score BETWEEN 50 AND 74 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_band,
        CASE
            WHEN resolution_hours <= sla_hours THEN 1
            ELSE 0
        END AS met_sla_flag
    FROM fraud_cases
),

kpi_summary AS (
    SELECT
        COUNT(*) AS total_cases,
        SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) AS sla_breaches,
        ROUND(AVG(CAST(resolution_hours AS DECIMAL(10,2))), 2) AS avg_resolution_hours,
        ROUND(AVG(CAST(customer_satisfaction AS DECIMAL(10,2))), 2) AS avg_csat,
        SUM(CASE WHEN escalated = 'Yes' THEN 1 ELSE 0 END) AS escalations,
        SUM(CASE WHEN risk_score >= 75 THEN 1 ELSE 0 END) AS high_risk_cases
    FROM base
)
SELECT * FROM kpi_summary;

-- 3) Monthly trend analysis
SELECT
    DATE_TRUNC('month', open_date) AS month_start,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) AS sla_breaches,
    ROUND(AVG(CAST(resolution_hours AS DECIMAL(10,2))), 2) AS avg_resolution_hours
FROM base
GROUP BY DATE_TRUNC('month', open_date)
ORDER BY month_start;

-- 4) Case type performance
SELECT
    case_type,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) AS sla_breaches,
    ROUND(100.0 * SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS breach_rate_pct,
    ROUND(AVG(CAST(resolution_hours AS DECIMAL(10,2))), 2) AS avg_resolution_hours,
    ROUND(AVG(CAST(risk_score AS DECIMAL(10,2))), 2) AS avg_risk_score
FROM base
GROUP BY case_type
ORDER BY breach_rate_pct DESC, total_cases DESC;

-- 5) Escalation patterns by team
SELECT
    team,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN escalated = 'Yes' THEN 1 ELSE 0 END) AS escalations,
    ROUND(100.0 * SUM(CASE WHEN escalated = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS escalation_rate_pct
FROM base
GROUP BY team
ORDER BY escalation_rate_pct DESC;

-- 6) SLA breach heat map by severity and channel
SELECT
    severity,
    channel,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) AS breached_cases,
    ROUND(100.0 * SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS breach_rate_pct
FROM base
GROUP BY severity, channel
ORDER BY severity, breach_rate_pct DESC;

-- 7) Top agents by average resolution time
SELECT
    assigned_agent,
    COUNT(*) AS total_cases,
    ROUND(AVG(CAST(resolution_hours AS DECIMAL(10,2))), 2) AS avg_resolution_hours,
    SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) AS sla_breaches
FROM base
GROUP BY assigned_agent
HAVING COUNT(*) >= 10
ORDER BY avg_resolution_hours DESC, sla_breaches DESC;

-- 8) Window function example: running case volume
SELECT
    case_id,
    open_date,
    case_type,
    team,
    COUNT(*) OVER (PARTITION BY team ORDER BY open_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_team_volume
FROM base
ORDER BY team, open_date;

-- 9) Root cause shortlist
SELECT
    case_type,
    team,
    severity,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN sla_breached = 'Yes' THEN 1 ELSE 0 END) AS sla_breaches,
    SUM(CASE WHEN escalated = 'Yes' THEN 1 ELSE 0 END) AS escalations
FROM base
GROUP BY case_type, team, severity
HAVING COUNT(*) >= 5
ORDER BY sla_breaches DESC, escalations DESC, total_cases DESC;
