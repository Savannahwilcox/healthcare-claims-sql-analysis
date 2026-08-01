/*
Dashboard Export Queries

Purpose:
Create summary CSV files for the final Tableau dashboard.
*/

\pset format csv


-- 1. Top inpatient diagnosis codes.

\o outputs/tableau_exports/top_inpatient_diagnoses.csv

SELECT
    diagnosis_code_1 AS diagnosis_code,
    COUNT(*) AS inpatient_claims,
    ROUND(
        SUM(claim_payment_amount),
        2
    ) AS total_claim_payments,
    ROUND(
        AVG(claim_payment_amount),
        2
    ) AS average_claim_payment
FROM inpatient_claims
WHERE diagnosis_code_1 IS NOT NULL
  AND diagnosis_code_1 <> ''
GROUP BY diagnosis_code_1
ORDER BY inpatient_claims DESC
LIMIT 10;

\o


-- 2. Top inpatient providers by claim volume.

\o outputs/tableau_exports/top_inpatient_providers.csv

SELECT
    provider_number,
    COUNT(*) AS inpatient_claims,
    ROUND(
        SUM(claim_payment_amount),
        2
    ) AS total_claim_payments,
    ROUND(
        AVG(claim_payment_amount),
        2
    ) AS average_claim_payment
FROM inpatient_claims
WHERE provider_number IS NOT NULL
  AND provider_number <> ''
GROUP BY provider_number
ORDER BY inpatient_claims DESC
LIMIT 10;

\o


-- 3. Diabetes and inpatient utilization summary.

\o outputs/tableau_exports/diabetes_inpatient_summary.csv

SELECT
    CASE
        WHEN b.diabetes_indicator = 1
            THEN 'Diabetes'
        WHEN b.diabetes_indicator = 2
            THEN 'No Diabetes'
        ELSE 'Unknown'
    END AS diabetes_status,

    COUNT(*) AS inpatient_claims,

    ROUND(
        AVG(i.utilization_day_count),
        2
    ) AS average_length_of_stay,

    ROUND(
        AVG(i.claim_payment_amount),
        2
    ) AS average_claim_payment,

    ROUND(
        SUM(i.claim_payment_amount),
        2
    ) AS total_claim_payments

FROM inpatient_claims i

INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year

GROUP BY b.diabetes_indicator

ORDER BY inpatient_claims DESC;

\o
