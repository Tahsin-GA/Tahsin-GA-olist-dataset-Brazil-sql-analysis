-- =====================================================
-- DDL AND DML AWARENESS — OLIST CAMPAIGN EXAMPLE
-- =====================================================
-- DDL (Data Definition Language): changes database STRUCTURE
-- DML (Data Manipulation Language): changes data INSIDE tables
-- =====================================================

-- DDL: CREATE TABLE
-- Builds a new empty table with defined columns and data types
-- TEXT = string values, REAL = decimal numbers
CREATE TABLE olist_campaigns_dataset (
    campaign_id TEXT,
    campaign_name TEXT,
    campaign_budget REAL,
    start_date TEXT
);

-- DML: INSERT INTO
-- Adds a new row of data into an existing table
-- Column order in VALUES must match column order declared above
INSERT INTO olist_campaigns_dataset
(campaign_id, campaign_name, campaign_budget, start_date)
VALUES
('C001', 'Black Friday Campaign', 50000.00, '2017-11-01');

-- Verify the insert worked
SELECT * FROM olist_campaigns_dataset;

-- DML: UPDATE
-- Modifies existing row values
-- CRITICAL: always use WHERE — without it, ALL rows get updated
UPDATE olist_campaigns_dataset
SET campaign_budget = 75000.00
WHERE campaign_id = 'C001';

-- Verify the update worked
SELECT * FROM olist_campaigns_dataset;

-- DML: DELETE
-- Removes specific rows from a table
-- CRITICAL: always use WHERE — without it, ALL rows get deleted
DELETE FROM olist_campaigns_dataset
WHERE campaign_id = 'C001';

-- DDL: DROP TABLE
-- Permanently deletes the entire table and all its data
-- No undo — use with extreme caution in real databases
DROP TABLE olist_campaigns_dataset;