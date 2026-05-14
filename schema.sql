-- Fraud Operations SLA Tracking Schema
-- SQL Server style

IF OBJECT_ID('dbo.fact_fraud_case', 'U') IS NOT NULL DROP TABLE dbo.fact_fraud_case;
IF OBJECT_ID('dbo.fact_daily_workload', 'U') IS NOT NULL DROP TABLE dbo.fact_daily_workload;
IF OBJECT_ID('dbo.dim_agent', 'U') IS NOT NULL DROP TABLE dbo.dim_agent;
IF OBJECT_ID('dbo.dim_queue', 'U') IS NOT NULL DROP TABLE dbo.dim_queue;
IF OBJECT_ID('dbo.dim_status', 'U') IS NOT NULL DROP TABLE dbo.dim_status;
IF OBJECT_ID('dbo.dim_channel', 'U') IS NOT NULL DROP TABLE dbo.dim_channel;
IF OBJECT_ID('dbo.dim_risk_band', 'U') IS NOT NULL DROP TABLE dbo.dim_risk_band;

CREATE TABLE dbo.dim_agent (
    agent_id INT IDENTITY(1,1) PRIMARY KEY,
    agent_name VARCHAR(100) NOT NULL,
    team_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    active_flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.dim_queue (
    queue_id INT IDENTITY(1,1) PRIMARY KEY,
    queue_name VARCHAR(100) NOT NULL,
    priority_level VARCHAR(20) NOT NULL,
    sla_target_hours DECIMAL(5,2) NOT NULL
);

CREATE TABLE dbo.dim_status (
    status_id INT IDENTITY(1,1) PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.dim_channel (
    channel_id INT IDENTITY(1,1) PRIMARY KEY,
    channel_name VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.dim_risk_band (
    risk_band_id INT IDENTITY(1,1) PRIMARY KEY,
    risk_band VARCHAR(20) NOT NULL,
    risk_score_min INT NOT NULL,
    risk_score_max INT NOT NULL
);

CREATE TABLE dbo.fact_fraud_case (
    case_id INT IDENTITY(1,1) PRIMARY KEY,
    case_number VARCHAR(30) NOT NULL UNIQUE,
    created_date DATE NOT NULL,
    closed_date DATE NULL,
    agent_id INT NOT NULL,
    queue_id INT NOT NULL,
    status_id INT NOT NULL,
    channel_id INT NOT NULL,
    risk_band_id INT NOT NULL,
    case_amount DECIMAL(12,2) NOT NULL,
    risk_score INT NOT NULL,
    sla_due_date DATE NOT NULL,
    sla_met_flag BIT NOT NULL DEFAULT 0,
    escalation_flag BIT NOT NULL DEFAULT 0,
    reopened_flag BIT NOT NULL DEFAULT 0,
    suspicious_flag BIT NOT NULL DEFAULT 0,
    resolution_minutes INT NULL,
    CONSTRAINT FK_fact_case_agent FOREIGN KEY (agent_id) REFERENCES dbo.dim_agent(agent_id),
    CONSTRAINT FK_fact_case_queue FOREIGN KEY (queue_id) REFERENCES dbo.dim_queue(queue_id),
    CONSTRAINT FK_fact_case_status FOREIGN KEY (status_id) REFERENCES dbo.dim_status(status_id),
    CONSTRAINT FK_fact_case_channel FOREIGN KEY (channel_id) REFERENCES dbo.dim_channel(channel_id),
    CONSTRAINT FK_fact_case_risk FOREIGN KEY (risk_band_id) REFERENCES dbo.dim_risk_band(risk_band_id)
);

CREATE TABLE dbo.fact_daily_workload (
    work_date DATE NOT NULL,
    agent_id INT NOT NULL,
    queue_id INT NOT NULL,
    cases_opened INT NOT NULL DEFAULT 0,
    cases_closed INT NOT NULL DEFAULT 0,
    breaches INT NOT NULL DEFAULT 0,
    avg_resolution_minutes INT NULL,
    CONSTRAINT PK_fact_daily_workload PRIMARY KEY (work_date, agent_id, queue_id),
    CONSTRAINT FK_workload_agent FOREIGN KEY (agent_id) REFERENCES dbo.dim_agent(agent_id),
    CONSTRAINT FK_workload_queue FOREIGN KEY (queue_id) REFERENCES dbo.dim_queue(queue_id)
);
