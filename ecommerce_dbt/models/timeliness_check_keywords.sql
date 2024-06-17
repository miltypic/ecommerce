{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_keywords') }}

{{ timeliness_check('PROD.EVENTS.FACT_KEYWORDS', 'INSERTION_DATETIME') }}