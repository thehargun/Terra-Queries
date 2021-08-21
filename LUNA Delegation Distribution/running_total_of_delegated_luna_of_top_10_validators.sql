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
  date,
  valconaddress,
  voting_power,
  SUM (voting_power) OVER (ORDER BY voting_power DESC) AS voting_power_total
  FROM validators_info
  ORDER BY voting_power DESC

