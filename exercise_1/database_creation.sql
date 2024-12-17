-- Create the 'customers' table to store customer information
CREATE OR REPLACE TABLE `tuio-challenge.insurance_pricing.customers` (
    customer_id INT64,
    age INT64,
    gender STRING,
    latitude FLOAT64,
    longitude FLOAT64,
    cancellation_history BOOL,
    email STRING,                    -- New field: Email address
    signup_date DATE,                -- New field: Signup date
    premium STRING                   -- New field: Premium type (e.g., "Premium" or "Standard")
);

-- Create the 'insurance_policies' table to store insurance policy information
CREATE OR REPLACE TABLE `tuio-challenge.insurance_pricing.insurance_policies` (
    policy_id INT64,
    customer_id INT64,
    insurance_type STRING,
    annual_premium NUMERIC,
    start_date DATE,
    policy_status STRING,           -- New field: Policy status (e.g., "Active", "Expired")
    coverage_amount NUMERIC,        -- New field: Coverage amount for the policy
    payment_frequency STRING        -- New field: Payment frequency (e.g., "Monthly", "Annually")
    -- Note: No foreign key constraint in BigQuery
);

-- Create the 'claims_history' table to store claims made by customers, now with policy_id
CREATE OR REPLACE TABLE `tuio-challenge.insurance_pricing.claims_history` (
    claim_id INT64,
    customer_id INT64,
    policy_id INT64,               -- New field: Policy ID to link claims to specific policies
    claim_date DATE,
    claim_amount NUMERIC,
    incident_type STRING,          -- Type of incident (e.g., "Accident", "Theft")
    claim_status STRING,           -- Claim status (e.g., "Pending", "Approved", "Denied")
    claim_type STRING,             -- Type of claim (e.g., "Property", "Medical")
    claim_resolution_date DATE     -- Date when the claim was resolved
    -- Note: No foreign key constraint in BigQuery
);
