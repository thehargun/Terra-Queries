WITH q1table AS(
  SELECT
  block_timestamp,
  action,
  delegator_address,
  ROW_NUMBER() OVER(PARTITION by delegator_address ORDER BY block_timestamp DESC) AS DuplicateCount
FROM terra.staking
WHERE date_trunc('day', block_timestamp)>'2021-01-01'
  AND date_trunc('day', block_timestamp)<'2021-03-31'
AND action='delegate'
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
SELECT *
FROM
q1noDuplicates