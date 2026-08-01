# Entity Relationship Diagram — Version 1

```mermaid
erDiagram

    BENEFICIARY_SUMMARY {
        TEXT beneficiary_id PK
        INTEGER summary_year PK
        DATE birth_date
        DATE death_date
        INTEGER sex_code
        INTEGER race_code
        TEXT state_code
        INTEGER diabetes_indicator
        INTEGER heart_failure_indicator
        NUMERIC inpatient_medicare_reimbursement
        NUMERIC outpatient_medicare_reimbursement
    }

    INPATIENT_CLAIMS {
        TEXT claim_id PK
        INTEGER segment PK
        TEXT beneficiary_id
        DATE claim_from_date
        DATE claim_through_date
        DATE admission_date
        DATE discharge_date
        TEXT provider_number
        NUMERIC claim_payment_amount
        INTEGER utilization_day_count
        TEXT drg_code
        TEXT diagnosis_code_1
    }

    BENEFICIARY_SUMMARY ||--o{ INPATIENT_CLAIMS : "beneficiary_id + year"
