{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_clicks') }}

{{ duplicate_detection('PROD.EVENTS.FACT_CLICKS', ['CLICKID']) }}