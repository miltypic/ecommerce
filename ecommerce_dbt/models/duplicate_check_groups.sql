{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_groups') }}

{{ duplicate_detection('PROD.EVENTS.FACT_GROUPS', ['DATETIME', 'SEARCHID']) }}