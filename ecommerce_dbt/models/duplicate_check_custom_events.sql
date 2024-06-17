{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_custom_events') }}

{{ duplicate_detection('PROD.EVENTS.FACT_CUSTOM_EVENTS', ['CUSTOMEVENTID']) }}