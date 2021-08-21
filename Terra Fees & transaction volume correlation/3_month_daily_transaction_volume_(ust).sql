SELECT
  date_trunc('day', block_timestamp) as date,
  SUM(event_amount) as daily_volume
FROM terra.transfers
WHERE date_trunc('day', block_timestamp)>'2021-05-06'
AND event_currency = 'UST'
GROUP BY 1
ORDER BY 1 DESC