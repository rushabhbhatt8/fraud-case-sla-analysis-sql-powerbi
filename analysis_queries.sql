-- Analysis queries for dashboards and reporting

-- 1. Daily case intake trend
SELECT
    created_date,
    COUNT(*) AS total_cases
FROM dbo.fact_fraud_case
GROUP BY created_date
ORDER BY created_date;

-- 2. SLA compliance by queue
SELECT
    q.queue_name,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN fc.sla_met_flag = 1 THEN 1 ELSE 0 END) AS sla_met_cases,
    CAST(100.0 * SUM(CASE WHEN fc.sla_met_flag = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS DECIMAL(5,2)) AS sla_compliance_pct
FROM dbo.fact_fraud_case fc
JOIN dbo.dim_queue q ON fc.queue_id = q.queue_id
GROUP BY q.queue_name
ORDER BY sla_compliance_pct DESC;

-- 3. Average resolution time by team
SELECT
    a.team_name,
    AVG(CAST(fc.resolution_minutes AS DECIMAL(10,2))) AS avg_resolution_minutes
FROM dbo.fact_fraud_case fc
JOIN dbo.dim_agent a ON fc.agent_id = a.agent_id
WHERE fc.closed_date IS NOT NULL
GROUP BY a.team_name
ORDER BY avg_resolution_minutes;

-- 4. High-risk case count
SELECT
    r.risk_band,
    COUNT(*) AS total_cases
FROM dbo.fact_fraud_case fc
JOIN dbo.dim_risk_band r ON fc.risk_band_id = r.risk_band_id
GROUP BY r.risk_band
ORDER BY total_cases DESC;

-- 5. Escalation rate by channel
SELECT
    c.channel_name,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN fc.escalation_flag = 1 THEN 1 ELSE 0 END) AS escalated_cases,
    CAST(100.0 * SUM(CASE WHEN fc.escalation_flag = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS DECIMAL(5,2)) AS escalation_rate_pct
FROM dbo.fact_fraud_case fc
JOIN dbo.dim_channel c ON fc.channel_id = c.channel_id
GROUP BY c.channel_name;

-- 6. Backlog aging for open cases
SELECT
    case_number,
    created_date,
    DATEDIFF(DAY, created_date, GETDATE()) AS backlog_days
FROM dbo.fact_fraud_case
WHERE closed_date IS NULL
ORDER BY backlog_days DESC;

-- 7. Agent productivity
SELECT
    a.agent_name,
    COUNT(*) AS cases_assigned,
    SUM(CASE WHEN fc.status_id = 4 THEN 1 ELSE 0 END) AS closed_cases,
    AVG(CAST(fc.resolution_minutes AS DECIMAL(10,2))) AS avg_resolution_minutes
FROM dbo.fact_fraud_case fc
JOIN dbo.dim_agent a ON fc.agent_id = a.agent_id
GROUP BY a.agent_name
ORDER BY closed_cases DESC, cases_assigned DESC;

-- 8. SLA breaches by priority
SELECT
    q.priority_level,
    SUM(CASE WHEN fc.sla_met_flag = 0 AND fc.closed_date IS NOT NULL THEN 1 ELSE 0 END) AS breaches
FROM dbo.fact_fraud_case fc
JOIN dbo.dim_queue q ON fc.queue_id = q.queue_id
GROUP BY q.priority_level
ORDER BY breaches DESC;

-- 9. Suspicious case amount by risk band
SELECT
    r.risk_band,
    SUM(CASE WHEN fc.suspicious_flag = 1 THEN fc.case_amount ELSE 0 END) AS suspicious_amount
FROM dbo.fact_fraud_case fc
JOIN dbo.dim_risk_band r ON fc.risk_band_id = r.risk_band_id
GROUP BY r.risk_band
ORDER BY suspicious_amount DESC;

-- 10. Weekly workload snapshot
SELECT
    work_date,
    SUM(cases_opened) AS cases_opened,
    SUM(cases_closed) AS cases_closed,
    SUM(breaches) AS breaches
FROM dbo.fact_daily_workload
GROUP BY work_date
ORDER BY work_date;
