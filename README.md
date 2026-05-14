# Fraud Operations SLA Tracking Dashboard

A SQL + Power BI portfolio project focused on fraud operations, SLA performance, and case management reporting.

## Project summary

This project simulates a real fraud operations reporting workflow where analysts need to monitor case volume, SLA breaches, agent workload, risk trends, and resolution performance. The goal is to replace manual Excel-based tracking with a repeatable SQL layer and a Power BI dashboard that gives leadership faster visibility into operational health.

## Business problem

Fraud operations teams often work from disconnected sources:
- case logs in spreadsheets
- SLA targets in shared files
- agent performance notes in emails
- weekly reporting built manually

That slows down reporting, makes it harder to spot breach patterns, and creates avoidable rework. This project shows how a structured SQL model and Power BI report can bring those pieces together.

## Tools used

- SQL Server style SQL
- Power BI
- DAX
- Advanced Excel
- Data modeling
- KPI reporting

## What is included

- SQL schema for fraud case tracking and SLA reporting
- Seed data for demo/testing
- Analysis queries for operational reporting
- View definitions for reusable metrics
- Power BI measure guide
- Dashboard wireframe
- Data dictionary
- Validation checklist
- Sample CSV files

## Key KPIs

- Total cases received
- Open cases
- Closed cases
- SLA compliance rate
- SLA breach count
- Average resolution time
- High-risk case rate
- Escalation rate
- Agent productivity
- Backlog aging

## Suggested dashboard pages

### Page 1: Executive Overview
- total cases
- open cases
- SLA compliance
- breach count
- high-risk cases
- trend by day/week

### Page 2: SLA Monitoring
- breach rate by queue
- average handling time
- overdue cases
- aging buckets
- target vs actual performance

### Page 3: Fraud Risk Analysis
- case volume by risk band
- suspicious amount by channel
- escalation reasons
- status breakdown
- high-risk trend

### Page 4: Agent Performance
- cases handled per agent
- average closure time
- SLA adherence by agent
- reopen rate

## Folder structure

```text
fraud_sla_portfolio/
├── README.md
├── PROJECT_OVERVIEW.md
├── DATA_DICTIONARY.md
├── KPI_DEFINITIONS.md
├── dashboard_wireframe.md
├── powerbi/
│   └── powerbi_measure_guide.md
├── sql/
│   ├── schema.sql
│   ├── seed_data.sql
│   ├── views.sql
│   └── analysis_queries.sql
├── data/
│   ├── sample_agents.csv
│   ├── sample_cases.csv
│   ├── sample_daily_workload.csv
│   └── sample_sla_targets.csv
└── docs/
    ├── implementation_steps.md
    └── validation_checklist.md
```

## How to use

1. Run `sql/schema.sql` to create the tables.
2. Run `sql/seed_data.sql` to load demo data.
3. Run `sql/views.sql` to create reusable reporting views.
4. Open Power BI and connect to the SQL tables or imported CSVs.
5. Build the measures from `powerbi/powerbi_measure_guide.md`.
6. Use the dashboard wireframe as the report layout guide.

## Notes

The sample data in this repository is synthetic and anonymized for portfolio use.
