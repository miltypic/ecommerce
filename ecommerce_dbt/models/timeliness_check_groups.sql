{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_groups') }}

{{ timeliness_check('PROD.EVENTS.FACT_GROUPS', 'INSERTION_DATETIME') }}