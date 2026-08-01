/*
Query 1

Business Question:
Which chronic conditions are most common in the dataset?

Purpose:
The CMS chronic-condition fields use 1 for yes and 2 for no.
This query counts beneficiary-year records marked with each condition.
*/

SELECT
    'Diabetes' AS condition,
    COUNT(*) FILTER (WHERE diabetes_indicator = 1) AS condition_count,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE diabetes_indicator = 1)
        / COUNT(*),
        1
    ) AS prevalence_percentage
FROM beneficiary_summary

UNION ALL

SELECT
    'Ischemic Heart Disease',
    COUNT(*) FILTER (WHERE ischemic_heart_disease_indicator = 1),
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE ischemic_heart_disease_indicator = 1
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
