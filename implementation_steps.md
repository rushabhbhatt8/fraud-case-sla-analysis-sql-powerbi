# Implementation Steps

1. Create the SQL tables using `schema.sql`.
2. Load the sample data from `seed_data.sql` or the CSV files.
3. Validate row counts and relationships.
4. Build views from `views.sql`.
5. Connect Power BI to the SQL database.
6. Create relationships using the data model:
   - fact_fraud_case to dim_agent
   - fact_fraud_case to dim_queue
   - fact_fraud_case to dim_status
   - fact_fraud_case to dim_channel
   - fact_fraud_case to dim_risk_band
7. Add DAX measures from `powerbi_measure_guide.md`.
8. Build four report pages based on `dashboard_wireframe.md`.
9. Test filters, totals, and SLA calculations.
10. Export screenshots and publish the repo.

## Practical tip
Keep the report layout simple and business-facing. The strongest portfolio projects are usually the ones that are easy to read, easy to refresh, and easy to explain in an interview.
