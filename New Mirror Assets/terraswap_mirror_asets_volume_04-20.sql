WITH mAssetVolume AS(
  SELECT
  date_trunc('hour', block_timestamp) as day,
  sum(msg_value:coins[0]:amount::string)/POW(10,6) as amount_uusd,
  msg_value:contract::string as contract
FROM
  terra.msgs
WHERE
  tx_status = 'SUCCEEDED'
  AND MSG_TYPE = 'wasm/MsgExecuteContract'
  AND date_trunc('day', block_timestamp) = '2021-04-20'
GROUP BY
  1,3
),
mAssetVolumeNoBlank AS (
  SELECT *
  FROM mAssetVolume
  WHERE amount_uusd IS NOT NULL 
),
mAssetNames AS (
  SELECT DISTINCT ADDRESS, ADDRESS_NAME 
  FROM terra.labels
  WHERE ADDRESS_NAME LIKE 'm%' OR ADDRESS_NAME LIKE 'Terraswap m%'
)
SELECT
  day,
  amount_uusd,
  contract,
  address_name
FROM mAssetVolumeNoBlank
INNER JOIN mAssetNames ON mAssetVolumeNoBlank.contract = mAssetNames.address
ORDER BY 1 DESC