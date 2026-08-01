/*
Outpatient Join Analysis

Business Questions:
1. How does outpatient utilization differ by age group?
2. How do outpatient payments differ by diabetes status?
3. How many outpatient claims do not match a beneficiary-year record?
*/

-- 1. Outpatient utilization by age group.

SELECT
    CASE
        WHEN EXTRACT(YEAR FROM AGE(o.claim_from_date, b.birth_date)) < 65
            THEN 'Under 65'
        WHEN EXTRACT(YEAR FROM AGE(o.claim_from_date, b.birth_date))
             BETWEEN 65 AND 74
            THEN '65-74'
        WHEN EXTRACT(YEAR FROM AGE(o.claim_from_date, b.birth_date))
             BETWEEN 75 AND 84
            THEN '75-84'
        ELSE '85+'
    END AS age_group,

    COUNT(*) AS outpatient_claims,

    ROUND(
        AVG(o.claim_payment_amount),
        2
    ) AS average_claim_payment,

    ROUND(
        SUM(o.claim_payment_amount),
        2
    ) AS total_claim_payments

FROM outpatient_claims o

INNER JOIN beneficiary_summary b
    ON o.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM o.claim_from_date) = b.summary_year

WHERE o.claim_from_date IS NOT NULL

GROUP BY age_group

ORDER BY outpatient_claims DESC;


-- 2. Outpatient utilization by diabetes status.

SELECT
    CASE
        WHEN b.diabetes_indicator = 1 THEN 'Diabetes'
        WHEN b.diabetes_indicator = 2 THEN 'No Diabetes'
        ELSE 'Unknown'
    END AS diabetes_status,

    COUNT(*) AS outpatient_claims,

    ROUND(
        AVG(o.claim_payment_amount),
        2
    ) AS average_claim_payment,

    ROUND(
        SUM(o.claim_payment_amount),
        2
    ) AS total_claim_payments

FROM outpatient_claims o

INNER JOIN beneficiary_summary b
    ON o.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM o.claim_from_date) = b.summary_year

WHERE o.claim_from_date IS NOT NULL

GROUP BY b.diabetes_indicator

ORDER BY outpatient_claims DESC;


-- 3. Validate unmatched outpatient claims.

SELECT
    COUNT(*) AS unmatched_outpatient_claims
FROM outpatient_claims o

LEFT JOIN beneficiary_summary b
    ON o.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM o.claim_from_date) = b.summary_year

WHERE b.beneficiary_id IS NULL;
