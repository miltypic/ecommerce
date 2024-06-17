{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_custom_events') }}

{{ timeliness_check('PROD.EVENTS.FACT_CUSTOM_EVENTS', 'DATETIME') }}