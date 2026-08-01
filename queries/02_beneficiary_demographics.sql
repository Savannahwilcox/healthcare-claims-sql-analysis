-- Beneficiary Demographics

-- Business Question:
-- What is the average age of beneficiaries by year?

SELECT
    summary_year,

    ROUND(
        AVG(
            EXTRACT(YEAR FROM AGE(
                MAKE_DATE(summary_year,12,31),
                birth_date
            ))
        ),
        1
    ) AS average_age

FROM beneficiary_summary

GROUP BY summary_year

ORDER BY summary_year;

/*
Business Question

Question:
What is the distribution of beneficiaries by age group?

Purpose:
Grouping beneficiaries into age ranges provides a clearer
picture of the Medicare population than listing every
individual age.
*/

SELECT
    CASE
        WHEN EXTRACT(YEAR FROM AGE(MAKE_DATE(summary_year,12,31), birth_date)) < 65
            THEN 'Under 65'

        WHEN EXTRACT(YEAR FROM AGE(MAKE_DATE(summary_year,12,31), birth_date))
             BETWEEN 65 AND 74
            THEN '65-74'

        WHEN EXTRACT(YEAR FROM AGE(MAKE_DATE(summary_year,12,31), birth_date))
             BETWEEN 75 AND 84
            THEN '75-84'

        ELSE '85+'
    END AS age_group,

    COUNT(*) AS beneficiary_count

FROM beneficiary_summary

GROUP BY age_group

ORDER BY beneficiary_count DESC;

/*
Query 3

Business Question:
How are beneficiary records distributed by sex?

Purpose:
The source data uses numeric codes, so CASE is used to create
readable labels for the analysis.
*/

SELECT
    CASE
        WHEN sex_code = 1 THEN 'Male'
        WHEN sex_code = 2 THEN 'Female'
        ELSE 'Unknown'
    END AS sex,

    COUNT(*) AS beneficiary_count,

    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        1
    ) AS percentage

FROM beneficiary_summary

GROUP BY sex_code

ORDER BY beneficiary_count DESC;

/*
Query 4

Business Question:
How are beneficiary records distributed by race category?

Purpose:
Readable category labels make the CMS race codes easier to
interpret in later demographic and reimbursement analyses.
*/

SELECT
    CASE
        WHEN race_code = 1 THEN 'White'
        WHEN race_code = 2 THEN 'Black'
        WHEN race_code = 3 THEN 'Other'
        WHEN race_code = 5 THEN 'Hispanic'
        ELSE 'Unknown'
    END AS race,

    COUNT(*) AS beneficiary_count,

    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        1
    ) AS percentage

FROM beneficiary_summary

GROUP BY race_code

ORDER BY beneficiary_count DESC;
