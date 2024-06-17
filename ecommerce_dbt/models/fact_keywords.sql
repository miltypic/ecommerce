{{
  config(
    materialized='incremental',
    incremental_strategy="append",
    database='prod',
    schema='events',
    post_hook ="TRUNCATE STAGING.EVENTS.STAGING_CLEAN_KEYWORDS"

)
}}

    SELECT
        *
    FROM {{ ref('staging_clean_keywords') }}
    WHERE SEARCHID || DATETIME || KEYWORD NOT IN (SELECT SEARCHID || DATETIME || KEYWORD FROM PROD.EVENTS.FACT_KEYWORDS)
