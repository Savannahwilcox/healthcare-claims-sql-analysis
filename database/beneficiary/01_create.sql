-- Medicare Claims Utilization and Payment Analysis
-- File: 01_create_tables.sql
-- Purpose: Create a raw staging table for CMS beneficiary data.

DROP TABLE IF EXISTS raw_beneficiary_summary;

CREATE TABLE raw_beneficiary_summary (
    desynpuf_id TEXT,
    bene_birth_dt TEXT,
    bene_death_dt TEXT,
    bene_sex_ident_cd TEXT,
    bene_race_cd TEXT,
    bene_esrd_ind TEXT,
    sp_state_code TEXT,
    bene_county_cd TEXT,
    bene_hi_cvrage_tot_mons TEXT,
    bene_smi_cvrage_tot_mons TEXT,
    bene_hmo_cvrage_tot_mons TEXT,
    plan_cvrg_mos_num TEXT,
    sp_alzhdmta TEXT,
    sp_chf TEXT,
    sp_chrnkidn TEXT,
    sp_cncr TEXT,
    sp_copd TEXT,
    sp_depressn TEXT,
    sp_diabetes TEXT,
    sp_ischmcht TEXT,
    sp_osteoprs TEXT,
    sp_ra_oa TEXT,
    sp_strketia TEXT,
    medreimb_ip TEXT,
    benres_ip TEXT,
    pppymt_ip TEXT,
    medreimb_op TEXT,
    benres_op TEXT,
    pppymt_op TEXT,
    medreimb_car TEXT,
    benres_car TEXT,
    pppymt_car TEXT,
    summary_year INTEGER
);
