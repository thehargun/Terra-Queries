WITH maintable AS(
  SELECT
  date_trunc('day', block_timestamp) as dates,
  address,
  voting_power,
  ROW_NUMBER() OVER(PARTITION by address, dates ORDER BY block_timestamp DESC) AS DuplicateCount
  
  FROM
  terra.validator_voting_power
  where dates>'2021-07-01'
),
noDuplicates AS(
  SELECT
  dates,
  address,
  voting_power,
  DuplicateCount,
  row_number() over (PARTITION BY dates ORDER BY voting_power DESC) as voting_rank
  FROM
  maintable
  WHERE
  DuplicateCount = 1
  ),
top5 AS(
  SELECT
  dates,
  address,
  voting_power,
  voting_rank
  FROM
  NoDuplicates
  WHERE
  voting_rank <= 5
),
labeltable AS(
  SELECT
  delegator_address,
  label,
  operator_address,
  vp_address
  
  FROM
  terra.validator_labels
),
finaltable AS(
  	SELECT *
	FROM
    top5
	INNER JOIN
    labeltable
	ON
    top5.address = labeltable.vp_address
),
  selfdelegationbalance AS(
    SELECT 
    *
    FROM
    terra.daily_balances
    WHERE
    currency = 'LUNA'
    AND balance_type = 'staked'
  ),
  finalfinal AS(
  	SELECT *
	FROM
    finaltable
	INNER JOIN
    selfdelegationbalance
	ON
    finaltable.delegator_address = selfdelegationbalance.address
	AND finaltable.dates = selfdelegationbalance.date
  )
SELECT
date,
delegator_address,
voting_power,
voting_rank,
label,
operator_address,
vp_address,
balance,
(balance/voting_power)*100 AS self_delegation_proportion
FROM
finalfinal
ORDER BY date DESC