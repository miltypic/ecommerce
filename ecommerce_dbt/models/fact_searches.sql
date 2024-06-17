{{
  config(
    materialized='incremental',
    incremental_strategy="append",
    database='prod',
    schema='events',
    unique_key='SEARCHID || DATETIME',
    post_hook=["TRUNCATE STAGING.EVENTS.STAGING_CLEAN_SEARCHES"]

)
}}

    SELECT
        *
    FROM {{ ref('staging_clean_searches') }}
