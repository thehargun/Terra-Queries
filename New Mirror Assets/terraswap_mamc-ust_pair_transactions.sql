WITH mAssetVolume AS(
  SELECT
  block_timestamp,
  (msg_value:coins[0]:amount::string)/POW(10,6) as amount,
  msg_value:contract::string as contract
FROM
  terra.msgs
WHERE
  tx_status = 'SUCCEEDED'
  AND MSG_TYPE = 'wasm/MsgExecuteContract'
),
mAssetVolumeNoBlank AS (
  SELECT *
  FROM mAssetVolume
  WHERE amount IS NOT NULL 
),
mAssetNames AS (
  SELECT DISTINCT ADDRESS, ADDRESS_NAME 
  FROM terra.labels
  WHERE ADDRESS_NAME LIKE 'm%' OR ADDRESS_NAME LIKE 'Terraswap m%'
)
SELECT
  block_timestamp,
  amount,
  contract,
  address_name
FROM mAssetVolumeNoBlank
INNER JOIN mAssetNames ON mAssetVolumeNoBlank.contract = mAssetNames.address
WHERE ADDRESS_NAME = 'Terraswap mAMC-UST Pair'
ORDER BY block_timestamp
limit 5