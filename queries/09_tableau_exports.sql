/*
Tableau Export Queries

Purpose:
Create small summary CSV files for the Tableau dashboard.
*/

\pset format csv


-- 1. Annual claims and payment summary.

\o outputs/tableau_exports/annual_summary.csv

WITH inpatient_yearly AS (
    SELECT
        EXTRACT(YEAR FROM admission_date)::INTEGER AS claim_year,
        COUNT(*) AS inpatient_claims,
        ROUND(AVG(claim_payment_amount), 2) AS avg_inpatient_payment,
        ROUND(SUM(claim_payment_amount), 2) AS total_inpatient_payments,
        ROUND(AVG(utilization_day_count), 2) AS avg_length_of_stay
    FROM inpatient_claims
    WHERE admission_date >= DATE '2008-01-01'
      AND admission_date < DATE '2011-01-01'
    GROUP BY EXTRACT(YEAR FROM admission_date)
),

outpatient_yearly AS (
    SELECT
        EXTRACT(YEAR FROM claim_from_date)::INTEGER AS claim_year,
        COUNT(*) AS outpatient_claims,
        ROUND(AVG(claim_payment_amount), 2) AS avg_outpatient_payment,
        ROUND(SUM(claim_payment_amount), 2) AS total_outpatient_payments
    FROM outpatient_claims
    WHERE claim_from_date >= DATE '2008-01-01'
      AND claim_from_date < DATE '2011-01-01'
    GROUP BY EXTRACT(YEAR FROM claim_from_date)
)

SELECT
    i.claim_year,
    i.inpatient_claims,
    o.outpatient_claims,
    i.avg_inpatient_payment,
    o.avg_outpatient_payment,
    i.total_inpatient_payments,
    o.total_outpatient_payments,
    i.avg_length_of_stay
FROM inpatient_yearly i
INNER JOIN outpatient_yearly o
    ON i.claim_year = o.claim_year
ORDER BY i.claim_year;

\o


-- 2. Chronic-condition prevalence.

\o outputs/tableau_exports/chronic_conditions.csv

SELECT
    'Ischemic Heart Disease' AS condition,
    COUNT(*) FILTER (
        WHERE ischemic_heart_disease_indicator = 1
    ) AS condition_count,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE ischemic_heart_disease_indicator = 1
        ) / COUNT(*),
        1
    ) AS prevalence_percentage
FROM beneficiary_summary

UNION ALL

SELECT
    'Diabetes',
    COUNT(*) FILTER (WHERE diabetes_indicator = 1),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE diabetes_indicator = 1
        ) / COUNT(*),
        1
    )
FROM beneficiary_summary

UNION ALL

SELECT
    'Heart Failure',
    COUNT(*) FILTER (WHERE heart_failure_indicator = 1),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE heart_failure_indicator = 1
        ) / COUNT(*),
        1
    )
FROM beneficiary_summary

UNION ALL

SELECT
    'Depression',
    COUNT(*) FILTER (WHERE depression_indicator = 1),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE depression_indicator = 1
        ) / COUNT(*),
        1
    )
FROM beneficiary_summary

UNION ALL

SELECT
    'Chronic Kidney Disease',
    COUNT(*) FILTER (
        WHERE chronic_kidney_disease_indicator = 1
    ),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE chronic_kidney_disease_indicator = 1
        ) / COUNT(*),
        1
    )
FROM beneficiary_summary

UNION ALL

SELECT
    'COPD',
    COUNT(*) FILTER (WHERE copd_indicator = 1),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE copd_indicator = 1
        ) / COUNT(*),
        1
    )
FROM beneficiary_summary

ORDER BY prevalence_percentage DESC;

\o


-- 3. Inpatient age-group summary.

\o outputs/tableau_exports/inpatient_age_groups.csv

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
        AVG(i.utilization_day_count),
        2
    ) AS average_length_of_stay,

    ROUND(
        AVG(i.claim_payment_amount),
        2
    ) AS average_claim_payment

FROM inpatient_claims i

INNER JOIN beneficiary_summary b
    ON i.beneficiary_id = b.beneficiary_id
    AND EXTRACT(YEAR FROM i.admission_date) = b.summary_year

GROUP BY age_group
ORDER BY inpatient_claims DESC;

\o


-- 4. Outpatient age-group summary.

\o outputs/tableau_exports/outpatient_age_groups.csv

SELECT
    CASE
        WHEN EXTRACT(
            YEAR FROM AGE(o.claim_from_date, b.birth_date)
        ) < 65 THEN 'Under 65'

        WHEN EXTRACT(
            YEAR FROM AGE(o.claim_from_date, b.birth_date)
        ) BETWEEN 65 AND 74 THEN '65-74'

        WHEN EXTRACT(
            YEAR FROM AGE(o.claim_from_date, b.birth_date)
        ) BETWEEN 75 AND 84 THEN '75-84'

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

\o

-- 5. Year-over-year outpatient claim change.

\o outputs/tableau_exports/year_over_year_claims.csv

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
    ) AS percent_change

FROM yearly_change
ORDER BY claim_year;

\o
