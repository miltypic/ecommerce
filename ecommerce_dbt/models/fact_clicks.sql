{{
  config(
    materialized='incremental',
    incremental_strategy="append",
    database='prod',
    schema='events',
    unique_key = 'clickid',
    post_hook ="TRUNCATE STAGING.EVENTS.STAGING_CLEAN_CLICKS"

)
}}

    SELECT
        *
    FROM {{ ref('staging_clean_clicks') }}
