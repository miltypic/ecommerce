{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_clicks') }}

{{ timeliness_check('PROD.EVENTS.FACT_CLICKS', 'INSERTION_DATETIME') }}