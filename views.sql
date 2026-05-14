-- Reporting views for Power BI and SQL analysis

CREATE OR ALTER VIEW dbo.vw_case_summary AS
SELECT
    fc.case_id,
    fc.case_number,
    fc.created_date,
    fc.closed_date,
    fc.case_amount,
    fc.risk_score,
    fc.sla_due_date,
    fc.sla_met_flag,
    fc.escalation_flag,
    fc.reopened_flag,
    fc.suspicious_flag,
    fc.resolution_minutes,
    a.agent_name,
    a.team_name,
    q.queue_name,
    q.priority_level,
    q.sla_target_hours,
    s.status_name,
    c.channel_name,
    r.risk_band
FROM dbo.fact_fraud_case fc
JOIN dbo.dim_agent a ON fc.agent_id = a.agent_id
JOIN dbo.dim_queue q ON fc.queue_id = q.queue_id
JOIN dbo.dim_status s ON fc.status_id = s.status_id
JOIN dbo.dim_channel c ON fc.channel_id = c.channel_id
JOIN dbo.dim_risk_band r ON fc.risk_band_id = r.risk_band_id;
GO

CREATE OR ALTER VIEW dbo.vw_sla_by_queue AS
SELECT
    q.queue_name,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN fc.sla_met_flag = 1 THEN 1 ELSE 0 END) AS sla_met_cases,
    SUM(CASE WHEN fc.sla_met_flag = 0 AND fc.closed_date IS NOT NULL THEN 1 ELSE 0 END) AS sla_breaches,
    CAST(100.0 * SUM(CASE WHEN fc.sla_met_flag = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS DECIMAL(5,2)) AS sla_compliance_pct,
    AVG(CAST(fc.resolution_minutes AS DECIMAL(10,2))) AS avg_resolution_minutes
FROM dbo.fact_fraud_case fc
JOIN dbo.dim_queue q ON fc.queue_id = q.queue_id
GROUP BY q.queue_name;
GO

CREATE OR ALTER VIEW dbo.vw_risk_summary AS
SELECT
    r.risk_band,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN fc.suspicious_flag = 1 THEN 1 ELSE 0 END) AS suspicious_cases,
    SUM(fc.case_amount) AS total_amount,
    AVG(fc.risk_score) AS avg_risk_score
FROM dbo.fact_fraud_case fc
JOIN dbo.dim_risk_band r ON fc.risk_band_id = r.risk_band_id
GROUP BY r.risk_band;
GO
