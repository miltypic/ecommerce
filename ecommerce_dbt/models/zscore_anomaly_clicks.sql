{{ config(
    materialized='view',
    database='prod',
    schema='events'
   )
  }}

-- depends_on = {{ ref('fact_clicks') }}

{{ zscore_anomaly_detection('PROD.EVENTS.FACT_CLICKS', 'DATETIME', 'CLICKID') }}