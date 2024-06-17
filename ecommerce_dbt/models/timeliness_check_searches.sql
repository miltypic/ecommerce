{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_searches') }}

{{ timeliness_check('PROD.EVENTS.FACT_SEARCHES', 'INSERTION_DATETIME') }}