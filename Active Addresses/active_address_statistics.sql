WITH q1table AS(
  SELECT
  block_timestamp,
  delegator_address,
  ROW_NUMBER() OVER(PARTITION by delegator_address ORDER BY block_timestamp DESC) AS DuplicateCount
FROM terra.staking
WHERE date_trunc('day', block_timestamp)>'2021-01-01'
  AND date_trunc('day', block_timestamp)<'2021-03-31'
),
q1noDuplicates AS(
  SELECT
  block_timestamp as block_timestamp1,
  delegator_address as delegator_address1
  FROM
  q1table
  WHERE
  DuplicateCount = 1
),
  june30table AS(
  SELECT
  block_timestamp,
  action,
  delegator_address,
  ROW_NUMBER() OVER(PARTITION by delegator_address ORDER BY block_timestamp DESC) AS DuplicateCount
FROM terra.staking
WHERE date_trunc('day', block_timestamp)='2021-06-30'
AND action='delegate'
),
june30noDuplicates AS(
  SELECT
  block_timestamp as block_timestamp2,
  delegator_address as delegator_address2
  FROM
  june30table
  WHERE
  DuplicateCount = 1
)
SELECT
  COUNT(block_timestamp1) AS Total_Active_Addresses_Q1,
  COUNT(block_timestamp2) AS Total_Active_Addresses_June30,
  Total_Active_Addresses_June30 / Total_Active_Addresses_Q1 AS Active_Addresses_PCT
FROM
q1noDuplicates
LEFT OUTER JOIN
june30noDuplicates
ON
q1noDuplicates.delegator_address1 = june30noDuplicates.delegator_address2
ORDER BY block_timestamp1, block_timestamp2, delegator_address1