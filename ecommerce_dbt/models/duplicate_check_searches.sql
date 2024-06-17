{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_searches') }}

{{ duplicate_detection('PROD.EVENTS.FACT_SEARCHES', ['DATETIME', 'SEARCHID']) }}