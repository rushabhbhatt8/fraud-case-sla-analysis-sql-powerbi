# Data Dictionary

## dim_agent
| Column | Description |
|---|---|
| agent_id | Unique agent key |
| agent_name | Agent name |
| team_name | Team or queue ownership |
| location | Work location |
| active_flag | 1 if active, 0 if inactive |

## dim_queue
| Column | Description |
|---|---|
| queue_id | Unique queue key |
| queue_name | Queue name |
| priority_level | Operational priority |
| sla_target_hours | Target resolution time in hours |

## dim_status
| Column | Description |
|---|---|
| status_id | Unique status key |
| status_name | Open, In Progress, Escalated, Closed, Reopened |

## dim_channel
| Column | Description |
|---|---|
| channel_id | Unique channel key |
| channel_name | Intake channel |

## dim_risk_band
| Column | Description |
|---|---|
| risk_band_id | Unique risk band key |
| risk_band | Low, Medium, High, Critical |
| risk_score_min | Minimum score |
| risk_score_max | Maximum score |

## fact_fraud_case
| Column | Description |
|---|---|
| case_id | Unique case key |
| case_number | Business case number |
| created_date | Case created date |
| closed_date | Case closed date |
| agent_id | Assigned agent |
| queue_id | Queue assigned |
| status_id | Current status |
| channel_id | Intake channel |
| risk_band_id | Assigned risk band |
| case_amount | Transaction amount under review |
| sla_due_date | SLA deadline |
| sla_met_flag | 1 if closed within target |
| escalation_flag | 1 if escalated |
| reopened_flag | 1 if reopened |
| suspicious_flag | 1 if confirmed suspicious |
| resolution_minutes | Time to resolution in minutes |

## fact_daily_workload
| Column | Description |
|---|---|
| work_date | Reporting date |
| agent_id | Assigned agent |
| queue_id | Queue |
| cases_opened | Number of cases opened |
| cases_closed | Number of cases closed |
| breaches | SLA breaches |
| avg_resolution_minutes | Average resolution time |
