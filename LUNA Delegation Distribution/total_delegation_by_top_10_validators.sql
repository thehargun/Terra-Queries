WITH validators AS(
  SELECT
  date_trunc('day', block_timestamp) as date,
  address,
  voting_power,
  ROW_NUMBER() OVER(PARTITION by address, date ORDER BY block_timestamp DESC) AS DuplicateCount
  FROM
  terra.validator_voting_power
  WHERE date>'2021-08-05'
), validators_info AS (
  SELECT date,
  address as valconaddress,
  voting_power
  FROM validators
  WHERE DuplicateCount = 1
  ORDER BY voting_power DESC
  limit 10
)
  SELECT
  SUM(voting_power) as total_delegation,
  SUM(voting_power)*0.95 as ninety_five_pct_total_delegation
  FROM validators_info

