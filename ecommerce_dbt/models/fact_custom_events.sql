{{
  config(
    materialized='incremental',
    incremental_strategy="append",
    database='prod',
    schema='events',
    unique_key='customeventid',
    post_hook="TRUNCATE STAGING.EVENTS.STAGING_CLEAN_CUSTOM_EVENTS"

)
}}

    SELECT
        *
    FROM {{ ref('staging_clean_custom_events') }}
