-- Credit fund metrics formatted as a table with deployment metrics
with fund_data as (
  select 
    *,
    -- Calculate deployment metrics
    total_called_capital - coalesce(total_exposure, 0) as cash_and_reserves,
    case 
      when total_commitments > 0 
      then coalesce(total_exposure, 0) / total_commitments 
      else 0 
    end as facility_deployment_rate,
    case 
      when coalesce(total_exposure, 0) > 0 
      then coalesce(principal_outstanding, 0) / coalesce(total_exposure, 0)
      else 0 
    end as facility_utilization_rate
  from metrics_fund_performance
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
-- Capital Deployment Section
select 'LP Commitments' as metric, total_commitments as value, 'usd2m' as format from fund_data
union all select 'Called Capital', total_called_capital, 'usd2m' from fund_data
union all select 'Facility Commitments', total_exposure, 'usd2m' from fund_data
union all select 'Principal Outstanding', principal_outstanding, 'usd2m' from fund_data
union all select 'Undrawn Facilities', undrawn_commitment, 'usd2m' from fund_data
union all select 'Cash & Reserves', cash_and_reserves, 'usd2m' from fund_data
union all select 'Facility Deployment Rate', facility_deployment_rate, 'pct1' from fund_data
union all select 'Facility Utilization', facility_utilization_rate, 'pct1' from fund_data
-- Performance Section
union all select 'Interest Income', interest_income, 'usd2m' from fund_data
union all select 'Total Distributions', total_distributions, 'usd2m' from fund_data
union all select 'Number of Positions', (select position_count from position_count), 'num0'
