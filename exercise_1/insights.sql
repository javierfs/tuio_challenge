-- Query to analyze the impact of claim status on annual premium for customers signed up in the last 6 months
WITH claim_status_analysis AS (
    SELECT
        ca.claim_status,  -- Claim status (e.g., Approved, Pending, Denied)
        AVG(p.annual_premium) AS avg_annual_premium  -- Average annual premium per claim status
    FROM
        `tuio-challenge.insurance_pricing.customers` c  -- Start with customers table
    JOIN 
        `tuio-challenge.insurance_pricing.insurance_policies` p  -- INNER JOIN with insurance_policies
    ON 
        c.customer_id = p.customer_id  -- Match customer_id to policies
    JOIN 
        `tuio-challenge.insurance_pricing.claims_history` ca  -- INNER JOIN with claims_history
    ON 
        p.policy_id = ca.policy_id  -- Match policy_id for claims
    WHERE
        c.signup_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)  -- Filter customers signed up in the last 6 months
    GROUP BY
        ca.claim_status
)
SELECT
    claim_status,
    avg_annual_premium
FROM 
    claim_status_analysis
ORDER BY
    avg_annual_premium DESC;