SELECT
  date_trunc('day', block_timestamp) as date,
  fee[0]:denom::string as currency,
  AVG(fee[0]:amount)/POW(10,6) as fee
FROM terra.transactions
WHERE currency = 'uusd'
AND date_trunc('day', block_timestamp)>'2021-05-06'
GROUP BY 1,2
ORDER BY 1 DESC