-- Credit fund metrics formatted as a table
with fund_data as (
  select * from metrics_fund_performance
  where fund_id = '${params.id}'
  order by period_end_date desc
  limit 1
),
latest_snapshots as (
  select instrument_id, max(period_end_date) as latest_period
  from metrics_position_performance
  where fund_id = '${params.id}'
  group by instrument_id
),
position_count as (
  select count(*) as position_count
  from metrics_position_performance mpp
  inner join latest_snapshots ls 
    on mpp.instrument_id = ls.instrument_id 
    and mpp.period_end_date = ls.latest_period
  where mpp.fund_id = '${params.id}'
    and mpp.instrument_type = 'CREDIT'
)
select 'Total Exposure' as metric, total_exposure as value, 'usd2m' as format from fund_data
union all select 'Principal Outstanding', principal_outstanding, 'usd2m' from fund_data
union all select 'Undrawn Commitment', undrawn_commitment, 'usd2m' from fund_data
union all select 'Interest Income', interest_income, 'usd2m' from fund_data
union all select 'Total Commitments', total_commitments, 'usd2m' from fund_data
union all select 'Total Called Capital', total_called_capital, 'usd2m' from fund_data
union all select 'Total Distributions', total_distributions, 'usd2m' from fund_data
union all select 'Number of Positions', (select position_count from position_count), 'num0'
