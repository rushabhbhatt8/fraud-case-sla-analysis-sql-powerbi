-- Seed data for fraud operations dashboard

INSERT INTO dbo.dim_agent (agent_name, team_name, location, active_flag) VALUES
('Ava Patel','Fraud Ops A','Toronto',1),
('Liam Chen','Fraud Ops A','Toronto',1),
('Noah Singh','Fraud Ops A','Waterloo',1),
('Emma Brown','Fraud Ops B','Toronto',1),
('Sophia Khan','Fraud Ops B','Mississauga',1),
('Oliver Wright','Fraud Ops B','Toronto',1),
('Mia Johnson','Fraud Ops C','Waterloo',1),
('Ethan Lopez','Fraud Ops C','Toronto',1),
('Isabella Turner','Fraud Ops C','Toronto',1),
('Lucas Green','Fraud Ops C','Waterloo',1);

INSERT INTO dbo.dim_queue (queue_name, priority_level, sla_target_hours) VALUES
('High Priority Alerts','Critical',4),
('Standard Review','Medium',24),
('KYC Escalations','High',8),
('Chargeback Investigations','High',12);

INSERT INTO dbo.dim_status (status_name) VALUES
('Open'),('In Progress'),('Escalated'),('Closed'),('Reopened');

INSERT INTO dbo.dim_channel (channel_name) VALUES
('Web'),('Mobile App'),('Call Center'),('Internal Referral');

INSERT INTO dbo.dim_risk_band (risk_band, risk_score_min, risk_score_max) VALUES
('Low',0,39),
('Medium',40,69),
('High',70,89),
('Critical',90,100);

-- Load fact_fraud_case from CSV in your preferred import tool, or use the values below as a reference.
