with filtered as (
  select
    date_trunc('month', cast(exposure_month as timestamp)) as month,
    region,
    deployed_capital_usd,
    period_type
  from metrics_exposure_timeseries
  where 1=1
    and (fund_id = '${inputs.fund.value}' or '${inputs.fund.value}' = 'ALL')
    and (stage_id = '${inputs.stage.value}' or '${inputs.stage.value}' = 'ALL' or stage_id is null)
), first_current_month as (
  select min(month) as min_month from filtered where period_type = 'Current'
)
select
  region,
  sum(coalesce(deployed_capital_usd, 0)) as total_exposure_usd
from filtered
where period_type = 'Current'
  and month = (select min_month from first_current_month)
group by 1
order by total_exposure_usd desc


