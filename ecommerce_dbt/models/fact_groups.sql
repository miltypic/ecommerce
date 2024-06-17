{{
  config(
    materialized='incremental',
    incremental_strategy="append",
    database='prod',
    schema='events',
    post_hook ="TRUNCATE STAGING.EVENTS.STAGING_CLEAN_GROUPS"

)
}}

    SELECT
        *
    FROM {{ ref('staging_clean_groups') }}
    WHERE SEARCHID || DATETIME NOT IN (SELECT SEARCHID || DATETIME FROM PROD.EVENTS.FACT_GROUPS)
