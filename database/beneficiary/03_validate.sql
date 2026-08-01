-- Validate beneficiary data.

SELECT COUNT(*) AS total_raw_rows
FROM raw_beneficiary_summary;

SELECT
    summary_year,
    COUNT(*) AS row_count
FROM raw_beneficiary_summary
GROUP BY summary_year
ORDER BY summary_year;

SELECT COUNT(*) AS total_clean_rows
FROM beneficiary_summary;

SELECT
    summary_year,
    COUNT(*) AS row_count
FROM beneficiary_summary
GROUP BY summary_year
ORDER BY summary_year;
