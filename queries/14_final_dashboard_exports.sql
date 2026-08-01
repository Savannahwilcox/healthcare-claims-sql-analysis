/*
Final Dashboard Export Queries

Purpose:
Create the summary CSV files used in the final Tableau dashboard.
*/

\pset format csv


-- 1. KPI summary.

\o outputs/tableau_exports/kpi_summary.csv

SELECT
    COUNT(DISTINCT beneficiary_id) AS unique_beneficiaries,

    (
        SELECT COUNT(*)
        FROM inpatient_claims
        WHERE admission_date >= DATE '2008-01-01'
          AND admission_date < DATE '2011-01-01'
    ) AS inpatient_claims,

    (
        SELECT COUNT(*)
        FROM outpatient_claims
        WHERE claim_from_date >= DATE '2008-01-01'
          AND claim_from_date < DATE '2011-01-01'
    ) AS outpatient_claims,

    (
        SELECT ROUND(
            SUM(claim_payment_amount),
            2
        )
        FROM inpatient_claims
        WHERE admission_date >= DATE '2008-01-01'
          AND admission_date < DATE '2011-01-01'
    )
    +
    (
        SELECT ROUND(
            SUM(claim_payment_amount),
            2
        )
        FROM outpatient_claims
        WHERE claim_from_date >= DATE '2008-01-01'
          AND claim_from_date < DATE '2011-01-01'
    ) AS total_medicare_payments,

    (
        SELECT ROUND(
            AVG(utilization_day_count),
            2
        )
        FROM inpatient_claims
        WHERE admission_date >= DATE '2008-01-01'
          AND admission_date < DATE '2011-01-01'
    ) AS average_length_of_stay

FROM beneficiary_summary;

\o


-- 2. Top diagnoses by total inpatient spending.

\o outputs/tableau_exports/top_diagnoses_by_spending.csv

SELECT
    diagnosis_code_1 AS diagnosis_code,
    COUNT(*) AS claim_count,
    ROUND(
        SUM(claim_payment_amount),
        2
    ) AS total_medicare_payment,
    ROUND(
        AVG(claim_payment_amount),
        2
    ) AS average_claim_payment
FROM inpatient_claims
WHERE diagnosis_code_1 IS NOT NULL
  AND diagnosis_code_1 <> ''
GROUP BY diagnosis_code_1
ORDER BY total_medicare_payment DESC
LIMIT 10;

\o


-- 3. Top providers by total inpatient spending.

\o outputs/tableau_exports/top_providers_by_spending.csv

SELECT
    provider_number,
    COUNT(*) AS inpatient_claims,
    ROUND(
        SUM(claim_payment_amount),
        2
    ) AS total_medicare_payment,
    ROUND(
        AVG(claim_payment_amount),
        2
    ) AS average_claim_payment
FROM inpatient_claims
WHERE provider_number IS NOT NULL
  AND provider_number <> ''
GROUP BY provider_number
ORDER BY total_medicare_payment DESC
LIMIT 10;

\o


-- 4. Chronic-condition resource utilization.

\o outputs/tableau_exports/chronic_condition_utilization.csv

SELECT
    'Chronic Kidney Disease' AS condition,
    COUNT(*) AS inpatient_claims,
    ROUND(AVG(i.utilization_day_count), 2)
        AS average_length_of_stay,
    ROUND(AVG(i.claim_payment_amount), 2)
        AS average_claim_payment
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.chronic_kidney_disease_indicator = 1

UNION ALL

SELECT
    'COPD',
    COUNT(*),
    ROUND(AVG(i.utilization_day_count), 2),
    ROUND(AVG(i.claim_payment_amount), 2)
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.copd_indicator = 1

UNION ALL

SELECT
    'Depression',
    COUNT(*),
    ROUND(AVG(i.utilization_day_count), 2),
    ROUND(AVG(i.claim_payment_amount), 2)
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.depression_indicator = 1

UNION ALL

SELECT
    'Heart Failure',
    COUNT(*),
    ROUND(AVG(i.utilization_day_count), 2),
    ROUND(AVG(i.claim_payment_amount), 2)
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.heart_failure_indicator = 1

UNION ALL

SELECT
    'Diabetes',
    COUNT(*),
    ROUND(AVG(i.utilization_day_count), 2),
    ROUND(AVG(i.claim_payment_amount), 2)
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.diabetes_indicator = 1

UNION ALL

SELECT
    'Ischemic Heart Disease',
    COUNT(*),
    ROUND(AVG(i.utilization_day_count), 2),
    ROUND(AVG(i.claim_payment_amount), 2)
FROM inpatient_claims i
INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year
WHERE b.ischemic_heart_disease_indicator = 1

ORDER BY average_claim_payment DESC;

\o


-- 5. Age-group inpatient spending.

\o outputs/tableau_exports/age_group_spending.csv

SELECT
    CASE
        WHEN EXTRACT(
            YEAR FROM AGE(i.admission_date, b.birth_date)
        ) < 65 THEN 'Under 65'

        WHEN EXTRACT(
            YEAR FROM AGE(i.admission_date, b.birth_date)
        ) BETWEEN 65 AND 74 THEN '65-74'

        WHEN EXTRACT(
            YEAR FROM AGE(i.admission_date, b.birth_date)
        ) BETWEEN 75 AND 84 THEN '75-84'

        ELSE '85+'
    END AS age_group,

    COUNT(*) AS inpatient_claims,

    ROUND(
        SUM(i.claim_payment_amount),
        2
    ) AS total_medicare_payment,

    ROUND(
        AVG(i.claim_payment_amount),
        2
    ) AS average_claim_payment

FROM inpatient_claims i

INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year

GROUP BY age_group
ORDER BY total_medicare_payment DESC;

\o
