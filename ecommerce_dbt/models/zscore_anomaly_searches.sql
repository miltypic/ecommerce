{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_searches') }}

{{ zscore_anomaly_detection('PROD.EVENTS.FACT_SEARCHES', 'DATETIME', 'SEARCHID') }}