{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_keywords') }}

{{ duplicate_detection('PROD.EVENTS.FACT_KEYWORDS', ['DATETIME', 'SEARCHID', 'KEYWORD']) }}