/*
Advanced SQL Analysis

Business Questions:
1. How do inpatient and outpatient claim volumes compare by year?
2. Which inpatient providers rank highest by claim volume?
3. How did outpatient claim volume change from the previous year?
*/

-- 1. Compare inpatient and outpatient claims using CTEs.

WITH inpatient_yearly AS (
    SELECT
        EXTRACT(YEAR FROM admission_date)::INTEGER AS claim_year,
        COUNT(*) AS inpatient_claims,
        SUM(claim_payment_amount) AS inpatient_payments
    FROM inpatient_claims
    WHERE admission_date >= DATE '2008-01-01'
      AND admission_date < DATE '2011-01-01'
    GROUP BY EXTRACT(YEAR FROM admission_date)
),

outpatient_yearly AS (
    SELECT
        EXTRACT(YEAR FROM claim_from_date)::INTEGER AS claim_year,
        COUNT(*) AS outpatient_claims,
        SUM(claim_payment_amount) AS outpatient_payments
    FROM outpatient_claims
    WHERE claim_from_date >= DATE '2008-01-01'
      AND claim_from_date < DATE '2011-01-01'
    GROUP BY EXTRACT(YEAR FROM claim_from_date)
)

SELECT
    i.claim_year,
    i.inpatient_claims,
    o.outpatient_claims,
    ROUND(i.inpatient_payments, 2) AS inpatient_payments,
    ROUND(o.outpatient_payments, 2) AS outpatient_payments
FROM inpatient_yearly i
INNER JOIN outpatient_yearly o
    ON i.claim_year = o.claim_year
ORDER BY i.claim_year;


-- 2. Rank inpatient providers by claim volume.

WITH provider_claims AS (
    SELECT
        provider_number,
        COUNT(*) AS claim_count,
        SUM(claim_payment_amount) AS total_payments
    FROM inpatient_claims
    WHERE provider_number IS NOT NULL
      AND provider_number <> ''
    GROUP BY provider_number
)

SELECT
    provider_number,
    claim_count,
    ROUND(total_payments, 2) AS total_payments,
    RANK() OVER (
        ORDER BY claim_count DESC
    ) AS claim_volume_rank
FROM provider_claims
ORDER BY claim_volume_rank
LIMIT 10;


-- 3. Calculate year-over-year outpatient claim-volume change.

WITH yearly_claims AS (
    SELECT
        EXTRACT(YEAR FROM claim_from_date)::INTEGER AS claim_year,
        COUNT(*) AS claim_count
    FROM outpatient_claims
    WHERE claim_from_date >= DATE '2008-01-01'
      AND claim_from_date < DATE '2011-01-01'
    GROUP BY EXTRACT(YEAR FROM claim_from_date)
),

yearly_change AS (
    SELECT
        claim_year,
        claim_count,
        LAG(claim_count) OVER (
            ORDER BY claim_year
        ) AS prior_year_claim_count
    FROM yearly_claims
)

SELECT
    claim_year,
    claim_count,
    prior_year_claim_count,

    ROUND(
        100.0 * (
            claim_count - prior_year_claim_count
        ) / NULLIF(prior_year_claim_count, 0),
        1
    ) AS year_over_year_percentage_change

FROM yearly_change
ORDER BY claim_year;
