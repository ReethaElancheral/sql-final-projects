-- 46. Multi-Tenant SaaS Database 
-- Objective: Handle multiple clients (tenants) on same schema. 
-- Entities: 
-- • Tenants 
-- • Users 
-- • Data 
-- SQL Skills: 
-- • Tenant isolation by foreign key 
-- • Query partitioning 
-- Tables: 
-- • tenants (id, name) 
-- • users (id, name, tenant_id) 
-- • data (id, tenant_id, content)

CREATE DATABASE multi_tenant_saas;
USE multi_tenant_saas;

CREATE TABLE tenants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    tenant_id INT,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
);

CREATE TABLE data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tenant_id INT,
    content TEXT NOT NULL,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE
);

INSERT INTO tenants (name) VALUES
('Acme Corp'), ('Beta Solutions'), ('CloudWave');

INSERT INTO users (name, tenant_id) VALUES
('John Doe', 1), ('Jane Smith', 1),
('Mark Taylor', 2), ('Emily Davis', 3);

INSERT INTO data (tenant_id, content) VALUES
(1, 'Acme sales report Q3'),
(2, 'Beta Solutions user analytics'),
(3, 'CloudWave marketing materials');

-- Query: Get all data for a specific tenant (tenant_id = 1)
SELECT * FROM data WHERE tenant_id = 1;