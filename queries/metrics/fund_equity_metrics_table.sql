-- Equity fund metrics formatted as a table
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
company_count as (
  select count(distinct mpp.company_name) as company_count
  from metrics_position_performance mpp
  inner join latest_snapshots ls 
    on mpp.instrument_id = ls.instrument_id 
    and mpp.period_end_date = ls.latest_period
  where mpp.fund_id = '${params.id}'
    and mpp.instrument_type = 'EQUITY'
)
select 'Fund NAV' as metric, fund_nav as value, 'usd2m' as format from fund_data
union all select 'TVPI', tvpi, 'num1' from fund_data
union all select 'DPI', dpi, 'num1' from fund_data
union all select 'RVPI', rvpi, 'num1' from fund_data
union all select 'Total Commitments', total_commitments, 'usd2m' from fund_data
union all select 'Unfunded Commitment', unfunded_commitment, 'usd2m' from fund_data
union all select 'Total Distributions', total_distributions, 'usd2m' from fund_data
union all select 'Portfolio Companies', (select company_count from company_count), 'num0'
