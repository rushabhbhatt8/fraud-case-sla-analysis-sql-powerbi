# Power BI Measure Guide

Use these measures in Power BI after loading the SQL tables.

```DAX
Total Cases = COUNTROWS('fact_fraud_case')

Open Cases =
CALCULATE(
    [Total Cases],
    'dim_status'[status_name] IN { "Open", "In Progress", "Escalated" }
)

Closed Cases =
CALCULATE(
    [Total Cases],
    'dim_status'[status_name] = "Closed"
)

SLA Met Cases =
CALCULATE(
    [Closed Cases],
    'fact_fraud_case'[sla_met_flag] = 1
)

SLA Compliance % =
DIVIDE([SLA Met Cases], [Closed Cases])

Breach Count =
CALCULATE(
    [Closed Cases],
    'fact_fraud_case'[sla_met_flag] = 0
)

Breach Rate % =
DIVIDE([Breach Count], [Closed Cases])

Average Resolution Minutes =
AVERAGE('fact_fraud_case'[resolution_minutes])

Escalation Rate % =
DIVIDE(
    CALCULATE([Total Cases], 'fact_fraud_case'[escalation_flag] = 1),
    [Total Cases]
)

High Risk Cases =
CALCULATE(
    [Total Cases],
    'dim_risk_band'[risk_band] IN { "High", "Critical" }
)

High Risk Case Rate % =
DIVIDE([High Risk Cases], [Total Cases])

Reopened Cases =
CALCULATE(
    [Total Cases],
    'fact_fraud_case'[reopened_flag] = 1
)

Reopen Rate % =
DIVIDE([Reopened Cases], [Total Cases])
```

## Recommended formatting
- KPI cards: bold, clean, 0-1 decimal formatting
- Percentages: 1 decimal place
- Time metrics: display as hours and minutes where possible
- Conditional formatting:
  - green for SLA met
  - amber for approaching target
  - red for breaches

## Suggested slicers
- date
- queue
- agent
- channel
- risk band
- status
