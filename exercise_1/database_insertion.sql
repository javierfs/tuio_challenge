-- Insert synthetic customer data into the 'customers' table
INSERT INTO `tuio-challenge.insurance_pricing.customers` (customer_id, age, gender, latitude, longitude, cancellation_history, email, signup_date, premium)
WITH synthetic_customers AS (
    SELECT
        -- Generate a random customer ID (INT64)
        CAST(FLOOR(RAND() * 1000) AS INT64) AS customer_id,
        
        -- Generate a random age using normal distribution approximation (Gaussian approximation)
        CAST(ROUND(40 + (RAND() * 20) - 10) AS INT64) AS age,  -- Mean=40, Std Dev=10
        
        -- Randomly assign gender (50% chance for male or female)
        IF(RAND() > 0.5, 'M', 'F') AS gender,
        
        -- Generate random latitude and longitude within the bounds of Spain
        -- Latitude between 36 and 43, Longitude between -9.5 and 3.5
        36 + (RAND() * 7) AS latitude,  -- Latitude between 36 and 43
        -9.5 + (RAND() * 13) AS longitude,  -- Longitude between -9.5 and 3.5
        
        -- Simulate cancellation history (50% chance of cancellation)
        RAND() > 0.5 AS cancellation_history,

        -- New fields
        CONCAT('user', CAST(FLOOR(RAND() * 10000) AS STRING), '@example.com') AS email,  -- Random email
        DATE_ADD(CURRENT_DATE(), INTERVAL CAST(FLOOR(RAND() * 365) AS INT64) DAY) AS signup_date,  -- Random signup date
        
        -- Assign 'premium' based on a 10% chance for "Premium" using Bernoulli distribution
        CASE WHEN RAND() < 0.1 THEN 'Premium'  -- 10% chance for Premium
            ELSE 'Standard'  -- 90% chance for Standard
       END AS premium

    FROM UNNEST(GENERATE_ARRAY(1, 100))  -- Generate 100 rows of synthetic data
)
SELECT * FROM synthetic_customers;

-- Insert synthetic insurance policy data into the 'insurance_policies' table (multiple policies per customer)
INSERT INTO `tuio-challenge.insurance_pricing.insurance_policies` (policy_id, customer_id, insurance_type, annual_premium, start_date, policy_status, coverage_amount, payment_frequency)
WITH synthetic_policies AS (
    SELECT
        -- Generate a random policy ID
        CAST(FLOOR(RAND() * 1000) AS INT64) AS policy_id,
        
        -- select a customer ID from the customers table
        customer_id,
        
        -- Randomly assign insurance type
        CASE
            WHEN RAND() < 0.33 THEN 'Car'
            WHEN RAND() < 0.66 THEN 'Health'
            ELSE 'Life'
        END AS insurance_type,
        
        -- Generate random annual premium with normal distribution
        CAST(ROUND(1200 + (RAND() * 600) - 300) AS NUMERIC) AS annual_premium,  -- Mean=1200, Std Dev=300
        
        -- Randomly assign a start date (within the last 2 years)
        DATE_ADD(CURRENT_DATE(), INTERVAL CAST(FLOOR(RAND() * 730) AS INT64) DAY) AS start_date,
        
        -- Adjusted 'policy_status' to make most policies 'Active'
        CASE
            WHEN RAND() < 0.8 THEN 'Active'  -- 80% chance for Active
            WHEN RAND() < 0.95 THEN 'Expired'  -- 15% chance for Expired
            ELSE 'Suspended'  -- 5% chance for Suspended
        END AS policy_status,  -- Random policy status
        
        CAST(ROUND(50000 + (RAND() * 100000)) AS NUMERIC) AS coverage_amount,  -- Random coverage amount
        
        CASE
            WHEN RAND() < 0.33 THEN 'Monthly'
            WHEN RAND() < 0.66 THEN 'Quarterly'
            ELSE 'Annually'
        END AS payment_frequency  -- Random payment frequency
    FROM 
        `tuio-challenge.insurance_pricing.customers`  -- Pull customer IDs from the customers table
    CROSS JOIN UNNEST(GENERATE_ARRAY(1, CAST(FLOOR(RAND() * 5) + 1 AS INT64))) AS policy_count  -- Assign 1-5 policies per customer
)
SELECT * FROM synthetic_policies;


-- Insert synthetic claims history data into the 'claims_history' table (multiple claims per policy)
INSERT INTO `tuio-challenge.insurance_pricing.claims_history` (claim_id, customer_id, policy_id, claim_date, claim_amount, incident_type, claim_status, claim_type, claim_resolution_date)
WITH synthetic_claims AS (
    SELECT
        -- Generate random claim ID
        CAST(FLOOR(RAND() * 1000) AS INT64) AS claim_id,
        
        -- Select customer_id from customers table
        c.customer_id,
        
        -- Select policy_id from insurance_policies table
        p.policy_id,
        
        -- Randomly assign a claim date (within the last year)
        DATE_ADD(CURRENT_DATE(), INTERVAL CAST(FLOOR(RAND() * 365) AS INT64) DAY) AS claim_date,
        
        -- Randomly assign claim amount with normal distribution
        CAST(ROUND(500 + (RAND() * 400) - 200) AS NUMERIC) AS claim_amount,  -- Mean=500, Std Dev=200
        
        -- Randomly assign incident type
        CASE
            WHEN RAND() < 0.33 THEN 'Accident'
            WHEN RAND() < 0.66 THEN 'Theft'
            ELSE 'Illness'
        END AS incident_type,
        
        -- Randomly assign claim status
        CASE
            WHEN RAND() < 0.33 THEN 'Pending'
            WHEN RAND() < 0.66 THEN 'Approved'
            ELSE 'Denied'
        END AS claim_status, 
        
        -- Randomly assign claim type
        CASE
            WHEN RAND() < 0.33 THEN 'Property'
            WHEN RAND() < 0.66 THEN 'Medical'
            ELSE 'Accident'
        END AS claim_type, 
        
        -- Randomly assign claim resolution date
        DATE_ADD(CURRENT_DATE(), INTERVAL CAST(FLOOR(RAND() * 365) AS INT64) DAY) AS claim_resolution_date
    FROM 
        `tuio-challenge.insurance_pricing.customers` c  -- Start with customers table
    LEFT JOIN 
        `tuio-challenge.insurance_pricing.insurance_policies` p  -- Join with insurance_policies
    ON 
        c.customer_id = p.customer_id  -- Match customer_id to policies
    
    CROSS JOIN UNNEST(GENERATE_ARRAY(1, CAST(FLOOR(RAND() * 5) + 1 AS INT64))) AS claim_count  -- Assign 1-5 claims per policy
)
SELECT * FROM synthetic_claims;
